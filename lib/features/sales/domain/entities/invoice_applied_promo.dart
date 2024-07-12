// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class InvoiceAppliedPromoEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? toinvDocId;
  final String? tinv1DocId;
  final String promotionType;
  final String? promotionDocId;
  final double amount;

  InvoiceAppliedPromoEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    this.toinvDocId,
    this.tinv1DocId,
    required this.promotionType,
    this.promotionDocId,
    required this.amount,
  });

  InvoiceAppliedPromoEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? toinvDocId,
    String? tinv1DocId,
    String? promotionType,
    String? promotionDocId,
    double? amount,
  }) {
    return InvoiceAppliedPromoEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toinvDocId: toinvDocId ?? this.toinvDocId,
      tinv1DocId: tinv1DocId ?? this.tinv1DocId,
      promotionType: promotionType ?? this.promotionType,
      promotionDocId: promotionDocId ?? this.promotionDocId,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toinvDocId': toinvDocId,
      'tinv1DocId': tinv1DocId,
      'promotionType': promotionType,
      'promotionDocId': promotionDocId,
      'amount': amount,
    };
  }

  factory InvoiceAppliedPromoEntity.fromMap(Map<String, dynamic> map) {
    return InvoiceAppliedPromoEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int) : null,
      toinvDocId: map['toinvDocId'] != null ? map['toinvDocId'] as String : null,
      tinv1DocId: map['tinv1DocId'] != null ? map['tinv1DocId'] as String : null,
      promotionType: map['promotionType'] as String,
      promotionDocId: map['promotionDocId'] != null ? map['promotionDocId'] as String : null,
      amount: map['amount'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory InvoiceAppliedPromoEntity.fromJson(String source) =>
      InvoiceAppliedPromoEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'InvoiceAppliedPromoEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, toinvDocId: $toinvDocId, tinv1DocId: $tinv1DocId, promotionType: $promotionType, promotionDocId: $promotionDocId, amount: $amount)';
  }

  @override
  bool operator ==(covariant InvoiceAppliedPromoEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toinvDocId == toinvDocId &&
        other.tinv1DocId == tinv1DocId &&
        other.promotionType == promotionType &&
        other.promotionDocId == promotionDocId &&
        other.amount == amount;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toinvDocId.hashCode ^
        tinv1DocId.hashCode ^
        promotionType.hashCode ^
        promotionDocId.hashCode ^
        amount.hashCode;
  }
}
