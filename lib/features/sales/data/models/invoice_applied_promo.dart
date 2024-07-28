import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/invoice_applied_promo.dart';

const String tableInvoiceAppliedPromo = "tinv5";

class InvoiceAppliedPromoFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toinvDocId,
    tinv1DocId,
    promotionType,
    promotionDocId,
    amount,
  ];

  static const String docId = 'docid';
  static const String createDate = 'createdate';
  static const String updateDate = 'updatedate';
  static const String toinvDocId = 'toinvdocid';
  static const String tinv1DocId = 'tinv1docid';
  static const String promotionType = 'promotiontype';
  static const String promotionDocId = 'promotiondocid';
  static const String amount = 'amount';
}

class InvoiceAppliedPromoModel extends InvoiceAppliedPromoEntity implements BaseModel {
  InvoiceAppliedPromoModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toinvDocId,
    required super.tinv1DocId,
    required super.promotionType,
    required super.promotionDocId,
    required super.amount,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'toinvdocid': toinvDocId,
      'tinv1docid': tinv1DocId,
      'promotiontype': promotionType,
      'promotiondocid': promotionDocId,
      'amount': amount,
    };
  }

  factory InvoiceAppliedPromoModel.fromMap(Map<String, dynamic> map) {
    return InvoiceAppliedPromoModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null ? DateTime.parse(map['updatedate'] as String).toLocal() : null,
      toinvDocId: map['toinvdocid'] != null ? map['toinvdocid'] as String : null,
      tinv1DocId: map['tinv1docid'] != null ? map['tinv1docid'] as String : null,
      promotionType: map['promotiontype'] as String,
      promotionDocId: map['promotiondocid'] != null ? map['promotiondocid'] as String : null,
      amount: map['amount'] as double,
    );
  }

  factory InvoiceAppliedPromoModel.fromEntity(InvoiceAppliedPromoEntity entity) {
    return InvoiceAppliedPromoModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toinvDocId: entity.toinvDocId,
      tinv1DocId: entity.tinv1DocId,
      promotionType: entity.promotionType,
      promotionDocId: entity.promotionDocId,
      amount: entity.amount,
    );
  }
}
