// ignore_for_file: unused_local_variable

import 'dart:developer';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_fe/core/database/permission_handler.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/core/widgets/progress_indicator.dart';
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
      log("Restoring from backup file: ${mostRecentBackup.path}");

      final bytes = File(mostRecentBackup.path).readAsBytesSync();

      final archive = ZipDecoder().decodeBytes(bytes, password: password);

      for (final file in archive) {
        final filename = file.name;
        final data = file.content as List<int>;
        File(p.join(backupFolder.path, filename))
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      }

      final restoredPath = p.join(backupFolder.path, "backup.db");
      final restoredFile = File(restoredPath);

      if (await restoredFile.exists()) {
        await restoredFile.copy(path);
        if (context.mounted) {
          Navigator.pop(context);
          log("Database restored from $restoredPath");
          SnackBarHelper.presentSuccessSnackBar(context, "Database restored successfully!");
        }
      } else {
        if (context.mounted) {
          log("Restored file does not exist at $restoredPath");
          SnackBarHelper.presentErrorSnackBar(context, "Restored file does not exist at $restoredPath.");
        }
      }
      await restoredFile.delete();
    } catch (e) {
      log("Error restoring database: $e");
      rethrow;
    }
  }
}
