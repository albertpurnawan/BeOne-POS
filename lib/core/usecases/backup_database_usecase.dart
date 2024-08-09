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
import 'package:pos_fe/features/settings/domain/usecases/decrypt.dart';
import 'package:sqflite/sqflite.dart';

class BackupDatabaseParams {
  final BuildContext context;

  BackupDatabaseParams({required this.context});
}

class BackupDatabaseUseCase implements UseCase<void, BackupDatabaseParams> {
  final _databaseName = "pos_fe.db";
  final decryptPasswordUseCase = GetIt.instance<DecryptPasswordUseCase>();

  @override
  Future<void> call({BackupDatabaseParams? params}) async {
    final context = params!.context;
    try {
      if (Platform.isAndroid) {
        final permissionStatus = await Permission.manageExternalStorage.status;
        final storageStatus = await Permission.storage.status;

        if (!permissionStatus.isGranted && !storageStatus.isGranted) {
          if (context.mounted) await PermissionHandler.requestStoragePermissions(context);
          final updatedStatus = await Permission.manageExternalStorage.status;
          if (!updatedStatus.isGranted) {
            log("Permission still not granted. Cannot proceed with backup.");
            return;
          }
        }
      }

      if (context.mounted) {
        log("Showing progress dialog");
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const Center(
            child: CircularProgressIndicator(),
          ),
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
        const backupDir = "/storage/emulated/0";
        backupFolder = Directory('$backupDir/RubyPOS');
      } else if (Platform.isIOS) {
        final documentsDir = await getApplicationDocumentsDirectory();
        final backupDir = p.join(documentsDir.path, 'RubyPOS');
        backupFolder = Directory(backupDir);
      } else {
        throw UnsupportedError("Unsupported platform");
      }

      await backupFolder.create(recursive: true);

      final previousBackupFiles = backupFolder.listSync().where((file) => file.path.endsWith('.zip')).toList();

      if (previousBackupFiles.length > 4) {
        previousBackupFiles.sort((a, b) => File(a.path).lastModifiedSync().compareTo(File(b.path).lastModifiedSync()));

        final filesToDelete = previousBackupFiles.take(previousBackupFiles.length - 4);

        for (var file in filesToDelete) {
          await file.delete();
          log("Deleted old backup file: ${file.path}");
        }
      }

      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final dbFile = File(path);

      // Zip the database file
      final zipPath = p.join(backupFolder.path, "backup_$timestamp.zip");

      final topos = await GetIt.instance<AppDatabase>().posParameterDao.readAll();
      final decryptPass = await decryptPasswordUseCase.call(params: topos[0].passwordAdmin);

      final encoder = ZipEncoder(password: decryptPass);
      final archiveFile = ArchiveFile('backup.db', dbFile.lengthSync(), dbFile.readAsBytesSync());
      final archive = Archive()..addFile(archiveFile);
      final bytes = await compute((archive) => encoder.encode(archive), archive);

      final zipFile = File(zipPath);
      await zipFile.writeAsBytes(bytes!);

      log("Database backed up to $zipPath");

      if (context.mounted) {
        SnackBarHelper.presentSuccessSnackBar(context, "Database backed up at ${backupFolder.path}", 3);
      }
    } catch (e) {
      log("Error backing up database: $e");
      if (context.mounted) {
        SnackBarHelper.presentErrorSnackBar(context, "Error backing up database: $e");
      }
      rethrow;
    } finally {
      if (context.mounted) {
        log("Closing progress dialog");
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }
}
