// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PricelistEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String priceCode;
  final String description;
  final int basePrice;
  final double factor;
  final String? tcurrId;
  final int type;
  final int statusactive;
  final int activated;
  final String form;

  PricelistEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    required this.priceCode,
    required this.description,
    required this.basePrice,
    required this.factor,
    this.tcurrId,
    required this.type,
    required this.statusactive,
    required this.activated,
    required this.form,
  });

  PricelistEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? priceCode,
    String? description,
    int? basePrice,
    double? factor,
    String? tcurrId,
    int? type,
    int? statusactive,
    int? activated,
    String? form,
  }) {
    return PricelistEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      priceCode: priceCode ?? this.priceCode,
      description: description ?? this.description,
      basePrice: basePrice ?? this.basePrice,
      factor: factor ?? this.factor,
      tcurrId: tcurrId ?? this.tcurrId,
      type: type ?? this.type,
      statusactive: statusactive ?? this.statusactive,
      activated: activated ?? this.activated,
      form: form ?? this.form,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'priceCode': priceCode,
      'description': description,
      'basePrice': basePrice,
      'factor': factor,
      'tcurrId': tcurrId,
      'type': type,
      'statusactive': statusactive,
      'activated': activated,
      'form': form,
    };
  }

  factory PricelistEntity.fromMap(Map<String, dynamic> map) {
    return PricelistEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      priceCode: map['priceCode'] as String,
      description: map['description'] as String,
      basePrice: map['basePrice'] as int,
      factor: map['factor'] as double,
      tcurrId: map['tcurrId'] != null ? map['tcurrId'] as String : null,
      type: map['type'] as int,
      statusactive: map['statusactive'] as int,
      activated: map['activated'] as int,
      form: map['form'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PricelistEntity.fromJson(String source) =>
      PricelistEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PricelistEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, priceCode: $priceCode, description: $description, basePrice: $basePrice, factor: $factor, tcurrId: $tcurrId, type: $type, statusactive: $statusactive, activated: $activated, form: $form)';
  }

  @override
  bool operator ==(covariant PricelistEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.priceCode == priceCode &&
        other.description == description &&
        other.basePrice == basePrice &&
        other.factor == factor &&
        other.tcurrId == tcurrId &&
        other.type == type &&
        other.statusactive == statusactive &&
        other.activated == activated &&
        other.form == form;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        priceCode.hashCode ^
        description.hashCode ^
        basePrice.hashCode ^
        factor.hashCode ^
        tcurrId.hashCode ^
        type.hashCode ^
        statusactive.hashCode ^
        activated.hashCode ^
        form.hashCode;
  }
}
