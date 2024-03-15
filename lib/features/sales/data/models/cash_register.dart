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
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'tostrId': tostrId,
      'hwkey': hwkey,
      'token': token,
      'email': email,
      'statusactive': statusActive,
      'activated': activated,
      'description': description,
      'ipkassa': ipKassa,
      'idkassa': idKassa,
      'printercode': printerCode,
      'printerlogo': printerLogo,
      'struktype': strukType,
      'bigheader': bigHeader,
      'synccloud': syncCloud,
    };
  }

  factory CashRegisterModel.fromMap(Map<String, dynamic> map) {
    return CashRegisterModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      tostrId: map['tostrId'] != null ? map['tostrId'] as String : null,
      hwkey: map['hwkey'] as String,
      token: map['token'] as String,
      email: map['email'] as String,
      statusActive: map['statusactive'] as int,
      activated: map['activated'] as int,
      description: map['description'] as String,
      ipKassa: map['ipkassa'] != null ? map['ipkassa'] as String : null,
      idKassa: map['idkassa'] != null ? map['idkassa'] as String : null,
      printerCode:
          map['printercode'] != null ? map['printercode'] as String : null,
      printerLogo:
          map['printerlogo'] != null ? map['printerlogo'] as int : null,
      strukType: map['struktype'] != null ? map['struktype'] as int : null,
      bigHeader: map['bigheader'] != null ? map['bigheader'] as int : null,
      syncCloud: map['synccloud'] != null ? map['synccloud'] as int : null,
    );
  }

  factory CashRegisterModel.fromMapRemote(Map<String, dynamic> map) {
    return CashRegisterModel.fromMap({
      ...map,
      "tostrId": map['tostrdocid'] != null ? map['tostrdocid'] as String : null,
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
