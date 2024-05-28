// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoBuyXGetYGetConditionEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? toprbId;
  final String? toitmId;
  final double quantity;
  final double sellingPrice;
  final String form;

  PromoBuyXGetYGetConditionEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    this.toprbId,
    this.toitmId,
    required this.quantity,
    required this.sellingPrice,
    required this.form,
  });

  PromoBuyXGetYGetConditionEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? toprbId,
    String? toitmId,
    double? quantity,
    double? sellingPrice,
    String? form,
  }) {
    return PromoBuyXGetYGetConditionEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toprbId: toprbId ?? this.toprbId,
      toitmId: toitmId ?? this.toitmId,
      quantity: quantity ?? this.quantity,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      form: form ?? this.form,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toprbId': toprbId,
      'toitmId': toitmId,
      'quantity': quantity,
      'sellingPrice': sellingPrice,
      'form': form,
    };
  }

  factory PromoBuyXGetYGetConditionEntity.fromMap(Map<String, dynamic> map) {
    return PromoBuyXGetYGetConditionEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      toprbId: map['toprbId'] != null ? map['toprbId'] as String : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      quantity: map['quantity'] as double,
      sellingPrice: map['sellingPrice'] as double,
      form: map['form'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoBuyXGetYGetConditionEntity.fromJson(String source) =>
      PromoBuyXGetYGetConditionEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoBuyXGetYGetConditionEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, toprbId: $toprbId, toitmId: $toitmId, quantity: $quantity, sellingPrice: $sellingPrice, form: $form)';
  }

  @override
  bool operator ==(covariant PromoBuyXGetYGetConditionEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toprbId == toprbId &&
        other.toitmId == toitmId &&
        other.quantity == quantity &&
        other.sellingPrice == sellingPrice &&
        other.form == form;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toprbId.hashCode ^
        toitmId.hashCode ^
        quantity.hashCode ^
        sellingPrice.hashCode ^
        form.hashCode;
  }
}
