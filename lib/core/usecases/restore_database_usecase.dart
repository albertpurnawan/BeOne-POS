// ignore_for_file: unused_local_variable

import 'dart:developer';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_fe/core/database/permission_handler.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/core/widgets/progress_indicator.dart';
import 'package:sqflite/sqflite.dart';

class RestoreDatabaseParams {
  final BuildContext context;

  RestoreDatabaseParams({required this.context});
}

class RestoreDatabaseUseCase implements UseCase<void, RestoreDatabaseParams> {
  final _databaseName = "pos_fe.db";

  @override
  Future<void> call({RestoreDatabaseParams? params}) async {
    if (params == null) return;

    final context = params.context;
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
      final path = join(dbPath, _databaseName);

      const backupDir = "/storage/emulated/0";
      final backupFolder = Directory('$backupDir/RubyPOS');

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
      final archive = ZipDecoder().decodeBytes(bytes, password: "BeOne\$\$123");

      for (final file in archive) {
        final filename = file.name;
        final data = file.content as List<int>;
        File(join(backupFolder.path, filename))
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      }

      final restoredPath = join(backupFolder.path, "backup.db");
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
    } catch (e) {
      log("Error restoring database: $e");
      rethrow;
    }
  }
}
