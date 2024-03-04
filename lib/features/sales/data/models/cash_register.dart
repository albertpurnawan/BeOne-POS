import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/cash_register.dart';

const String tableCashRegister = "tocsr";

class CashRegisterFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    tostrId,
    hwkey,
    token,
    email,
    statusActive,
    activated,
    description,
    ipKassa,
    idKassa,
    printerCode,
    printerLogo,
    strukType,
    bigHeader,
    syncCloud,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String tostrId = "tostrId";
  static const String hwkey = "hwkey";
  static const String token = "token";
  static const String email = "email";
  static const String statusActive = "statusactive";
  static const String activated = "activated";
  static const String description = "description";
  static const String ipKassa = "ipkassa";
  static const String idKassa = "idkassa";
  static const String printerCode = "printercode";
  static const String printerLogo = "printerlogo";
  static const String strukType = "struktype";
  static const String bigHeader = "bigheader";
  static const String syncCloud = "synccloud";
}

class CashRegisterModel extends CashRegisterEntity implements BaseModel {
  CashRegisterModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.tostrId,
    required super.hwkey,
    required super.token,
    required super.email,
    required super.statusActive,
    required super.activated,
    required super.description,
    required super.ipKassa,
    required super.idKassa,
    required super.printerCode,
    required super.printerLogo,
    required super.strukType,
    required super.bigHeader,
    required super.syncCloud,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.toUtc().toIso8601String(),
      'updateDate': updateDate?.toUtc().toIso8601String(),
      'tostrId': tostrId,
      'hwkey': hwkey,
      'token': token,
      'email': email,
      'statusActive': statusActive,
      'activated': activated,
      'description': description,
      'ipKassa': ipKassa,
      'idKassa': idKassa,
      'printerCode': printerCode,
      'printerLogo': printerLogo,
      'strukType': strukType,
      'bigHeader': bigHeader,
      'syncCloud': syncCloud,
    };
  }

  factory CashRegisterModel.fromMap(Map<String, dynamic> map) {
    return CashRegisterModel(
      docId: map['docId'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updateDate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      tostrId: map['tostrId'] != null ? map['tostrId'] as String : null,
      hwkey: map['hwkey'] as String,
      token: map['token'] as String,
      email: map['email'] as String,
      statusActive: map['statusActive'] as int,
      activated: map['activated'] as int,
      description: map['description'] as String,
      ipKassa: map['ipKassa'] != null ? map['ipKassa'] as String : null,
      idKassa: map['idKassa'] != null ? map['idKassa'] as String : null,
      printerCode:
          map['printerCode'] != null ? map['printerCode'] as String : null,
      printerLogo:
          map['printerLogo'] != null ? map['printerLogo'] as int : null,
      strukType: map['strukType'] != null ? map['strukType'] as int : null,
      bigHeader: map['bigHeader'] != null ? map['bigHeader'] as int : null,
      syncCloud: map['syncCloud'] != null ? map['syncCloud'] as int : null,
    );
  }

  factory CashRegisterModel.fromMapRemote(Map<String, dynamic> map) {
    return CashRegisterModel.fromMap({
      ...map,
      "tostrId": map['tostr_id']?['docid'] != null
          ? map['tostr_id']['docid'] as String
          : null,
    });
  }

  factory CashRegisterModel.fromEntity(CashRegisterEntity entity) {
    return CashRegisterModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      tostrId: entity.tostrId,
      hwkey: entity.hwkey,
      token: entity.token,
      email: entity.email,
      statusActive: entity.statusActive,
      activated: entity.activated,
      description: entity.description,
      ipKassa: entity.ipKassa,
      idKassa: entity.idKassa,
      printerCode: entity.printerCode,
      printerLogo: entity.printerLogo,
      strukType: entity.strukType,
      bigHeader: entity.bigHeader,
      syncCloud: entity.syncCloud,
    );
  }
}
