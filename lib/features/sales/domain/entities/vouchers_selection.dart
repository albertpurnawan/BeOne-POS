import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class VouchersSelectionEntity {
  final String docId;
  String? tpmt3Id;
  final String tovcrId;
  final String voucherAlias;
  final int voucherAmount;
  final DateTime validFrom;
  final DateTime validTo;
  final String serialNo;
  final int voucherStatus;
  final int statusActive;
  final int minPurchase;
  final DateTime? redeemDate;
  String? tinv2Id;
  final int type;

  VouchersSelectionEntity({
    required this.docId,
    required this.tpmt3Id,
    required this.tovcrId,
    required this.voucherAlias,
    required this.voucherAmount,
    required this.validFrom,
    required this.validTo,
    required this.serialNo,
    required this.voucherStatus,
    required this.statusActive,
    required this.minPurchase,
    this.redeemDate,
    this.tinv2Id,
    required this.type,
  });

  VouchersSelectionEntity copyWith({
    String? docId,
    String? tpmt3Id,
    String? tovcrId,
    String? voucherAlias,
    int? voucherAmount,
    DateTime? validFrom,
    DateTime? validTo,
    String? serialNo,
    int? voucherStatus,
    int? statusActive,
    int? minPurchase,
    DateTime? redeemDate,
    String? tinv2Id,
    int? type,
  }) {
    return VouchersSelectionEntity(
      docId: docId ?? this.docId,
      tpmt3Id: tpmt3Id ?? this.tpmt3Id,
      tovcrId: tovcrId ?? this.tovcrId,
      voucherAlias: voucherAlias ?? this.voucherAlias,
      voucherAmount: voucherAmount ?? this.voucherAmount,
      validFrom: validFrom ?? this.validFrom,
      validTo: validTo ?? this.validTo,
      serialNo: serialNo ?? this.serialNo,
      voucherStatus: voucherStatus ?? this.voucherStatus,
      statusActive: statusActive ?? this.statusActive,
      minPurchase: minPurchase ?? this.minPurchase,
      redeemDate: redeemDate ?? this.redeemDate,
      tinv2Id: tinv2Id ?? this.tinv2Id,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'tpmt3Id': tpmt3Id,
      'tovcrId': tovcrId,
      'voucherAlias': voucherAlias,
      'voucherAmount': voucherAmount,
      'validFrom': validFrom.millisecondsSinceEpoch,
      'validTo': validTo.millisecondsSinceEpoch,
      'serialNo': serialNo,
      'voucherStatus': voucherStatus,
      'statusActive': statusActive,
      'minPurchase': minPurchase,
      'redeemDate': redeemDate?.millisecondsSinceEpoch,
      'tinv2Id': tinv2Id,
      'type': type,
    };
  }

  factory VouchersSelectionEntity.fromMap(Map<String, dynamic> map) {
    return VouchersSelectionEntity(
      docId: map['docId'] as String,
      tpmt3Id: map['tpmt3Id'] != null ? map['tpmt3Id'] as String : null,
      tovcrId: map['tovcrId'] as String,
      voucherAlias: map['voucherAlias'] as String,
      voucherAmount: map['voucherAmount'] as int,
      validFrom: DateTime.fromMillisecondsSinceEpoch(map['validFrom'] as int),
      validTo: DateTime.fromMillisecondsSinceEpoch(map['validTo'] as int),
      serialNo: map['serialNo'] as String,
      voucherStatus: map['voucherStatus'] as int,
      statusActive: map['statusActive'] as int,
      minPurchase: map['minPurchase'] as int,
      redeemDate: map['redeemDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['redeemDate'] as int)
          : null,
      tinv2Id: map['tinv2Id'] != null ? map['tinv2Id'] as String : null,
      type: map['type'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory VouchersSelectionEntity.fromJson(String source) =>
      VouchersSelectionEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VouchersSelectionEntity(docId: $docId, tpmt3Id: $tpmt3Id, tovcrId: $tovcrId, voucherAlias: $voucherAlias, voucherAmount: $voucherAmount, validFrom: $validFrom, validTo: $validTo, serialNo: $serialNo, voucherStatus: $voucherStatus, statusActive: $statusActive, minPurchase: $minPurchase, redeemDate: $redeemDate, tinv2Id: $tinv2Id, type: $type)';
  }

  @override
  bool operator ==(covariant VouchersSelectionEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.tpmt3Id == tpmt3Id &&
        other.tovcrId == tovcrId &&
        other.voucherAlias == voucherAlias &&
        other.voucherAmount == voucherAmount &&
        other.validFrom == validFrom &&
        other.validTo == validTo &&
        other.serialNo == serialNo &&
        other.voucherStatus == voucherStatus &&
        other.statusActive == statusActive &&
        other.minPurchase == minPurchase &&
        other.redeemDate == redeemDate &&
        other.tinv2Id == tinv2Id &&
        other.type == type;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        tpmt3Id.hashCode ^
        tovcrId.hashCode ^
        voucherAlias.hashCode ^
        voucherAmount.hashCode ^
        validFrom.hashCode ^
        validTo.hashCode ^
        serialNo.hashCode ^
        voucherStatus.hashCode ^
        statusActive.hashCode ^
        minPurchase.hashCode ^
        redeemDate.hashCode ^
        tinv2Id.hashCode ^
        type.hashCode;
  }
}
