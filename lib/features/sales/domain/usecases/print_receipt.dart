// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/resources/receipt_printer.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/cash_register.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/print_receipt_detail.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';
import 'package:pos_fe/features/sales/domain/repository/pos_paramater_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/receipt_content_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/store_master_repository.dart';
import 'package:pos_fe/features/settings/domain/entities/receipt_content.dart';

class PrintReceiptUseCase implements UseCase<void, PrintReceiptUseCaseParams?> {
  // POS Parameter
  final POSParameterRepository _posParameterRepository;
  final StoreMasterRepository _storeMasterRepository;
  final ReceiptContentRepository _receiptContentRepository;
  final ReceiptPrinter _receiptPrinter;

  PrintReceiptUseCase(
      this._posParameterRepository, this._storeMasterRepository, this._receiptContentRepository, this._receiptPrinter);
  // Store
  // Receipt kurang tovat, tohem, toven

  @override
  Future<void> call({PrintReceiptUseCaseParams? params}) async {
    /**
     * Algoritma
     * 1. Ambil receipt content
     * 2. Masukkin kondisional
     * 3. Langsung jadi bytes
     */

    try {
      if (params == null) throw "PrintReceiptUseCaseParams required";

      final POSParameterEntity posParameterEntity = await _posParameterRepository.getPosParameter();
      if (posParameterEntity.tostrId == null || posParameterEntity.tocsrId == null) throw "Incomplete POS Parameter";

      final StoreMasterEntity? storeMasterEntity =
          await _storeMasterRepository.getStoreMaster(posParameterEntity.tostrId!);
      if (storeMasterEntity == null) throw "Store not found";

      final CashRegisterEntity? cashRegisterEntity =
          await GetIt.instance<AppDatabase>().cashRegisterDao.readByDocId(posParameterEntity.tocsrId!, null);
      if (cashRegisterEntity == null) throw "Cash Register not found";

      final List<ReceiptContentEntity?> receiptContentEntities = await _receiptContentRepository.getReceiptContents();
      final PrintReceiptDetail printReceiptDetail = PrintReceiptDetail(
        receiptEntity: params.receiptEntity,
        posParameterEntity: posParameterEntity,
        storeMasterEntity: storeMasterEntity,
        cashRegisterEntity: cashRegisterEntity,
        receiptContentEntities: receiptContentEntities,
        printType: params.printType,
      );

      await _receiptPrinter.printReceipt(printReceiptDetail, params.printType);
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
    }
  }
}

class PrintReceiptUseCaseParams {
  ReceiptEntity receiptEntity;
  int printType; // 1: normal bill, 2: draft bill, 3: copy bill

  PrintReceiptUseCaseParams({
    required this.receiptEntity,
    required this.printType,
  });
}
