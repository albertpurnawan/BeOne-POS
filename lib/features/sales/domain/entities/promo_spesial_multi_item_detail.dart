// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoSpesialMultiItemDetailEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? topsmId;
  final String? toitmId;
  final double qtyFrom;
  final double qtyTo;
  final double price;
  final String form;

  PromoSpesialMultiItemDetailEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.topsmId,
    required this.toitmId,
    required this.qtyFrom,
    required this.qtyTo,
    required this.price,
    required this.form,
  });

  PromoSpesialMultiItemDetailEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? topsmId,
    String? toitmId,
    double? qtyFrom,
    double? qtyTo,
    double? price,
    String? form,
  }) {
    return PromoSpesialMultiItemDetailEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      topsmId: topsmId ?? this.topsmId,
      toitmId: toitmId ?? this.toitmId,
      qtyFrom: qtyFrom ?? this.qtyFrom,
      qtyTo: qtyTo ?? this.qtyTo,
      price: price ?? this.price,
      form: form ?? this.form,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'topsmId': topsmId,
      'toitmId': toitmId,
      'qtyFrom': qtyFrom,
      'qtyTo': qtyTo,
      'price': price,
      'form': form,
    };
  }

  factory PromoSpesialMultiItemDetailEntity.fromMap(Map<String, dynamic> map) {
    return PromoSpesialMultiItemDetailEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int) : null,
      topsmId: map['topsmId'] != null ? map['topsmId'] as String : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      qtyFrom: map['qtyFrom'] as double,
      qtyTo: map['qtyTo'] as double,
      price: map['price'] as double,
      form: map['form'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoSpesialMultiItemDetailEntity.fromJson(String source) =>
      PromoSpesialMultiItemDetailEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoSpesialMultiItemDetailEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, topsmId: $topsmId, toitmId: $toitmId, qtyFrom: $qtyFrom, qtyTo: $qtyTo, price: $price, form: $form)';
  }

  @override
  bool operator ==(covariant PromoSpesialMultiItemDetailEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.topsmId == topsmId &&
        other.toitmId == toitmId &&
        other.qtyFrom == qtyFrom &&
        other.qtyTo == qtyTo &&
        other.price == price &&
        other.form == form;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        topsmId.hashCode ^
        toitmId.hashCode ^
        qtyFrom.hashCode ^
        qtyTo.hashCode ^
        price.hashCode ^
        form.hashCode;
  }
}
