import 'dart:developer';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_fe/core/database/permission_handler.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
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
      final storagenStatus = await Permission.storage.status;

      if (!permissionStatus.isGranted && !storagenStatus.isGranted) {
        if (context.mounted) await PermissionHandler.requestStoragePermissions(context);
        final updatedStatus = await Permission.manageExternalStorage.status;
        if (!updatedStatus.isGranted) {
          log("Permission still not granted. Cannot proceed with backup.");
          return;
        }
      } else {
        log("Permission granted");
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
        await backupFolder.create(recursive: true);

        final previousBackupFiles = backupFolder.listSync().where((file) => file.path.endsWith('.zip')).toList();

        if (previousBackupFiles.length > 4) {
          previousBackupFiles
              .sort((a, b) => File(a.path).lastModifiedSync().compareTo(File(b.path).lastModifiedSync()));

          final filesToDelete = previousBackupFiles.take(previousBackupFiles.length - 4);

          for (var file in filesToDelete) {
            await file.delete();
            log("Deleted old backup file: ${file.path}");
          }
        }

        final timestamp = Helpers.formatDTToString(DateTime.now());
        final backupPath = '${backupFolder.path}/backup.db';

        final dbFile = File(path);
        await dbFile.copy(backupPath);

        // Zip the database file
        final zipPath = join(backupFolder.path, "backup_$timestamp.zip");

        final encoder = ZipEncoder();
        final archiveFile = ArchiveFile('backup.db', dbFile.lengthSync(), dbFile.readAsBytesSync());
        final archive = Archive()..addFile(archiveFile);
        final bytes = encoder.encode(archive);

        final zipFile = File(zipPath);
        await zipFile.writeAsBytes(bytes!);

        if (context.mounted) {
          Navigator.pop(context);
          log("Database backed up to $zipPath");
          SnackBarHelper.presentSuccessSnackBar(context, "Database backed up at ${backupFolder.path}");
        }
      }
    } catch (e) {
      log("Error backing up database: $e");
      rethrow;
    }
  }
}
