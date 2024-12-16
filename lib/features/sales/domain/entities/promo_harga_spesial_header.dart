import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class PromoHargaSpesialHeaderEntity {
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
  final int maxPurchaseDay;
  final int maxPurchaseTransaction;
  final int validMultiply;
  final int quota;
  final int promoAlias;
  final String? toitmId;
  final int? promoType;
  final String form;
  final int detailQtyValidation;

  PromoHargaSpesialHeaderEntity({
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
    required this.maxPurchaseDay,
    required this.maxPurchaseTransaction,
    required this.validMultiply,
    required this.quota,
    required this.promoAlias,
    this.toitmId,
    this.promoType,
    required this.form,
    required this.detailQtyValidation,
  });

  PromoHargaSpesialHeaderEntity copyWith({
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
    int? maxPurchaseDay,
    int? maxPurchaseTransaction,
    int? validMultiply,
    int? quota,
    int? promoAlias,
    String? toitmId,
    int? promoType,
    String? form,
    int? detailQtyValidation,
  }) {
    return PromoHargaSpesialHeaderEntity(
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
      maxPurchaseDay: maxPurchaseDay ?? this.maxPurchaseDay,
      maxPurchaseTransaction: maxPurchaseTransaction ?? this.maxPurchaseTransaction,
      validMultiply: validMultiply ?? this.validMultiply,
      quota: quota ?? this.quota,
      promoAlias: promoAlias ?? this.promoAlias,
      toitmId: toitmId ?? this.toitmId,
      promoType: promoType ?? this.promoType,
      form: form ?? this.form,
      detailQtyValidation: detailQtyValidation ?? this.detailQtyValidation,
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
      'maxPurchaseDay': maxPurchaseDay,
      'maxPurchaseTransaction': maxPurchaseTransaction,
      'validMultiply': validMultiply,
      'quota': quota,
      'promoAlias': promoAlias,
      'toitmId': toitmId,
      'promoType': promoType,
      'form': form,
      'detailQtyValidation': detailQtyValidation,
    };
  }

  factory PromoHargaSpesialHeaderEntity.fromMap(Map<String, dynamic> map) {
    return PromoHargaSpesialHeaderEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int) : null,
      promoCode: map['promoCode'] as String,
      description: map['description'] as String,
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int),
      startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime'] as int),
      endTime: DateTime.fromMillisecondsSinceEpoch(map['endTime'] as int),
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
      statusActive: map['statusActive'] as int,
      maxPurchaseDay: map['maxPurchaseDay'] as int,
      maxPurchaseTransaction: map['maxPurchaseTransaction'] as int,
      validMultiply: map['validMultiply'] as int,
      quota: map['quota'] as int,
      promoAlias: map['promoAlias'] as int,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      promoType: map['promoType'] != null ? map['promoType'] as int : null,
      form: map['form'] as String,
      detailQtyValidation: map['detailQtyValidation'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoHargaSpesialHeaderEntity.fromJson(String source) =>
      PromoHargaSpesialHeaderEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoHargaSpesialHeaderEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, promoCode: $promoCode, description: $description, startDate: $startDate, endDate: $endDate, startTime: $startTime, endTime: $endTime, remarks: $remarks, statusActive: $statusActive, maxPurchaseDay: $maxPurchaseDay, maxPurchaseTransaction: $maxPurchaseTransaction, validMultiply: $validMultiply, quota: $quota, promoAlias: $promoAlias, toitmId: $toitmId, promoType: $promoType, form: $form, detailQtyValidation: $detailQtyValidation)';
  }

  @override
  bool operator ==(covariant PromoHargaSpesialHeaderEntity other) {
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
        other.maxPurchaseDay == maxPurchaseDay &&
        other.maxPurchaseTransaction == maxPurchaseTransaction &&
        other.validMultiply == validMultiply &&
        other.quota == quota &&
        other.promoAlias == promoAlias &&
        other.toitmId == toitmId &&
        other.promoType == promoType &&
        other.form == form &&
        other.detailQtyValidation == detailQtyValidation;
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
        maxPurchaseDay.hashCode ^
        maxPurchaseTransaction.hashCode ^
        validMultiply.hashCode ^
        quota.hashCode ^
        promoAlias.hashCode ^
        toitmId.hashCode ^
        promoType.hashCode ^
        form.hashCode ^
        detailQtyValidation.hashCode;
  }
}
