import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/house_bank_account.dart';

const String tableHouseBankAccount = "tobnk";

class HouseBankAccountFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    accountNo,
    accountName,
    bank,
    tostrId,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String accountNo = "accountno";
  static const String accountName = "accountname";
  static const String bank = "bank";
  static const String tostrId = "tostrId";
}

class HouseBankAccountModel extends HouseBankAccountEntity
    implements BaseModel {
  HouseBankAccountModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.accountNo,
    required super.accountName,
    required super.bank,
    required super.tostrId,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'accountno': accountNo,
      'accountname': accountName,
      'bank': bank,
      'tostrId': tostrId,
    };
  }

  factory HouseBankAccountModel.fromMap(Map<String, dynamic> map) {
    return HouseBankAccountModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      accountNo: map['accountno'] as String,
      accountName: map['accountname'] as String,
      bank: map['bank'] as String,
      tostrId: map['tostrId'] != null ? map['tostrId'] as String : null,
    );
  }

  factory HouseBankAccountModel.fromMapRemote(Map<String, dynamic> map) {
    return HouseBankAccountModel.fromMap({
      ...map,
      "tostrId": map['tostr_id']?['docid'] != null
          ? map['tostr_id']['docid'] as String
          : null,
    });
  }

  factory HouseBankAccountModel.fromEntity(HouseBankAccountEntity entity) {
    return HouseBankAccountModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      accountNo: entity.accountNo,
      accountName: entity.accountName,
      bank: entity.bank,
      tostrId: entity.tostrId,
    );
  }
}
