import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/edc.dart';

const String tableEDC = "tpmt4";

class EDCFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    edcCode,
    description,
    form,
  ];

  static const String docId = 'docid';
  static const String createDate = 'createdate';
  static const String updateDate = 'updatedate';
  static const String edcCode = 'edccode';
  static const String description = 'description';
  static const String form = 'form';
}

class EDCModel extends EDCEntity implements BaseModel {
  EDCModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.edcCode,
    required super.description,
    required super.form,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'edccode': edcCode,
      'description': description,
      'form': form,
    };
  }

  factory EDCModel.fromMap(Map<String, dynamic> map) {
    return EDCModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      edcCode: map['edccode'] as String,
      description: map['description'] as String,
      form: map['form'] as String,
    );
  }

  factory EDCModel.fromMapRemote(Map<String, dynamic> map) {
    return EDCModel.fromMap({
      ...map,
      "description": map['descriptionn'] as String,
    });
  }

  factory EDCModel.fromEntity(EDCEntity entity) {
    return EDCModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      edcCode: entity.edcCode,
      description: entity.description,
      form: entity.form,
    );
  }
}
