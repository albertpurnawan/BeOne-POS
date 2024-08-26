// ignore_for_file: unused_local_variable

import 'dart:developer';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/database/permission_handler.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/core/widgets/progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class RestoreDatabaseParams {
  final BuildContext context;
  final String password;

  RestoreDatabaseParams(this.password, {required this.context});
}

class RestoreDatabaseUseCase implements UseCase<void, RestoreDatabaseParams> {
  final _databaseName = "pos_fe.db";

  @override
  Future<void> call({RestoreDatabaseParams? params}) async {
    if (params == null) return;

    final context = params.context;
    final password = params.password;
    Database? database;

    try {
      final permissionStatus = await Permission.manageExternalStorage.status;

      if (!permissionStatus.isGranted) {
        if (context.mounted) await PermissionHandler.requestStoragePermissions(context);
        final updatedStatus = await Permission.manageExternalStorage.status;
        if (!updatedStatus.isGranted) {
          log("Permission still not granted. Cannot proceed with restore.");
          return;
        }
      }
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => progressDialog,
        );
      }

      final dbPath = await getDatabasesPath();
      final path = p.join(dbPath, _databaseName);

      Directory backupFolder;
      if (Platform.isWindows) {
        final userProfile = Platform.environment['USERPROFILE'];
        if (userProfile == null) {
          throw Exception('Could not determine user profile directory');
        }
        final backupDir = p.join(userProfile, 'Documents', 'app', 'RubyPOS');
        backupFolder = Directory(backupDir);
        log("backupDir W - $backupDir");
        log("backupFolder W - $backupFolder");
      } else if (Platform.isAndroid) {
        const backupDir = "/storage/emulated/0/RubyPOS";
        backupFolder = Directory(backupDir);
      } else if (Platform.isIOS) {
        final documentsDir = await getApplicationDocumentsDirectory();
        final backupDir = p.join(documentsDir.path, 'RubyPOS');
        backupFolder = Directory(backupDir);
      } else {
        throw UnsupportedError("Unsupported platform");
      }

      final backupFiles = backupFolder.listSync().where((file) => file.path.endsWith('.zip')).toList()
        ..sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));

      if (backupFiles.isEmpty) {
        if (context.mounted) {
          log("No backup files found in $backupFolder");
          SnackBarHelper.presentErrorSnackBar(context, "No backup files found.");
        }
        return;
      }

      final mostRecentBackup = backupFiles.first;
      log("Restoring from backup file: ${mostRecentBackup.path} to $path");

      final restoredPath = await compute(restoreDatabaseFucntion, {
        'backupFolderPath': backupFolder.path,
        'mostRecentBackupPath': mostRecentBackup.path,
        'path': path,
        'password': password,
      });
      // Close the database connection
      await GetIt.instance<AppDatabase>().close();

      // Rename original file if it's not open by another process
      final originalFile = File(path);
      final renamedOriginal = "${path}_01";
      try {
        await originalFile.rename(renamedOriginal);
      } catch (e) {
        log("Failed to rename the original file. It may be in use.");
        if (context.mounted) {
          SnackBarHelper.presentErrorSnackBar(context, "Failed to rename the original file. It may be in use.");
        }
        return;
      }

      // Continue with restoration logic if renaming was successful
      final restoredFile = File(restoredPath);
      if (await restoredFile.exists()) {
        try {
          await restoredFile.copy(path);
          await File(renamedOriginal).delete(); // Remove backup if the copy was successful
          await GetIt.instance<AppDatabase>().getDB();
          if (context.mounted) {
            Navigator.pop(context);
            log("Database restored from $restoredPath");
            SnackBarHelper.presentSuccessSnackBar(context, "Database restored successfully!", 3);
          }
        } catch (e) {
          // If copy unsuccessful, attempt to restore original state
          await File(renamedOriginal).rename(path);

          if (context.mounted) {
            log("Failed to restore the database. Reverting to the original.");
            SnackBarHelper.presentErrorSnackBar(context, "Failed to restore the database. Reverting to the original.");
          }
          rethrow;
        }
      }

      await restoredFile.delete();

      final prefs = await GetIt.instance<SharedPreferences>().clear();
    } catch (e) {
      log("Error restoring database: $e");
      if (context.mounted) {
        SnackBarHelper.presentErrorSnackBar(context, "Error restoring database: $e");
        Navigator.pop(context);
      }
      rethrow;
    }
  }
}

Future<String> restoreDatabaseFucntion(Map<String, dynamic> params) async {
  final String backupFolderPath = params['backupFolderPath'];
  final String mostRecentBackupPath = params['mostRecentBackupPath'];
  final String path = params['path'];
  final String password = params['password'];

  final backupFolder = Directory(backupFolderPath);
  final mostRecentBackup = File(mostRecentBackupPath);

  final bytes = mostRecentBackup.readAsBytesSync();
  final archive = ZipDecoder().decodeBytes(bytes, password: password);

  for (final file in archive) {
    final filename = file.name;
    final data = file.content as List<int>;

    File(p.join(backupFolder.path, filename))
      ..createSync(recursive: true)
      ..writeAsBytesSync(data);
  }

  final restoredPath = p.join(backupFolder.path, "backup.db");
  return restoredPath;
}
