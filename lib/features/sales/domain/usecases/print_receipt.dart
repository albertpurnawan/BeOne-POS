import 'package:pos_fe/core/resources/receipt_printer.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/data/models/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/print_receipt_detail.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';
import 'package:pos_fe/features/sales/domain/repository/pos_paramater_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/receipt_content_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/store_master_repository.dart';
import 'package:pos_fe/features/settings/domain/entities/receipt_content.dart';

class PrintReceiptUseCase implements UseCase<void, ReceiptEntity?> {
  // POS Parameter
  final POSParameterRepository _posParameterRepository;
  final StoreMasterRepository _storeMasterRepository;
  final ReceiptContentRepository _receiptContentRepository;
  final ReceiptPrinter _receiptPrinter;

  PrintReceiptUseCase(this._posParameterRepository, this._storeMasterRepository,
      this._receiptContentRepository, this._receiptPrinter);
  // Store
  // Receipt kurang tovat, tohem, toven

  @override
  Future<void> call({ReceiptEntity? params}) async {
    /**
     * Algoritma
     * 1. Ambil receipt content
     * 2. Masukkin kondisional
     * 3. Langsung jadi bytes
     */

    final POSParameterEntity posParameterEntity =
        await _posParameterRepository.getPosParameter();
    final StoreMasterEntity storeMasterEntity =
        await _storeMasterRepository.getStoreMaster();
    final List<ReceiptContentEntity?> receiptContentEntities =
        await _receiptContentRepository.getReceiptContents();
    final PrintReceiptDetail printReceiptDetail = PrintReceiptDetail(
      receiptEntity: params!,
      posParameterEntity: posParameterEntity,
      storeMasterEntity: storeMasterEntity,
      receiptContentEntities: receiptContentEntities,
    );

    await _receiptPrinter.printReceipt(printReceiptDetail);
  }
}
