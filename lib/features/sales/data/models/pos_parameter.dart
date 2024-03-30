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
    tcurrId,
    currCode,
    tocsrId,
    tovatId,
    baseUrl,
    user,
    password,
  ];

  static const String docId = 'docid';
  static const String createDate = 'createdate';
  static const String updateDate = 'updatedate';
  static const String gtentId = 'gtentId';
  static const String tostrId = 'tostrId';
  static const String storeName = 'storename';
  static const String tcurrId = 'tcurrId';
  static const String currCode = 'currcode';
  static const String tocsrId = "tocsrId";
  static const String tovatId = "tovatId";
  static const String baseUrl = "baseUrl";
  static const String user = "user";
  static const String password = "password";
}

class POSParameterModel extends POSParameterEntity implements BaseModel {
  POSParameterModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.gtentId,
    required super.tostrId,
    required super.storeName,
    required super.tcurrId,
    required super.currCode,
    required super.tocsrId,
    required super.tovatId,
    required super.baseUrl,
    required super.user,
    required super.password,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toLocal().toIso8601String(),
      'updatedate': updateDate?.toLocal().toIso8601String(),
      'gtentId': gtentId,
      'tostrId': tostrId,
      'storename': storeName,
      'tcurrId': tcurrId,
      'currcode': currCode,
      'tocsrId': tocsrId,
      'tovatId': tovatId,
      'baseUrl': baseUrl,
      'user': user,
      'password': password,
    };
  }

  factory POSParameterModel.fromMap(Map<String, dynamic> map) {
    return POSParameterModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      gtentId: map['gtentId'] as String,
      tostrId: map['tostrId'] as String,
      storeName: map['storename'] as String,
      tcurrId: map['tcurrId'] as String,
      currCode: map['currcode'] as String,
      tocsrId: map['tocsrId'] as String,
      tovatId: map['tovatId'] as String,
      baseUrl: map['baseUrl'] as String,
      user: map['user'] as String,
      password: map['password'] as String,
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
      tcurrId: entity.tcurrId,
      currCode: entity.currCode,
      tocsrId: entity.tocsrId,
      tovatId: entity.tovatId,
      baseUrl: entity.baseUrl,
      user: entity.baseUrl,
      password: entity.baseUrl,
    );
  }
}
