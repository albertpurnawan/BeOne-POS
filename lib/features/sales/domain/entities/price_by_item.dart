// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PriceByItemEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? tpln1Id;
  final String? toitmId;
  final String? tcurrId;
  final double price;
  // final double? purchasePrice;
  // final double? calculatedPrice;
  // final double? marginPercentage;
  // final double? marginValue;
  // final double? costPrice;
  // final double? afterRounding;
  // final double? beforeRounding;
  // final double? roundingDiff;
  final String form;

  PriceByItemEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    this.tpln1Id,
    this.toitmId,
    this.tcurrId,
    required this.price,
    required this.form,
  });

  PriceByItemEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? tpln1Id,
    String? toitmId,
    String? tcurrId,
    double? price,
    String? form,
  }) {
    return PriceByItemEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      tpln1Id: tpln1Id ?? this.tpln1Id,
      toitmId: toitmId ?? this.toitmId,
      tcurrId: tcurrId ?? this.tcurrId,
      price: price ?? this.price,
      form: form ?? this.form,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'tpln1Id': tpln1Id,
      'toitmId': toitmId,
      'tcurrId': tcurrId,
      'price': price,
      'form': form,
    };
  }

  factory PriceByItemEntity.fromMap(Map<String, dynamic> map) {
    return PriceByItemEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      tpln1Id: map['tpln1Id'] != null ? map['tpln1Id'] as String : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      tcurrId: map['tcurrId'] != null ? map['tcurrId'] as String : null,
      price: map['price'] as double,
      form: map['form'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PriceByItemEntity.fromJson(String source) =>
      PriceByItemEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PriceByItemEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, tpln1Id: $tpln1Id, toitmId: $toitmId, tcurrId: $tcurrId, price: $price, form: $form)';
  }

  @override
  bool operator ==(covariant PriceByItemEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.tpln1Id == tpln1Id &&
        other.toitmId == toitmId &&
        other.tcurrId == tcurrId &&
        other.price == price &&
        other.form == form;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        tpln1Id.hashCode ^
        toitmId.hashCode ^
        tcurrId.hashCode ^
        price.hashCode ^
        form.hashCode;
  }
}
