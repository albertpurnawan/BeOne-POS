// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/entities/promotions.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/repository/item_repository.dart';
import 'package:pos_fe/features/sales/domain/usecases/check_promos.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_without_promos.dart';
import 'package:pos_fe/features/sales/domain/usecases/recalculate_receipt_by_new_receipt_items.dart';

class ProcessReceiptBeforeCheckoutUseCase
    implements UseCase<ReceiptEntity, ReceiptEntity> {
  ProcessReceiptBeforeCheckoutUseCase();

  @override
  Future<ReceiptEntity> call({ReceiptEntity? params}) async {
    // TODO: implement call
    try {
      if (params == null) {
        throw "ProcessReceiptBeforeCheckoutUseCase requires params";
      }

      for (final receiptItem in params.receiptItems) {}

      throw "a";
    } catch (e) {
      rethrow;
    }
  }
}