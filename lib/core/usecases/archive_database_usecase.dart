import 'dart:convert';
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

class ArchiveDatabaseParams {
  final BuildContext context;
  final DateTime startDate;
  final DateTime endDate;

  ArchiveDatabaseParams(this.startDate, this.endDate, {required this.context});
}

class ArchiveDatabaseUseCase implements UseCase<void, ArchiveDatabaseParams> {
  final decryptPasswordUseCase = GetIt.instance<DecryptPasswordUseCase>();

  @override
  Future<void> call({ArchiveDatabaseParams? params}) async {
    final context = params!.context;
    final start = params.startDate;
    final end = params.endDate;
    final tableData = {};

    try {
      if (Platform.isAndroid) {
        final permissionStatus = await Permission.manageExternalStorage.status;
        final storageStatus = await Permission.storage.status;

        if (!permissionStatus.isGranted && !storageStatus.isGranted) {
          if (context.mounted) await PermissionHandler.requestStoragePermissions(context);
          final updatedStatus = await Permission.manageExternalStorage.status;
          if (!updatedStatus.isGranted) {
            log("Permission still not granted. Cannot proceed with archive.");
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

      Directory archiveFolder;
      if (Platform.isWindows) {
        final userProfile = Platform.environment['USERPROFILE'];
        if (userProfile == null) {
          throw Exception('Could not determine user profile directory');
        }
        final archiveDir = p.join(userProfile, 'Documents', 'app', 'RubyPOS', 'archive');
        archiveFolder = Directory(archiveDir);
        log("archiveDir W - $archiveDir");
        log("archiveFolder W - $archiveFolder");
      } else if (Platform.isAndroid) {
        const archiveDir = "/storage/emulated/0";
        archiveFolder = Directory('$archiveDir/RubyPOS/archive');
      } else if (Platform.isIOS) {
        final documentsDir = await getApplicationDocumentsDirectory();
        final archiveDir = p.join(documentsDir.path, 'RubyPOS', 'archive');
        archiveFolder = Directory(archiveDir);
      } else {
        throw UnsupportedError("Unsupported platform");
      }

      await archiveFolder.create(recursive: true);

      // if need delete previous archive here
      //

      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');

      final zipPath = p.join(archiveFolder.path, "archive_$timestamp.zip");

      final topos = await GetIt.instance<AppDatabase>().posParameterDao.readAll();
      final decryptPass = await decryptPasswordUseCase.call(params: topos[0].passwordAdmin);

      final encoder = ZipEncoder(password: decryptPass);
      final archive = Archive();

      final tableTcsr1 = await GetIt.instance<AppDatabase>().cashierBalanceTransactionDao.getTableData(start, end);
      tableData['tcsr1'] = tableTcsr1;

      final toinvData = <Map<String, dynamic>>[];
      final tinv1Data = <Map<String, dynamic>>[];
      final tinv2Data = <Map<String, dynamic>>[];
      final tinv5Data = <Map<String, dynamic>>[];
      final tinv6Data = <Map<String, dynamic>>[];

      for (final entry in tableTcsr1['tcsr1'] ?? []) {
        final tcsr1docid = entry['docid'];

        final tableToinv = await GetIt.instance<AppDatabase>().invoiceHeaderDao.getTableData(tcsr1docid, start, end);
        toinvData.addAll(tableToinv['toinv'] ?? []);

        for (final entry in tableToinv['toinv'] ?? []) {
          final toinvdocid = entry['docid'];
          final tableTinv1 = await GetIt.instance<AppDatabase>().invoiceDetailDao.getTableData(toinvdocid, start, end);
          final tableTinv2 = await GetIt.instance<AppDatabase>().payMeansDao.getTableData(toinvdocid, start, end);
          final tableTinv5 =
              await GetIt.instance<AppDatabase>().invoiceAppliedPromoDao.getTableData(toinvdocid, start, end);
          final tableTinv6 =
              await GetIt.instance<AppDatabase>().approvalInvoiceDao.getTableData(toinvdocid, start, end);

          tinv1Data.addAll(tableTinv1['tinv1'] ?? []);
          tinv2Data.addAll(tableTinv2['tinv2'] ?? []);
          tinv5Data.addAll(tableTinv5['tinv5'] ?? []);
          tinv6Data.addAll(tableTinv6['tinv6'] ?? []);

          await GetIt.instance<AppDatabase>().approvalInvoiceDao.deleteArchived(toinvdocid, start, end);
          await GetIt.instance<AppDatabase>().invoiceAppliedPromoDao.deleteArchived(toinvdocid, start, end);
          await GetIt.instance<AppDatabase>().payMeansDao.deleteArchived(toinvdocid, start, end);
          await GetIt.instance<AppDatabase>().invoiceDetailDao.deleteArchived(toinvdocid, start, end);
          await GetIt.instance<AppDatabase>().invoiceHeaderDao.deleteArchived(tcsr1docid, start, end);
          await GetIt.instance<AppDatabase>().cashierBalanceTransactionDao.deleteArchived(start, end);
        }
      }

      tableData['toinv'] = toinvData;
      tableData['tinv1'] = tinv1Data;
      tableData['tinv2'] = tinv2Data;
      tableData['tinv5'] = tinv5Data;
      tableData['tinv6'] = tinv6Data;

      for (final tableName in tableData.keys) {
        final tableDataAsBytes = utf8.encode(jsonEncode(tableData[tableName]));
        final archiveFile = ArchiveFile('$tableName.json', tableDataAsBytes.length, tableDataAsBytes);
        archive.addFile(archiveFile);
      }

      final bytes = await compute((archive) => encoder.encode(archive), archive);

      final zipFile = File(zipPath);
      await zipFile.writeAsBytes(bytes!);

      log("Database archived to $zipPath");
      if (context.mounted) {
        SnackBarHelper.presentSuccessSnackBar(context, "Database archived to $zipPath");
      }
    } catch (e) {
      log("Error archiving database: $e");
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
