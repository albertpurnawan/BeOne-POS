import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class VouchersSelectionEntity {
  final String docId;
  final String tovcrId;
  final String voucherAlias;
  final int voucherAmount;
  final DateTime validFrom;
  final DateTime validTo;
  final String serialNo;
  final int voucherStatus;
  final int statusActive;
  final DateTime? redeemDate;
  final String? tinv2Id;

  VouchersSelectionEntity({
    required this.docId,
    required this.tovcrId,
    required this.voucherAlias,
    required this.voucherAmount,
    required this.validFrom,
    required this.validTo,
    required this.serialNo,
    required this.voucherStatus,
    required this.statusActive,
    this.redeemDate,
    this.tinv2Id,
  });

  VouchersSelectionEntity copyWith({
    String? docId,
    String? tovcrId,
    String? voucherAlias,
    int? voucherAmount,
    DateTime? validFrom,
    DateTime? validTo,
    String? serialNo,
    int? voucherStatus,
    int? statusActive,
    DateTime? redeemDate,
    String? tinv2Id,
  }) {
    return VouchersSelectionEntity(
      docId: docId ?? this.docId,
      tovcrId: tovcrId ?? this.tovcrId,
      voucherAlias: voucherAlias ?? this.voucherAlias,
      voucherAmount: voucherAmount ?? this.voucherAmount,
      validFrom: validFrom ?? this.validFrom,
      validTo: validTo ?? this.validTo,
      serialNo: serialNo ?? this.serialNo,
      voucherStatus: voucherStatus ?? this.voucherStatus,
      statusActive: statusActive ?? this.statusActive,
      redeemDate: redeemDate ?? this.redeemDate,
      tinv2Id: tinv2Id ?? this.tinv2Id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'tovcrId': tovcrId,
      'voucherAlias': voucherAlias,
      'voucherAmount': voucherAmount,
      'validFrom': validFrom.millisecondsSinceEpoch,
      'validTo': validTo.millisecondsSinceEpoch,
      'serialNo': serialNo,
      'voucherStatus': voucherStatus,
      'statusActive': statusActive,
      'redeemDate': redeemDate?.millisecondsSinceEpoch,
      'tinv2Id': tinv2Id,
    };
  }

  factory VouchersSelectionEntity.fromMap(Map<String, dynamic> map) {
    return VouchersSelectionEntity(
      docId: map['docId'] as String,
      tovcrId: map['tovcrId'] as String,
      voucherAlias: map['voucherAlias'] as String,
      voucherAmount: map['voucherAmount'] as int,
      validFrom: DateTime.fromMillisecondsSinceEpoch(map['validFrom'] as int),
      validTo: DateTime.fromMillisecondsSinceEpoch(map['validTo'] as int),
      serialNo: map['serialNo'] as String,
      voucherStatus: map['voucherStatus'] as int,
      statusActive: map['statusActive'] as int,
      redeemDate: map['redeemDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['redeemDate'] as int)
          : null,
      tinv2Id: map['tinv2Id'] != null ? map['tinv2Id'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory VouchersSelectionEntity.fromJson(String source) =>
      VouchersSelectionEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VouchersSelectionEntity(docId: $docId, tovcrId: $tovcrId, voucherAlias: $voucherAlias, voucherAmount: $voucherAmount, validFrom: $validFrom, validTo: $validTo, serialNo: $serialNo, voucherStatus: $voucherStatus, statusActive: $statusActive, redeemDate: $redeemDate, tinv2Id: $tinv2Id)';
  }

  @override
  bool operator ==(covariant VouchersSelectionEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.tovcrId == tovcrId &&
        other.voucherAlias == voucherAlias &&
        other.voucherAmount == voucherAmount &&
        other.validFrom == validFrom &&
        other.validTo == validTo &&
        other.serialNo == serialNo &&
        other.voucherStatus == voucherStatus &&
        other.statusActive == statusActive &&
        other.redeemDate == redeemDate &&
        other.tinv2Id == tinv2Id;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        tovcrId.hashCode ^
        voucherAlias.hashCode ^
        voucherAmount.hashCode ^
        validFrom.hashCode ^
        validTo.hashCode ^
        serialNo.hashCode ^
        voucherStatus.hashCode ^
        statusActive.hashCode ^
        redeemDate.hashCode ^
        tinv2Id.hashCode;
  }
}
