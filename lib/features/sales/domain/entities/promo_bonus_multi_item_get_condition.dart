import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class PromoBonusMultiItemGetConditionEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? topmiId;
  final String? toitmId;
  final double quantity;
  final double price;
  final double quota;
  final String form;

  PromoBonusMultiItemGetConditionEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    this.topmiId,
    this.toitmId,
    required this.quantity,
    required this.price,
    required this.quota,
    required this.form,
  });

  PromoBonusMultiItemGetConditionEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? topmiId,
    String? toitmId,
    double? quantity,
    double? price,
    double? quota,
    String? form,
  }) {
    return PromoBonusMultiItemGetConditionEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      topmiId: topmiId ?? this.topmiId,
      toitmId: toitmId ?? this.toitmId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      quota: quota ?? this.quota,
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
      'quantity': quantity,
      'price': price,
      'quota': quota,
      'form': form,
    };
  }

  factory PromoBonusMultiItemGetConditionEntity.fromMap(
      Map<String, dynamic> map) {
    return PromoBonusMultiItemGetConditionEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      topmiId: map['topmiId'] != null ? map['topmiId'] as String : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      quantity: map['quantity'] as double,
      price: map['price'] as double,
      quota: map['quota'] as double,
      form: map['form'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoBonusMultiItemGetConditionEntity.fromJson(String source) =>
      PromoBonusMultiItemGetConditionEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoBonusMultiItemGetConditionEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, topmiId: $topmiId, toitmId: $toitmId, quantity: $quantity, price: $price, quota: $quota, form: $form)';
  }

  @override
  bool operator ==(covariant PromoBonusMultiItemGetConditionEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.topmiId == topmiId &&
        other.toitmId == toitmId &&
        other.quantity == quantity &&
        other.price == price &&
        other.quota == quota &&
        other.form == form;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        topmiId.hashCode ^
        toitmId.hashCode ^
        quantity.hashCode ^
        price.hashCode ^
        quota.hashCode ^
        form.hashCode;
  }
}
