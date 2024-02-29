import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';

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
  ];

  static const String docId = 'docid';
  static const String createDate = 'createdate';
  static const String updateDate = 'updatedate';
  static const String tostrId = 'tostrid';
  static const String storeName = 'storename';
  static const String tcurrId = 'tcurrid';
  static const String currCode = 'currcode';
  static const String toplnId = 'toplnid';
}

class POSParameterModel extends POSParameterEntity {
  POSParameterModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.tostrId,
    required super.storeName,
    required super.tcurrId,
    required super.currCode,
    required super.toplnId,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toLocal().toIso8601String(),
      'updatedate': updateDate?.toLocal().toIso8601String(),
      'tostrid': tostrId,
      'storename': storeName,
      'tcurrid': tcurrId,
      'currcode': currCode,
      'toplnid': toplnId,
    };
  }

  factory POSParameterModel.fromMap(Map<String, dynamic> map) {
    return POSParameterModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate']).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['createdate']).toLocal()
          : null,
      tostrId: map['tostrid'] as String,
      storeName: map['storename'] as String,
      tcurrId: map['tcurrid'] as String,
      currCode: map['currcode'] as String,
      toplnId: map['toplnid'] as String,
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
    );
  }
}
