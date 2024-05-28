// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoDiskonItemBuyConditionEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? topdiId;
  final String? toitmId;
  final double? priceFrom;
  final double? priceTo;
  final double? qtyFrom;
  final double? qtyTo;
  final String form;

  PromoDiskonItemBuyConditionEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    this.topdiId,
    this.toitmId,
    this.priceFrom,
    this.priceTo,
    this.qtyFrom,
    this.qtyTo,
    required this.form,
  });

  PromoDiskonItemBuyConditionEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? topdiId,
    String? toitmId,
    double? priceFrom,
    double? priceTo,
    double? qtyFrom,
    double? qtyTo,
    String? form,
  }) {
    return PromoDiskonItemBuyConditionEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      topdiId: topdiId ?? this.topdiId,
      toitmId: toitmId ?? this.toitmId,
      priceFrom: priceFrom ?? this.priceFrom,
      priceTo: priceTo ?? this.priceTo,
      qtyFrom: qtyFrom ?? this.qtyFrom,
      qtyTo: qtyTo ?? this.qtyTo,
      form: form ?? this.form,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'topdiId': topdiId,
      'toitmId': toitmId,
      'priceFrom': priceFrom,
      'priceTo': priceTo,
      'qtyFrom': qtyFrom,
      'qtyTo': qtyTo,
      'form': form,
    };
  }

  factory PromoDiskonItemBuyConditionEntity.fromMap(Map<String, dynamic> map) {
    return PromoDiskonItemBuyConditionEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      topdiId: map['topdiId'] != null ? map['topdiId'] as String : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      priceFrom: map['priceFrom'] != null ? map['priceFrom'] as double : null,
      priceTo: map['priceTo'] != null ? map['priceTo'] as double : null,
      qtyFrom: map['qtyFrom'] != null ? map['qtyFrom'] as double : null,
      qtyTo: map['qtyTo'] != null ? map['qtyTo'] as double : null,
      form: map['form'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoDiskonItemBuyConditionEntity.fromJson(String source) =>
      PromoDiskonItemBuyConditionEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoDiskonItemBuyConditionEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, topdiId: $topdiId, toitmId: $toitmId, priceFrom: $priceFrom, priceTo: $priceTo, qtyFrom: $qtyFrom, qtyTo: $qtyTo, form: $form)';
  }

  @override
  bool operator ==(covariant PromoDiskonItemBuyConditionEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.topdiId == topdiId &&
        other.toitmId == toitmId &&
        other.priceFrom == priceFrom &&
        other.priceTo == priceTo &&
        other.qtyFrom == qtyFrom &&
        other.qtyTo == qtyTo &&
        other.form == form;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        topdiId.hashCode ^
        toitmId.hashCode ^
        priceFrom.hashCode ^
        priceTo.hashCode ^
        qtyFrom.hashCode ^
        qtyTo.hashCode ^
        form.hashCode;
  }
}
