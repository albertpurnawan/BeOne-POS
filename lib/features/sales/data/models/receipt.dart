import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';

class ReceiptModel extends ReceiptEntity implements BaseModel {
  ReceiptModel(
      {required super.docNum,
      required super.receiptItems,
      super.mopSelection,
      super.customerEntity,
      super.employeeEntity,
      required super.totalTax,
      super.transDateTime,
      required super.transStart,
      super.transEnd,
      required super.subtotal,
      required super.taxAmount,
      required super.grandTotal,
      super.totalPayment,
      super.changed,
      super.toinvId,
      required super.vouchers,
      super.totalVoucher,
      super.totalNonVoucher,
      required super.promos});

  factory ReceiptModel.fromEntity(ReceiptEntity entity) {
    return ReceiptModel(
      docNum: entity.docNum,
      receiptItems: entity.receiptItems,
      mopSelection: entity.mopSelection,
      customerEntity: entity.customerEntity,
      employeeEntity: entity.employeeEntity,
      totalTax: entity.totalTax,
      transDateTime: entity.transDateTime,
      transStart: entity.transStart,
      transEnd: entity.transEnd,
      subtotal: entity.subtotal,
      taxAmount: entity.taxAmount,
      grandTotal: entity.grandTotal,
      totalPayment: entity.totalPayment,
      changed: entity.changed,
      toinvId: entity.toinvId,
      vouchers: entity.vouchers,
      totalVoucher: entity.totalVoucher,
      totalNonVoucher: entity.totalNonVoucher,
      promos: entity.promos,
    );
  }
}
