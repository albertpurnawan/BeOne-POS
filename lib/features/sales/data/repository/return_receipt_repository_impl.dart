// import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/sales/data/data_sources/remote/return_service.dart';
import 'package:pos_fe/features/sales/data/models/customer.dart';
import 'package:pos_fe/features/sales/data/models/pos_parameter.dart';
import 'package:pos_fe/features/sales/data/models/return_receipt.dart';
import 'package:pos_fe/features/sales/data/models/return_receipt_remote.dart';
import 'package:pos_fe/features/sales/domain/entities/return_receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';
import 'package:pos_fe/features/sales/domain/repository/return_receipt_repository.dart';

class ReturnReceiptRepositoryImpl implements ReturnReceiptRepository {
  final AppDatabase _appDatabase;
  final ReturnApi _returnApi;

  ReturnReceiptRepositoryImpl(this._appDatabase, this._returnApi);

  @override
  Future<ReturnReceiptEntity> getReturnReceiptByDocNum({required String invoiceDocNum}) async {
    try {
      final ReturnReceiptModel returnReceiptModel;

      // 1. Get current store master
      final POSParameterModel? pos = (await _appDatabase.posParameterDao.readAll()).firstOrNull;
      if (pos == null) throw "POS Parameter not found for fetching invoice";
      if (pos.tostrId == null) throw "Invalid POS Parameter for fetching invoice";
      final StoreMasterEntity? storeMasterEntity =
          await GetIt.instance<AppDatabase>().storeMasterDao.readByDocId(pos.tostrId!, null);
      if (storeMasterEntity == null) throw "Store master not found for fetching invoice";

      // 2. Fetch return receipt
      final ReturnReceiptRemoteModel returnReceiptRemoteModel =
          await _returnApi.fetchData(invoiceDocNum, storeMasterEntity.storeCode);

      // 3. Validate transdatetime
      if (returnReceiptRemoteModel.transDateTime == null) {
        throw "Transaction date time not found after fetching invoice";
      }

      // 4. Validate store code and assign to fetched invoice
      if (returnReceiptRemoteModel.storeCode != storeMasterEntity.storeCode) {
        throw "Conflicting store code after fetching invoice";
      }

      // 5. Add customer data to return receipt
      final CustomerModel? customerModel =
          await _appDatabase.customerDao.readByCustCode(returnReceiptRemoteModel.custCode, null);
      if (customerModel == null) throw "Customer not found after fetching invoice";

      // 6. Assign to ReturnReceiptModel
      returnReceiptModel = ReturnReceiptModel(
        customerEntity: customerModel,
        storeMasterEntity: storeMasterEntity,
        receiptEntity: returnReceiptRemoteModel,
        transDateTime: returnReceiptRemoteModel.transDateTime!,
        timezone: returnReceiptRemoteModel.timezone,
      );

      return returnReceiptModel;
    } catch (e) {
      rethrow;
    }
  }
}
