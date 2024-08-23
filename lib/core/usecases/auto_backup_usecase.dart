import 'dart:developer';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/settings/domain/usecases/decrypt.dart';
import 'package:sqflite/sqflite.dart';

class AutoBackupUseCase implements UseCase<void, void> {
  final _databaseName = "pos_fe.db";
  final decryptPasswordUseCase = GetIt.instance<DecryptUseCase>();

  @override
  Future<void> call({void params}) async {
    try {
      log("RUN AutoBackup");
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
    } catch (e) {
      log("Error backing up database: $e");

      rethrow;
    }
  }
}
