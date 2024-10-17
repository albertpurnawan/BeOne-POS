import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/database/permission_handler.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/data/models/approval_invoice.dart';
import 'package:pos_fe/features/sales/data/models/batch_invoice.dart';
import 'package:pos_fe/features/sales/data/models/cashier_balance_transaction.dart';
import 'package:pos_fe/features/sales/data/models/invoice_applied_promo.dart';
import 'package:pos_fe/features/sales/data/models/invoice_detail.dart';
import 'package:pos_fe/features/sales/data/models/invoice_header.dart';
import 'package:pos_fe/features/sales/data/models/invoice_payment_other_voucher.dart';
import 'package:pos_fe/features/sales/data/models/pay_means.dart';
import 'package:pos_fe/features/sales/data/models/pos_parameter.dart';
import 'package:pos_fe/features/settings/domain/usecases/sync_data.dart';
import 'package:sqflite/sqflite.dart';

class RefreshDatabaseParams {
  final BuildContext context;

  RefreshDatabaseParams({required this.context});
}

class RefreshDatabaseUseCase implements UseCase<void, RefreshDatabaseParams> {
  final _databaseName = "pos_fe.db";
  final tablesToBackup = [
    tablePOSParameter,
    tableInvoiceHeader,
    tableInvoiceDetail,
    tablePayMeans,
    tableBatchInvoice,
    tableIPOV,
    tableInvoiceAppliedPromo,
    tableApprovalInvoice,
    tableCashierBalanceTransaction,
  ];

  @override
  Future<void> call({RefreshDatabaseParams? params}) async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _databaseName);

    if (params == null) {
      throw ArgumentError("RefreshDatabaseParams cannot be null.");
    }

    final context = params.context;
    try {
      if (Platform.isAndroid) {
        final permissionStatus = await Permission.manageExternalStorage.status;
        final storageStatus = await Permission.storage.status;

        if (!permissionStatus.isGranted && !storageStatus.isGranted) {
          if (context.mounted) await PermissionHandler.requestStoragePermissions(context);
          final updatedStatus = await Permission.manageExternalStorage.status;
          if (!updatedStatus.isGranted) {
            log("Permission still not granted. Cannot proceed with refresh.");
            return;
          }
        }
      }

      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      // ------ BACKUP SELECTED TABLES ------
      Directory backupFolder = await _getBackupFolder();
      await backupFolder.create(recursive: true);
      await backupSelectedTables(backupFolder, path);

      // ------ DROP DATABASE ------
      await GetIt.instance<AppDatabase>().resetDatabase();

      // ------ REINSERT DATA ------
      await restoreSelectedTables(backupFolder, path, [tablePOSParameter]);
      await syncData();
      await restoreSelectedTables(
          backupFolder, path, tablesToBackup.where((table) => table != tablePOSParameter).toList());

      // ------ DELETE JSON ------
      final backupFile = File(p.join(backupFolder.path, 'backup.json'));

      if (await backupFile.exists()) {
        await backupFile.delete();
        log("Backup JSON file deleted.");
      } else {
        log("Backup JSON file not found.");
      }

      if (context.mounted) {
        context.pop();
        context.pop();
      }
    } catch (e) {
      log("Error resetting the database: $e");
      rethrow;
    }
  }

  Future<Directory> _getBackupFolder() async {
    Directory backupFolder;
    if (Platform.isWindows) {
      final userProfile = Platform.environment['USERPROFILE'];
      if (userProfile == null) {
        throw Exception('Could not determine user profile directory');
      }
      final backupDir = p.join(userProfile, 'Documents', 'app', 'RubyPOS');
      backupFolder = Directory(backupDir);
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
    return backupFolder;
  }

  Future<void> backupSelectedTables(Directory backupFolder, String path) async {
    try {
      final database = await openDatabase(path);

      final backupData = <String, List<Map<String, dynamic>>>{};

      for (var table in tablesToBackup) {
        final data = await database.query(table);
        backupData[table] = data;
      }

      final jsonString = jsonEncode(backupData);

      final backupFile = File(p.join(backupFolder.path, 'backup.json'));
      await backupFile.writeAsString(jsonString);
    } catch (e) {
      // where to send error?
      rethrow;
    }
  }

  Future<void> restoreSelectedTables(Directory backupFolder, String path, List<String> tablesToRestore) async {
    try {
      final backupFile = File(p.join(backupFolder.path, 'backup.json'));

      if (!await backupFile.exists()) {
        throw Exception('Backup file not found');
      }

      final jsonString = await backupFile.readAsString();

      final backupData = jsonDecode(jsonString) as Map<String, dynamic>;

      final database = await openDatabase(path);

      for (var table in tablesToRestore) {
        if (backupData.containsKey(table)) {
          final tableData = backupData[table] as List<dynamic>;
          for (var row in tableData) {
            await database.insert(
              table,
              Map<String, dynamic>.from(row),
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
          log("Table $table has been restored successfully.");
        } else {
          log("Table $table was not found in the backup.");
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}
