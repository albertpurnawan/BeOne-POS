import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class PromoBonusMultiItemHeaderEntity {
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
  final int statusActive;
  final int promoType;
  final int buyCondition;
  final int getCondition;
  final double? totalQtyFrom;
  final double? totalQtyTo;
  final double? totalPriceFrom;
  final double? totalPriceTo;
  final int validMultiply;
  final int promoAlias;
  final int transactionLimit;
  final String form;

  PromoBonusMultiItemHeaderEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    required this.promoCode,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    this.remarks,
    required this.statusActive,
    required this.promoType,
    required this.buyCondition,
    required this.getCondition,
    this.totalQtyFrom,
    this.totalQtyTo,
    this.totalPriceFrom,
    this.totalPriceTo,
    required this.validMultiply,
    required this.promoAlias,
    required this.transactionLimit,
    required this.form,
  });

  PromoBonusMultiItemHeaderEntity copyWith({
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
    int? statusActive,
    int? promoType,
    int? buyCondition,
    int? getCondition,
    double? totalQtyFrom,
    double? totalQtyTo,
    double? totalPriceFrom,
    double? totalPriceTo,
    int? validMultiply,
    int? promoAlias,
    int? transactionLimit,
    String? form,
  }) {
    return PromoBonusMultiItemHeaderEntity(
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
      statusActive: statusActive ?? this.statusActive,
      promoType: promoType ?? this.promoType,
      buyCondition: buyCondition ?? this.buyCondition,
      getCondition: getCondition ?? this.getCondition,
      totalQtyFrom: totalQtyFrom ?? this.totalQtyFrom,
      totalQtyTo: totalQtyTo ?? this.totalQtyTo,
      totalPriceFrom: totalPriceFrom ?? this.totalPriceFrom,
      totalPriceTo: totalPriceTo ?? this.totalPriceTo,
      validMultiply: validMultiply ?? this.validMultiply,
      promoAlias: promoAlias ?? this.promoAlias,
      transactionLimit: transactionLimit ?? this.transactionLimit,
      form: form ?? this.form,
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
      'statusActive': statusActive,
      'promoType': promoType,
      'buyCondition': buyCondition,
      'getCondition': getCondition,
      'totalQtyFrom': totalQtyFrom,
      'totalQtyTo': totalQtyTo,
      'totalPriceFrom': totalPriceFrom,
      'totalPriceTo': totalPriceTo,
      'validMultiply': validMultiply,
      'promoAlias': promoAlias,
      'transactionLimit': transactionLimit,
      'form': form,
    };
  }

  factory PromoBonusMultiItemHeaderEntity.fromMap(Map<String, dynamic> map) {
    return PromoBonusMultiItemHeaderEntity(
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
      statusActive: map['statusActive'] as int,
      promoType: map['promoType'] as int,
      buyCondition: map['buyCondition'] as int,
      getCondition: map['getCondition'] as int,
      totalQtyFrom:
          map['totalQtyFrom'] != null ? map['totalQtyFrom'] as double : null,
      totalQtyTo:
          map['totalQtyTo'] != null ? map['totalQtyTo'] as double : null,
      totalPriceFrom: map['totalPriceFrom'] != null
          ? map['totalPriceFrom'] as double
          : null,
      totalPriceTo:
          map['totalPriceTo'] != null ? map['totalPriceTo'] as double : null,
      validMultiply: map['validMultiply'] as int,
      promoAlias: map['promoAlias'] as int,
      transactionLimit: map['transactionLimit'] as int,
      form: map['form'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoBonusMultiItemHeaderEntity.fromJson(String source) =>
      PromoBonusMultiItemHeaderEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoBonusMultiItemHeaderEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, promoCode: $promoCode, description: $description, startDate: $startDate, endDate: $endDate, startTime: $startTime, endTime: $endTime, remarks: $remarks, statusActive: $statusActive, promoType: $promoType, buyCondition: $buyCondition, getCondition: $getCondition, totalQtyFrom: $totalQtyFrom, totalQtyTo: $totalQtyTo, totalPriceFrom: $totalPriceFrom, totalPriceTo: $totalPriceTo, validMultiply: $validMultiply, promoAlias: $promoAlias, transactionLimit: $transactionLimit, form: $form)';
  }

  @override
  bool operator ==(covariant PromoBonusMultiItemHeaderEntity other) {
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
        other.statusActive == statusActive &&
        other.promoType == promoType &&
        other.buyCondition == buyCondition &&
        other.getCondition == getCondition &&
        other.totalQtyFrom == totalQtyFrom &&
        other.totalQtyTo == totalQtyTo &&
        other.totalPriceFrom == totalPriceFrom &&
        other.totalPriceTo == totalPriceTo &&
        other.validMultiply == validMultiply &&
        other.promoAlias == promoAlias &&
        other.transactionLimit == transactionLimit &&
        other.form == form;
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
        statusActive.hashCode ^
        promoType.hashCode ^
        buyCondition.hashCode ^
        getCondition.hashCode ^
        totalQtyFrom.hashCode ^
        totalQtyTo.hashCode ^
        totalPriceFrom.hashCode ^
        totalPriceTo.hashCode ^
        validMultiply.hashCode ^
        promoAlias.hashCode ^
        transactionLimit.hashCode ^
        form.hashCode;
  }
}
