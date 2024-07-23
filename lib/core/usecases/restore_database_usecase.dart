// ignore_for_file: unused_local_variable

import 'dart:developer';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_fe/core/database/app_database.dart';
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
    final context = params!.context;
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

      final backupDir = await getExternalStorageDirectory();
      final backupPath = join(backupDir!.path, "backup.db");

      final dbFile = File(path);
      await dbFile.copy(backupPath);

      final zipPath = join(backupDir.path, "backup.zip");

      final zipFile = File(zipPath);
      if (await zipFile.exists()) {
        final bytes = zipFile.readAsBytesSync();
        final archive = ZipDecoder().decodeBytes(bytes);
        for (final file in archive) {
          final filename = file.name;
          final data = file.content as List<int>;
          File(join(backupDir.path, filename))
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);
        }

        final restoredPath = join(backupDir.path, "backup.db");
        final restoredFile = File(restoredPath);
        await restoredFile.copy(path);

        log("Database restored from $zipPath");
        database = null;
        await GetIt.instance<AppDatabase>().getDB();
      } else {
        log("Backup file does not exist at $zipPath");
      }

      if (context.mounted) {
        Navigator.pop(context);
        log("Database backed up to $zipPath");
        SnackBarHelper.presentSuccessSnackBar(context, "Database restored successfully!");
      }
    } catch (e) {
      log("Error restoring database: $e");
      rethrow;
    }
  }
}
