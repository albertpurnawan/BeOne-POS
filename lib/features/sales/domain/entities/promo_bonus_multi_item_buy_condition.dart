// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoBonusMultiItemBuyConditionEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? topmiId;
  final String? toitmId;
  final double? qtyFrom;
  final double? qtyTo;
  final double? priceFrom;
  final double? priceTo;
  final String form;

  PromoBonusMultiItemBuyConditionEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    this.topmiId,
    this.toitmId,
    this.qtyFrom,
    this.qtyTo,
    this.priceFrom,
    this.priceTo,
    required this.form,
  });

  PromoBonusMultiItemBuyConditionEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? topmiId,
    String? toitmId,
    double? qtyFrom,
    double? qtyTo,
    double? priceFrom,
    double? priceTo,
    String? form,
  }) {
    return PromoBonusMultiItemBuyConditionEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      topmiId: topmiId ?? this.topmiId,
      toitmId: toitmId ?? this.toitmId,
      qtyFrom: qtyFrom ?? this.qtyFrom,
      qtyTo: qtyTo ?? this.qtyTo,
      priceFrom: priceFrom ?? this.priceFrom,
      priceTo: priceTo ?? this.priceTo,
      form: form ?? this.form,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'topmiId': topmiId,
      'toitmId': toitmId,
      'qtyFrom': qtyFrom,
      'qtyTo': qtyTo,
      'priceFrom': priceFrom,
      'priceTo': priceTo,
      'form': form,
    };
  }

  factory PromoBonusMultiItemBuyConditionEntity.fromMap(
      Map<String, dynamic> map) {
    return PromoBonusMultiItemBuyConditionEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      topmiId: map['topmiId'] != null ? map['topmiId'] as String : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      qtyFrom: map['qtyFrom'] != null ? map['qtyFrom'] as double : null,
      qtyTo: map['qtyTo'] != null ? map['qtyTo'] as double : null,
      priceFrom: map['priceFrom'] != null ? map['priceFrom'] as double : null,
      priceTo: map['priceTo'] != null ? map['priceTo'] as double : null,
      form: map['form'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoBonusMultiItemBuyConditionEntity.fromJson(String source) =>
      PromoBonusMultiItemBuyConditionEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoBonusMultiItemBuyConditionEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, topmiId: $topmiId, toitmId: $toitmId, qtyFrom: $qtyFrom, qtyTo: $qtyTo, priceFrom: $priceFrom, priceTo: $priceTo, form: $form)';
  }

  @override
  bool operator ==(covariant PromoBonusMultiItemBuyConditionEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.topmiId == topmiId &&
        other.toitmId == toitmId &&
        other.qtyFrom == qtyFrom &&
        other.qtyTo == qtyTo &&
        other.priceFrom == priceFrom &&
        other.priceTo == priceTo &&
        other.form == form;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        topmiId.hashCode ^
        toitmId.hashCode ^
        qtyFrom.hashCode ^
        qtyTo.hashCode ^
        priceFrom.hashCode ^
        priceTo.hashCode ^
        form.hashCode;
  }
}
