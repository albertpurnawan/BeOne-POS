import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/cashier_balance_transaction.dart';

const String tableCashierBalanceTransaction = "tcsr1";

class CashierBalanceTransactionFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    tocsrId,
    tousrId,
    docNum,
    openDate,
    openTime,
    calcDate,
    calcTime,
    closeDate,
    closeTime,
    timezone,
    openValue,
    calcValue,
    cashValue,
    closeValue,
    openedbyId,
    closedbyId,
    approvalStatus,
    refpos,
    syncToBos,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String tocsrId = "tocsrId";
  static const String tousrId = "tousrId";
  static const String docNum = "docnum";
  static const String openDate = "opendate";
  static const String openTime = "opentime";
  static const String calcDate = "calcdate";
  static const String calcTime = "calctime";
  static const String closeDate = "closedate";
  static const String closeTime = "closetime";
  static const String timezone = "timezone";
  static const String openValue = "openvalue";
  static const String calcValue = "calcvalue";
  static const String cashValue = "cashvalue";
  static const String closeValue = "closevalue";
  static const String openedbyId = "openedbyId";
  static const String closedbyId = "closedbyId";
  static const String approvalStatus = "approvalstatus";
  static const String refpos = "refpos";
  static const String syncToBos = "synctobos";
}

class CashierBalanceTransactionModel extends CashierBalanceTransactionEntity
    implements BaseModel {
  CashierBalanceTransactionModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.tocsrId,
    required super.tousrId,
    required super.docNum,
    required super.openDate,
    required super.openTime,
    required super.calcDate,
    required super.calcTime,
    required super.closeDate,
    required super.closeTime,
    required super.timezone,
    required super.openValue,
    required super.calcValue,
    required super.cashValue,
    required super.closeValue,
    required super.openedbyId,
    required super.closedbyId,
    required super.approvalStatus,
    required super.refpos,
    required super.syncToBos,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'tocsrId': tocsrId,
      'tousrId': tousrId,
      'docnum': docNum,
      'opendate': openDate.toUtc().toIso8601String(),
      'opentime': openTime.toUtc().toIso8601String(),
      'calcdate': calcDate.toUtc().toIso8601String(),
      'calctime': calcTime.toUtc().toIso8601String(),
      'closedate': closeDate.toUtc().toIso8601String(),
      'closetime': closeTime.toUtc().toIso8601String(),
      'timezone': timezone,
      'openvalue': openValue,
      'calcvalue': calcValue,
      'cashvalue': cashValue,
      'closevalue': closeValue,
      'openedbyId': openedbyId,
      'closedbyId': closedbyId,
      'approvalstatus': approvalStatus,
      'refpos': refpos,
      'synctobos': syncToBos,
    };
  }

  factory CashierBalanceTransactionModel.fromMap(Map<String, dynamic> map) {
    return CashierBalanceTransactionModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      tocsrId: map['tocsrId'] != null ? map['tocsrId'] as String : null,
      tousrId: map['tousrId'] != null ? map['tousrId'] as String : null,
      docNum: map['docnum'] as String,
      openDate: DateTime.parse(map['opendate'] as String).toLocal(),
      openTime: DateTime.parse(map['opentime'] as String).toLocal(),
      calcDate: DateTime.parse(map['calcdate'] as String).toLocal(),
      calcTime: DateTime.parse(map['calctime'] as String).toLocal(),
      closeDate: DateTime.parse(map['closedate'] as String).toLocal(),
      closeTime: DateTime.parse(map['closetime'] as String).toLocal(),
      timezone: map['timezone'] as String,
      openValue: map['openvalue'] as double,
      calcValue: map['calcvalue'] as double,
      cashValue: map['cashvalue'] as double,
      closeValue: map['closevalue'] as double,
      openedbyId:
          map['openedbyId'] != null ? map['openedbyId'] as String : null,
      closedbyId:
          map['closedbyId'] != null ? map['closedbyId'] as String : null,
      approvalStatus: map['approvalstatus'] as int,
      refpos: map['refpos'] != null ? map['refpos'] as String : null,
      syncToBos: map['synctobos'] != null ? map['synctobos'] as int : null,
    );
  }

  factory CashierBalanceTransactionModel.fromMapRemote(
      Map<String, dynamic> map) {
    return CashierBalanceTransactionModel.fromMap({
      ...map,
      "tocsrId": map['tocsr_id']?['docid'] != null
          ? map['tocsr_id']['docid'] as String
          : null,
      "tousrId": map['tousr_id']?['docid'] != null
          ? map['tousr_id']['docid'] as String
          : null,
      "openvalue": map['openvalue'].toDouble() as double,
      "calcvalue": map['calcvalue'].toDouble() as double,
      "cashvalue": map['cashvalue'].toDouble() as double,
      "closevalue": map['closevalue'].toDouble() as double,
    });
  }

  factory CashierBalanceTransactionModel.fromEntity(
      CashierBalanceTransactionEntity entity) {
    return CashierBalanceTransactionModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      tocsrId: entity.tocsrId,
      tousrId: entity.tousrId,
      docNum: entity.docNum,
      openDate: entity.openDate,
      openTime: entity.openTime,
      calcDate: entity.calcDate,
      calcTime: entity.calcTime,
      closeDate: entity.closeDate,
      closeTime: entity.closeTime,
      timezone: entity.timezone,
      openValue: entity.openValue,
      calcValue: entity.calcValue,
      cashValue: entity.cashValue,
      closeValue: entity.closeValue,
      openedbyId: entity.openedbyId,
      closedbyId: entity.closedbyId,
      approvalStatus: entity.approvalStatus,
      refpos: entity.refpos,
      syncToBos: entity.syncToBos,
    );
  }
}
