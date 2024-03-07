// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoPackageHeaderEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String promoCode;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime startTime;
  final DateTime endTime;
  final String? remarks;
  final double discount;
  final int discType;
  final String globalDisc;
  final double minQuantity;
  final int statusActive;
  // final String? toplnId;

  PromoPackageHeaderEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.promoCode,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.remarks,
    required this.discount,
    required this.discType,
    required this.globalDisc,
    required this.minQuantity,
    required this.statusActive,
    // required this.toplnId,
  });

  PromoPackageHeaderEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? promoCode,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? startTime,
    DateTime? endTime,
    String? remarks,
    double? discount,
    int? discType,
    String? globalDisc,
    double? minQuantity,
    int? statusActive,
    // String? toplnId,
  }) {
    return PromoPackageHeaderEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      promoCode: promoCode ?? this.promoCode,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      remarks: remarks ?? this.remarks,
      discount: discount ?? this.discount,
      discType: discType ?? this.discType,
      globalDisc: globalDisc ?? this.globalDisc,
      minQuantity: minQuantity ?? this.minQuantity,
      statusActive: statusActive ?? this.statusActive,
      // toplnId: toplnId ?? this.toplnId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'promoCode': promoCode,
      'description': description,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
      'remarks': remarks,
      'discount': discount,
      'discType': discType,
      'globalDisc': globalDisc,
      'minQuantity': minQuantity,
      'statusActive': statusActive,
      // 'toplnId': toplnId,
    };
  }

  factory PromoPackageHeaderEntity.fromMap(Map<String, dynamic> map) {
    return PromoPackageHeaderEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      promoCode: map['promoCode'] as String,
      description: map['description'] as String,
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int),
      startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime'] as int),
      endTime: DateTime.fromMillisecondsSinceEpoch(map['endTime'] as int),
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
      discount: map['discount'] as double,
      discType: map['discType'] as int,
      globalDisc: map['globalDisc'] as String,
      minQuantity: map['minQuantity'] as double,
      statusActive: map['statusActive'] as int,
      // toplnId: map['toplnId'] != null ? map['toplnId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoPackageHeaderEntity.fromJson(String source) =>
      PromoPackageHeaderEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoPackageHeaderEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, promoCode: $promoCode, description: $description, startDate: $startDate, endDate: $endDate, startTime: $startTime, endTime: $endTime, remarks: $remarks, discount: $discount, discType: $discType, globalDisc: $globalDisc, minQuantity: $minQuantity, statusActive: $statusActive)';
  }

  @override
  bool operator ==(covariant PromoPackageHeaderEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.promoCode == promoCode &&
        other.description == description &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.remarks == remarks &&
        other.discount == discount &&
        other.discType == discType &&
        other.globalDisc == globalDisc &&
        other.minQuantity == minQuantity &&
        other.statusActive == statusActive;
    // other.toplnId == toplnId;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        promoCode.hashCode ^
        description.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        remarks.hashCode ^
        discount.hashCode ^
        discType.hashCode ^
        globalDisc.hashCode ^
        minQuantity.hashCode ^
        statusActive.hashCode;
    // toplnId.hashCode;
  }
}
