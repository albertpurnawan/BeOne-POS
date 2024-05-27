// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PriceByItemBarcodeEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? tpln2Id;
  final String? tcurrId;
  final String? tbitmId;
  final double price;
  final String form;

  PriceByItemBarcodeEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    this.tpln2Id,
    this.tcurrId,
    this.tbitmId,
    required this.price,
    required this.form,
  });

  PriceByItemBarcodeEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? tpln2Id,
    String? tcurrId,
    String? tbitmId,
    double? price,
    String? form,
  }) {
    return PriceByItemBarcodeEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      tpln2Id: tpln2Id ?? this.tpln2Id,
      tcurrId: tcurrId ?? this.tcurrId,
      tbitmId: tbitmId ?? this.tbitmId,
      price: price ?? this.price,
      form: form ?? this.form,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'tpln2Id': tpln2Id,
      'tcurrId': tcurrId,
      'tbitmId': tbitmId,
      'price': price,
      'form': form,
    };
  }

  factory PriceByItemBarcodeEntity.fromMap(Map<String, dynamic> map) {
    return PriceByItemBarcodeEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      tpln2Id: map['tpln2Id'] != null ? map['tpln2Id'] as String : null,
      tcurrId: map['tcurrId'] != null ? map['tcurrId'] as String : null,
      tbitmId: map['tbitmId'] != null ? map['tbitmId'] as String : null,
      price: map['price'] as double,
      form: map['form'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PriceByItemBarcodeEntity.fromJson(String source) =>
      PriceByItemBarcodeEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PriceByItemBarcodeEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, tpln2Id: $tpln2Id, tcurrId: $tcurrId, tbitmId: $tbitmId, price: $price, form: $form)';
  }

  @override
  bool operator ==(covariant PriceByItemBarcodeEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.tpln2Id == tpln2Id &&
        other.tcurrId == tcurrId &&
        other.tbitmId == tbitmId &&
        other.price == price &&
        other.form == form;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        tpln2Id.hashCode ^
        tcurrId.hashCode ^
        tbitmId.hashCode ^
        price.hashCode ^
        form.hashCode;
  }
}
