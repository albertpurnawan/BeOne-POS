import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/settings/domain/entities/pos_parameter.dart';

const String tablePOSParameter = 'topos';

class POSParameterFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    tostrId,
    storeName,
    tcurrId,
    currCode,
    toplnId,
    tocsrId,
    tovatId,
    customerDisplayActive,
  ];

  static const String docId = 'docid';
  static const String createDate = 'createdate';
  static const String updateDate = 'updatedate';
  static const String tostrId = 'tostrId';
  static const String storeName = 'storename';
  static const String tcurrId = 'tcurrId';
  static const String currCode = 'currcode';
  static const String toplnId = 'toplnId';
  static const String tocsrId = "tocsrId";
  static const String tovatId = "tovatId";
  static const String customerDisplayActive = "customerDisplayActive";
}

class POSParameterModel extends POSParameterEntity implements BaseModel {
  POSParameterModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.tostrId,
    required super.storeName,
    required super.tcurrId,
    required super.currCode,
    required super.toplnId,
    required super.tocsrId,
    required super.tovatId,
    required super.customerDisplayActive,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toLocal().toIso8601String(),
      'updatedate': updateDate?.toLocal().toIso8601String(),
      'tostrId': tostrId,
      'storename': storeName,
      'tcurrId': tcurrId,
      'currcode': currCode,
      'toplnId': toplnId,
      'tocsrId': tocsrId,
      'tovatId': tovatId,
      'customerDisplayActive': customerDisplayActive,
    };
  }

  factory POSParameterModel.fromMap(Map<String, dynamic> map) {
    return POSParameterModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate']).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate']).toLocal()
          : null,
      tostrId: map['tostrId'] as String,
      storeName: map['storename'] as String,
      tcurrId: map['tcurrId'] as String,
      currCode: map['currcode'] as String,
      toplnId: map['toplnId'] as String,
      tocsrId: map['tocsrId'] as String,
      tovatId: map['tovatId'] as String,
      customerDisplayActive: map['customerDisplayActive'] as int,
    );
  }

  factory POSParameterModel.fromEntity(POSParameterEntity entity) {
    return POSParameterModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      tostrId: entity.tostrId,
      storeName: entity.storeName,
      tcurrId: entity.tcurrId,
      currCode: entity.currCode,
      toplnId: entity.toplnId,
      tocsrId: entity.tocsrId,
      tovatId: entity.tovatId,
      customerDisplayActive: entity.customerDisplayActive,
    );
  }
}
