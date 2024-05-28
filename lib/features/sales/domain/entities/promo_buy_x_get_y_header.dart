// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoBuyXGetYHeaderEntity {
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
  final double minPurchase;
  final int buyCondition;
  final double minBuy;
  final double maxMultiply;
  final int getCondition;
  final double maxGet;
  final int statusActive;
  final String? toplnId;
  final String form;

  PromoBuyXGetYHeaderEntity({
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
    required this.minPurchase,
    required this.buyCondition,
    required this.minBuy,
    required this.maxMultiply,
    required this.getCondition,
    required this.maxGet,
    required this.statusActive,
    this.toplnId,
    required this.form,
  });

  PromoBuyXGetYHeaderEntity copyWith({
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
    double? minPurchase,
    int? buyCondition,
    double? minBuy,
    double? maxMultiply,
    int? getCondition,
    double? maxGet,
    int? statusActive,
    String? toplnId,
    String? form,
  }) {
    return PromoBuyXGetYHeaderEntity(
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
      minPurchase: minPurchase ?? this.minPurchase,
      buyCondition: buyCondition ?? this.buyCondition,
      minBuy: minBuy ?? this.minBuy,
      maxMultiply: maxMultiply ?? this.maxMultiply,
      getCondition: getCondition ?? this.getCondition,
      maxGet: maxGet ?? this.maxGet,
      statusActive: statusActive ?? this.statusActive,
      toplnId: toplnId ?? this.toplnId,
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
      'minPurchase': minPurchase,
      'buyCondition': buyCondition,
      'minBuy': minBuy,
      'maxMultiply': maxMultiply,
      'getCondition': getCondition,
      'maxGet': maxGet,
      'statusActive': statusActive,
      'toplnId': toplnId,
      'form': form,
    };
  }

  factory PromoBuyXGetYHeaderEntity.fromMap(Map<String, dynamic> map) {
    return PromoBuyXGetYHeaderEntity(
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
      minPurchase: map['minPurchase'] as double,
      buyCondition: map['buyCondition'] as int,
      minBuy: map['minBuy'] as double,
      maxMultiply: map['maxMultiply'] as double,
      getCondition: map['getCondition'] as int,
      maxGet: map['maxGet'] as double,
      statusActive: map['statusActive'] as int,
      toplnId: map['toplnId'] != null ? map['toplnId'] as String : null,
      form: map['form'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoBuyXGetYHeaderEntity.fromJson(String source) =>
      PromoBuyXGetYHeaderEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoBuyXGetYHeaderEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, promoCode: $promoCode, description: $description, startDate: $startDate, endDate: $endDate, startTime: $startTime, endTime: $endTime, remarks: $remarks, minPurchase: $minPurchase, buyCondition: $buyCondition, minBuy: $minBuy, maxMultiply: $maxMultiply, getCondition: $getCondition, maxGet: $maxGet, statusActive: $statusActive, toplnId: $toplnId, form: $form)';
  }

  @override
  bool operator ==(covariant PromoBuyXGetYHeaderEntity other) {
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
        other.minPurchase == minPurchase &&
        other.buyCondition == buyCondition &&
        other.minBuy == minBuy &&
        other.maxMultiply == maxMultiply &&
        other.getCondition == getCondition &&
        other.maxGet == maxGet &&
        other.statusActive == statusActive &&
        other.toplnId == toplnId &&
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
        minPurchase.hashCode ^
        buyCondition.hashCode ^
        minBuy.hashCode ^
        maxMultiply.hashCode ^
        getCondition.hashCode ^
        maxGet.hashCode ^
        statusActive.hashCode ^
        toplnId.hashCode ^
        form.hashCode;
  }
}
