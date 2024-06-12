import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class CashierBalanceTransactionEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? tocsrId;
  final String? tousrId;
  final String docNum;
  final DateTime openDate;
  final DateTime openTime;
  final DateTime calcDate;
  final DateTime calcTime;
  final DateTime closeDate;
  final DateTime closeTime;
  final String timezone;
  final double openValue;
  final double calcValue;
  final double cashValue;
  final double closeValue;
  final String? openedbyId;
  final String? closedbyId;
  final int approvalStatus;
  final String? refpos;
  final int? syncToBos;

  CashierBalanceTransactionEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    this.tocsrId,
    this.tousrId,
    required this.docNum,
    required this.openDate,
    required this.openTime,
    required this.calcDate,
    required this.calcTime,
    required this.closeDate,
    required this.closeTime,
    required this.timezone,
    required this.openValue,
    required this.calcValue,
    required this.cashValue,
    required this.closeValue,
    this.openedbyId,
    this.closedbyId,
    required this.approvalStatus,
    this.refpos,
    this.syncToBos,
  });

  CashierBalanceTransactionEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? tocsrId,
    String? tousrId,
    String? docNum,
    DateTime? openDate,
    DateTime? openTime,
    DateTime? calcDate,
    DateTime? calcTime,
    DateTime? closeDate,
    DateTime? closeTime,
    String? timezone,
    double? openValue,
    double? calcValue,
    double? cashValue,
    double? closeValue,
    String? openedbyId,
    String? closedbyId,
    int? approvalStatus,
    String? refpos,
    int? syncToBos,
  }) {
    return CashierBalanceTransactionEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      tocsrId: tocsrId ?? this.tocsrId,
      tousrId: tousrId ?? this.tousrId,
      docNum: docNum ?? this.docNum,
      openDate: openDate ?? this.openDate,
      openTime: openTime ?? this.openTime,
      calcDate: calcDate ?? this.calcDate,
      calcTime: calcTime ?? this.calcTime,
      closeDate: closeDate ?? this.closeDate,
      closeTime: closeTime ?? this.closeTime,
      timezone: timezone ?? this.timezone,
      openValue: openValue ?? this.openValue,
      calcValue: calcValue ?? this.calcValue,
      cashValue: cashValue ?? this.cashValue,
      closeValue: closeValue ?? this.closeValue,
      openedbyId: openedbyId ?? this.openedbyId,
      closedbyId: closedbyId ?? this.closedbyId,
      approvalStatus: approvalStatus ?? this.approvalStatus,
      refpos: refpos ?? this.refpos,
      syncToBos: syncToBos ?? this.syncToBos,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'tocsrId': tocsrId,
      'tousrId': tousrId,
      'docNum': docNum,
      'openDate': openDate.millisecondsSinceEpoch,
      'openTime': openTime.millisecondsSinceEpoch,
      'calcDate': calcDate.millisecondsSinceEpoch,
      'calcTime': calcTime.millisecondsSinceEpoch,
      'closeDate': closeDate.millisecondsSinceEpoch,
      'closeTime': closeTime.millisecondsSinceEpoch,
      'timezone': timezone,
      'openValue': openValue,
      'calcValue': calcValue,
      'cashValue': cashValue,
      'closeValue': closeValue,
      'openedbyId': openedbyId,
      'closedbyId': closedbyId,
      'approvalStatus': approvalStatus,
      'refpos': refpos,
      'syncToBos': syncToBos,
    };
  }

  factory CashierBalanceTransactionEntity.fromMap(Map<String, dynamic> map) {
    return CashierBalanceTransactionEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      tocsrId: map['tocsrId'] != null ? map['tocsrId'] as String : null,
      tousrId: map['tousrId'] != null ? map['tousrId'] as String : null,
      docNum: map['docNum'] as String,
      openDate: DateTime.fromMillisecondsSinceEpoch(map['openDate'] as int),
      openTime: DateTime.fromMillisecondsSinceEpoch(map['openTime'] as int),
      calcDate: DateTime.fromMillisecondsSinceEpoch(map['calcDate'] as int),
      calcTime: DateTime.fromMillisecondsSinceEpoch(map['calcTime'] as int),
      closeDate: DateTime.fromMillisecondsSinceEpoch(map['closeDate'] as int),
      closeTime: DateTime.fromMillisecondsSinceEpoch(map['closeTime'] as int),
      timezone: map['timezone'] as String,
      openValue: map['openValue'] as double,
      calcValue: map['calcValue'] as double,
      cashValue: map['cashValue'] as double,
      closeValue: map['closeValue'] as double,
      openedbyId:
          map['openedbyId'] != null ? map['openedbyId'] as String : null,
      closedbyId:
          map['closedbyId'] != null ? map['closedbyId'] as String : null,
      approvalStatus: map['approvalStatus'] as int,
      refpos: map['refpos'] != null ? map['refpos'] as String : null,
      syncToBos: map['syncToBos'] != null ? map['syncToBos'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CashierBalanceTransactionEntity.fromJson(String source) =>
      CashierBalanceTransactionEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CashierBalanceTransactionEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, tocsrId: $tocsrId, tousrId: $tousrId, docNum: $docNum, openDate: $openDate, openTime: $openTime, calcDate: $calcDate, calcTime: $calcTime, closeDate: $closeDate, closeTime: $closeTime, timezone: $timezone, openValue: $openValue, calcValue: $calcValue, cashValue: $cashValue, closeValue: $closeValue, openedbyId: $openedbyId, closedbyId: $closedbyId, approvalStatus: $approvalStatus, refpos: $refpos, syncToBos: $syncToBos)';
  }

  @override
  bool operator ==(covariant CashierBalanceTransactionEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.tocsrId == tocsrId &&
        other.tousrId == tousrId &&
        other.docNum == docNum &&
        other.openDate == openDate &&
        other.openTime == openTime &&
        other.calcDate == calcDate &&
        other.calcTime == calcTime &&
        other.closeDate == closeDate &&
        other.closeTime == closeTime &&
        other.timezone == timezone &&
        other.openValue == openValue &&
        other.calcValue == calcValue &&
        other.cashValue == cashValue &&
        other.closeValue == closeValue &&
        other.openedbyId == openedbyId &&
        other.closedbyId == closedbyId &&
        other.approvalStatus == approvalStatus &&
        other.refpos == refpos &&
        other.syncToBos == syncToBos;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        tocsrId.hashCode ^
        tousrId.hashCode ^
        docNum.hashCode ^
        openDate.hashCode ^
        openTime.hashCode ^
        calcDate.hashCode ^
        calcTime.hashCode ^
        closeDate.hashCode ^
        closeTime.hashCode ^
        timezone.hashCode ^
        openValue.hashCode ^
        calcValue.hashCode ^
        cashValue.hashCode ^
        closeValue.hashCode ^
        openedbyId.hashCode ^
        closedbyId.hashCode ^
        approvalStatus.hashCode ^
        refpos.hashCode ^
        syncToBos.hashCode;
  }
}
