import 'package:pos_fe/features/sales/domain/entities/uom.dart';

const String tableUom = 'touom';

class UomFields {
  static const List<String> values = [
    id,
    docId,
    createDate,
    updateDate,
    uomCode,
    uomDesc,
    statusActive,
    activated,
  ];

  static const String id = "_id";
  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String uomCode = "uomcode";
  static const String uomDesc = "uomdesc";
  static const String statusActive = "statusactive";
  static const String activated = "activated";
}

class UomModel extends UomEntity {
  UomModel({
    required super.id,
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.uomCode,
    required super.uomDesc,
    required super.statusActive,
    required super.activated,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'docId': docId,
      'createDate': createDate.toUtc().toIso8601String(),
      'updateDate': updateDate?.toUtc().toIso8601String(),
      'uomCode': uomCode,
      'uomDesc': uomDesc,
      'statusActive': statusActive,
      'activated': activated,
    };
  }

  factory UomModel.fromMap(Map<String, dynamic> map) {
    return UomModel(
      id: map['id'] as int, // id not returned
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate']).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate']).toLocal()
          : null,
      uomCode: map['uomcode'] as String,
      uomDesc: map['uomdesc'] as String,
      // statusActive returned int
      statusActive: map['statusactive'] as bool,
      // activated returned int
      activated: map['activated'] as bool,
    );
  }
}
