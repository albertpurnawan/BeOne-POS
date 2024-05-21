import 'package:flutter/rendering.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/employee.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/repository/employee_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/queued_receipt_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/receipt_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecalculateReceiptUseCase
    implements UseCase<ReceiptEntity, ReceiptEntity> {
  RecalculateReceiptUseCase();

  @override
  Future<ReceiptEntity> call({ReceiptEntity? params}) async {
    try {
      if (params == null) throw "RecalculateReceiptUseCase requires params";

      double subtotal = 0;
      double discAmount = 0;
      double discHeaderPromo = 0;
      double taxAmount = 0;
      double grandTotal = 0;

      params.receiptItems.forEach((element) {
        subtotal += element.totalGross;
        discAmount +=
            (element.discAmount ?? 0) + (element.discHeaderAmount ?? 0);
        discHeaderPromo += element.discAmount ?? 0;
        taxAmount += element.taxAmount;
      });

      grandTotal = subtotal - discAmount + taxAmount;

      final ReceiptEntity newReceipt = params.copyWith(
        subtotal: subtotal,
        discAmount: discAmount,
        discHeaderPromo: discHeaderPromo,
        taxAmount: taxAmount,
        grandTotal: grandTotal,
      );

      return newReceipt;
    } catch (e) {
      rethrow;
    }
  }
}
