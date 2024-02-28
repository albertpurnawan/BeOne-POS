// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PricelistPeriodEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? toplnId;
  final DateTime periodFr;
  final DateTime periodTo;
  final int basePrice;
  final int periodPrice;
  final double factor;
  final int statusActive;
  final int activated;

  PricelistPeriodEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.toplnId,
    required this.periodFr,
    required this.periodTo,
    required this.basePrice,
    required this.periodPrice,
    required this.factor,
    required this.statusActive,
    required this.activated,
  });

  PricelistPeriodEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? toplnId,
    DateTime? periodFr,
    DateTime? periodTo,
    int? basePrice,
    int? periodPrice,
    double? factor,
    int? statusActive,
    int? activated,
  }) {
    return PricelistPeriodEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toplnId: toplnId ?? this.toplnId,
      periodFr: periodFr ?? this.periodFr,
      periodTo: periodTo ?? this.periodTo,
      basePrice: basePrice ?? this.basePrice,
      periodPrice: periodPrice ?? this.periodPrice,
      factor: factor ?? this.factor,
      statusActive: statusActive ?? this.statusActive,
      activated: activated ?? this.activated,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toplnId': toplnId,
      'periodFr': periodFr.millisecondsSinceEpoch,
      'periodTo': periodTo.millisecondsSinceEpoch,
      'basePrice': basePrice,
      'periodPrice': periodPrice,
      'factor': factor,
      'statusActive': statusActive,
      'activated': activated,
    };
  }

  factory PricelistPeriodEntity.fromMap(Map<String, dynamic> map) {
    return PricelistPeriodEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      toplnId: map['toplnId'] != null ? map['toplnId'] as String : null,
      periodFr: DateTime.fromMillisecondsSinceEpoch(map['periodFr'] as int),
      periodTo: DateTime.fromMillisecondsSinceEpoch(map['periodTo'] as int),
      basePrice: map['basePrice'] as int,
      periodPrice: map['periodPrice'] as int,
      factor: map['factor'] as double,
      statusActive: map['statusActive'] as int,
      activated: map['activated'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PricelistPeriodEntity.fromJson(String source) =>
      PricelistPeriodEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PricelistPeriodEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, toplnId: $toplnId, periodFr: $periodFr, periodTo: $periodTo, basePrice: $basePrice, periodPrice: $periodPrice, factor: $factor, statusActive: $statusActive, activated: $activated)';
  }

  @override
  bool operator ==(covariant PricelistPeriodEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toplnId == toplnId &&
        other.periodFr == periodFr &&
        other.periodTo == periodTo &&
        other.basePrice == basePrice &&
        other.periodPrice == periodPrice &&
        other.factor == factor &&
        other.statusActive == statusActive &&
        other.activated == activated;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toplnId.hashCode ^
        periodFr.hashCode ^
        periodTo.hashCode ^
        basePrice.hashCode ^
        periodPrice.hashCode ^
        factor.hashCode ^
        statusActive.hashCode ^
        activated.hashCode;
  }
}
