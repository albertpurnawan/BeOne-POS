// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';

class ProcessReceiptBeforeCheckoutUseCase
    implements UseCase<ReceiptEntity, ReceiptEntity> {
  ProcessReceiptBeforeCheckoutUseCase();

  @override
  Future<ReceiptEntity> call({ReceiptEntity? params}) async {
    try {
      if (params == null) {
        throw "ProcessReceiptBeforeCheckoutUseCase requires params";
      }

      throw "";
    } catch (e) {
      rethrow;
    }
  }
}
