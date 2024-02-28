import 'package:pos_fe/features/sales/domain/entities/currency.dart';

const String tableCurrencies = "tcurr";

class CurrencyFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    curCode,
    description,
    descriptionFrgn,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String curCode = "curcode";
  static const String description = "description";
  static const String descriptionFrgn = "descriptionfrgn";
}

class CurrencyModel extends CurrencyEntity {
  CurrencyModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.curCode,
    required super.description,
    required super.descriptionFrgn,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'curcode': curCode,
      'description': description,
      'descriptionfrgn': descriptionFrgn,
    };
  }

  factory CurrencyModel.fromMap(Map<String, dynamic> map) {
    return CurrencyModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      curCode: map['curcode'] as String,
      description: map['description'] as String,
      descriptionFrgn: map['descriptionfrgn'] as String,
    );
  }

  factory CurrencyModel.fromEntity(CurrencyEntity entity) {
    return CurrencyModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      curCode: entity.curCode,
      description: entity.description,
      descriptionFrgn: entity.descriptionFrgn,
    );
  }
}
