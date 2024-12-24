import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';

const String tablePOSParameter = 'topos';

class POSParameterFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    gtentId,
    tostrId,
    storeName,
    tocsrId,
    baseUrl,
    usernameAdmin,
    passwordAdmin,
    lastSync,
    defaultShowKeyboard,
    customerDisplayActive,
  ];

  static const String docId = 'docid';
  static const String createDate = 'createdate';
  static const String updateDate = 'updatedate';
  static const String gtentId = 'gtentId';
  static const String tostrId = 'tostrId';
  static const String storeName = 'storename';
  static const String tocsrId = "tocsrId";
  static const String baseUrl = "baseurl";
  static const String usernameAdmin = "usernameadmin";
  static const String passwordAdmin = "passwordadmin";
  static const String lastSync = "lastsync";
  static const String defaultShowKeyboard = "defaultshowkeyboard";
  static const String customerDisplayActive = "customerDisplayActive";
}

class POSParameterModel extends POSParameterEntity implements BaseModel {
  POSParameterModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.gtentId,
    required super.tostrId,
    required super.storeName,
    required super.tocsrId,
    required super.baseUrl,
    required super.usernameAdmin,
    required super.passwordAdmin,
    required super.lastSync,
    required super.defaultShowKeyboard,
    required super.customerDisplayActive,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate?.toLocal().toIso8601String(),
      'updatedate': updateDate?.toLocal().toIso8601String(),
      'gtentId': gtentId,
      'tostrId': tostrId,
      'storename': storeName,
      'tocsrId': tocsrId,
      'baseurl': baseUrl,
      'usernameadmin': usernameAdmin,
      'passwordadmin': passwordAdmin,
      'lastsync': lastSync,
      'customerDisplayActive': customerDisplayActive,
      'defaultshowkeyboard': defaultShowKeyboard,
    };
  }

  factory POSParameterModel.fromMap(Map<String, dynamic> map) {
    return POSParameterModel(
      docId: map['docid'] as String,
      createDate: map['createdate'] != null ? DateTime.parse(map['createdate']).toLocal() : null,
      updateDate: map['updatedate'] != null ? DateTime.parse(map['updatedate']).toLocal() : null,
      gtentId: map['gtentId'] != null ? map['gtentId'] as String : null,
      tostrId: map['tostrId'] != null ? map['tostrId'] as String : null,
      storeName: map['storename'] != null ? map['storename'] as String : null,
      tocsrId: map['tocsrId'] != null ? map['tocsrId'] as String : null,
      baseUrl: map['baseurl'] != null ? map['baseurl'] as String : null,
      usernameAdmin: map['usernameadmin'] != null ? map['usernameadmin'] as String : null,
      passwordAdmin: map['passwordadmin'] != null ? map['passwordadmin'] as String : null,
      lastSync: map['lastsync'] != null ? map['lastsync'] as String : null,
      defaultShowKeyboard: map['defaultshowkeyboard'] != null ? map['defaultshowkeyboard'] as int : 0,
      customerDisplayActive: map['customerDisplayActive'] != null ? map['customerDisplayActive'] as int : 0,
    );
  }

  factory POSParameterModel.fromEntity(POSParameterEntity entity) {
    return POSParameterModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      gtentId: entity.gtentId,
      tostrId: entity.tostrId,
      storeName: entity.storeName,
      tocsrId: entity.tocsrId,
      baseUrl: entity.baseUrl,
      usernameAdmin: entity.usernameAdmin,
      passwordAdmin: entity.passwordAdmin,
      lastSync: entity.lastSync,
      defaultShowKeyboard: entity.defaultShowKeyboard,
      customerDisplayActive: entity.customerDisplayActive,
    );
  }
}
