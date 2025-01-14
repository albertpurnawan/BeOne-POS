import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/uom.dart';

const String tableUom = 'touom';

class UomFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    uomCode,
    uomDesc,
    statusActive,
    activated,
    form,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String uomCode = "uomcode";
  static const String uomDesc = "uomdesc";
  static const String statusActive = "statusactive";
  static const String activated = "activated";
  static const String form = "form";
}

class UomModel extends UomEntity implements BaseModel {
  UomModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.uomCode,
    required super.uomDesc,
    required super.statusActive,
    required super.activated,
    required super.form,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.toUtc().toIso8601String(),
      'updateDate': updateDate?.toUtc().toIso8601String(),
      'uomCode': uomCode,
      'uomDesc': uomDesc,
      'statusActive': statusActive,
      'activated': activated,
      'form': form,
    };
  }

  factory UomModel.fromMap(Map<String, dynamic> map) {
    return UomModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate']).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate']).toLocal()
          : null,
      uomCode: map['uomcode'] as String,
      uomDesc: map['uomdesc'] as String,
      statusActive: map['statusactive'] as int,
      activated: map['activated'] as int,
      form: map['form'] as String,
    );
  }
}
