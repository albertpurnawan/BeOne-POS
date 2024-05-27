// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoHargaSpesialBuyEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? topsbId;
  final double qty;
  final double price;
  final String form;

  PromoHargaSpesialBuyEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    this.topsbId,
    required this.qty,
    required this.price,
    required this.form,
  });

  PromoHargaSpesialBuyEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? topsbId,
    double? qty,
    double? price,
    String? form,
  }) {
    return PromoHargaSpesialBuyEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      topsbId: topsbId ?? this.topsbId,
      qty: qty ?? this.qty,
      price: price ?? this.price,
      form: form ?? this.form,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'topsbId': topsbId,
      'qty': qty,
      'price': price,
      'form': form,
    };
  }

  factory PromoHargaSpesialBuyEntity.fromMap(Map<String, dynamic> map) {
    return PromoHargaSpesialBuyEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      topsbId: map['topsbId'] != null ? map['topsbId'] as String : null,
      qty: map['qty'] as double,
      price: map['price'] as double,
      form: map['form'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoHargaSpesialBuyEntity.fromJson(String source) =>
      PromoHargaSpesialBuyEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoHargaSpesialBuyEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, topsbId: $topsbId, qty: $qty, price: $price, form: $form)';
  }

  @override
  bool operator ==(covariant PromoHargaSpesialBuyEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.topsbId == topsbId &&
        other.qty == qty &&
        other.price == price &&
        other.form == form;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        topsbId.hashCode ^
        qty.hashCode ^
        price.hashCode ^
        form.hashCode;
  }
}
