// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PricelistEntity {
  final int id;
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String priceCode;
  final String description;
  final int basePrice;
  final int periodPrice;
  final double factor;
  final int? tcurrId;
  final int type;
  final int statusactive;
  final int activated;

  PricelistEntity({
    required this.id,
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.priceCode,
    required this.description,
    required this.basePrice,
    required this.periodPrice,
    required this.factor,
    required this.tcurrId,
    required this.type,
    required this.statusactive,
    required this.activated,
  });

  PricelistEntity copyWith({
    int? id,
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? priceCode,
    String? description,
    int? basePrice,
    int? periodPrice,
    double? factor,
    int? tcurrId,
    int? type,
    int? statusactive,
    int? activated,
  }) {
    return PricelistEntity(
      id: id ?? this.id,
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      priceCode: priceCode ?? this.priceCode,
      description: description ?? this.description,
      basePrice: basePrice ?? this.basePrice,
      periodPrice: periodPrice ?? this.periodPrice,
      factor: factor ?? this.factor,
      tcurrId: tcurrId ?? this.tcurrId,
      type: type ?? this.type,
      statusactive: statusactive ?? this.statusactive,
      activated: activated ?? this.activated,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'priceCode': priceCode,
      'description': description,
      'basePrice': basePrice,
      'periodPrice': periodPrice,
      'factor': factor,
      'tcurrId': tcurrId,
      'type': type,
      'statusactive': statusactive,
      'activated': activated,
    };
  }

  factory PricelistEntity.fromMap(Map<String, dynamic> map) {
    return PricelistEntity(
      id: map['id'] as int,
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      priceCode: map['priceCode'] as String,
      description: map['description'] as String,
      basePrice: map['basePrice'] as int,
      periodPrice: map['periodPrice'] as int,
      factor: map['factor'] as double,
      tcurrId: map['tcurrId'] != null ? map['tcurrId'] as int : null,
      type: map['type'] as int,
      statusactive: map['statusactive'] as int,
      activated: map['activated'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PricelistEntity.fromJson(String source) =>
      PricelistEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PricelistEntity(id: $id, docId: $docId, createDate: $createDate, updateDate: $updateDate, priceCode: $priceCode, description: $description, basePrice: $basePrice, periodPrice: $periodPrice, factor: $factor, tcurrId: $tcurrId, type: $type, statusactive: $statusactive, activated: $activated)';
  }

  @override
  bool operator ==(covariant PricelistEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.priceCode == priceCode &&
        other.description == description &&
        other.basePrice == basePrice &&
        other.periodPrice == periodPrice &&
        other.factor == factor &&
        other.tcurrId == tcurrId &&
        other.type == type &&
        other.statusactive == statusactive &&
        other.activated == activated;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        priceCode.hashCode ^
        description.hashCode ^
        basePrice.hashCode ^
        periodPrice.hashCode ^
        factor.hashCode ^
        tcurrId.hashCode ^
        type.hashCode ^
        statusactive.hashCode ^
        activated.hashCode;
  }
}
