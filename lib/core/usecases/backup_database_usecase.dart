import 'dart:developer';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_fe/core/database/permission_handler.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/core/widgets/progress_indicator.dart';
import 'package:sqflite/sqflite.dart';

class BackupDatabaseParams {
  final BuildContext context;

  BackupDatabaseParams({required this.context});
}

class BackupDatabaseUseCase implements UseCase<void, BackupDatabaseParams> {
  final _databaseName = "pos_fe.db";

  @override
  Future<void> call({BackupDatabaseParams? params}) async {
    final context = params!.context;
    try {
      final permissionStatus = await Permission.manageExternalStorage.status;

      if (!permissionStatus.isGranted) {
        if (context.mounted) await PermissionHandler.requestStoragePermissions(context);
        final updatedStatus = await Permission.manageExternalStorage.status;
        if (!updatedStatus.isGranted) {
          log("Permission still not granted. Cannot proceed with backup.");
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

      final backupDir = await getExternalStorageDirectory();
      final backupPath = join(backupDir!.path, "backup.db");

      final dbFile = File(path);
      await dbFile.copy(backupPath);

      // Zip the database file
      final zipPath = join(backupDir.path, "backup.zip");

      final encoder = ZipEncoder();
      final archiveFile = ArchiveFile('backup.db', dbFile.lengthSync(), dbFile.readAsBytesSync());
      final archive = Archive()..addFile(archiveFile);
      final bytes = encoder.encode(archive);

      final zipFile = File(zipPath);
      await zipFile.writeAsBytes(bytes!);

      if (context.mounted) {
        Navigator.pop(context);
        log("Database backed up to $zipPath");
        SnackBarHelper.presentSuccessSnackBar(context, "Database backed up successfully!");
      }
    } catch (e) {
      log("Error backing up database: $e");
      rethrow;
    }
  }
}
