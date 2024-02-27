import 'package:pos_fe/core/resources/data_sources_enum.dart';
import 'package:pos_fe/features/sales/domain/entities/currency.dart';

const String tableCurrencies = "tcurr";

class CurrencyFields {
  static const List<String> values = [
    // id,
    docId,
    createDate,
    updateDate,
    curCode,
    description,
    descriptionFrgn,
  ];

  // static const String id = "_id";
  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String curCode = "curcode";
  static const String description = "description";
  static const String descriptionFrgn = "descriptionfrgn";
}

class CurrencyModel extends CurrencyEntity {
  CurrencyModel({
    // required super.id,
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.curCode,
    required super.description,
    required super.descriptionFrgn,
  });

  Map<String, dynamic> toMapByDataSource(DataSource dataSource) {
    return <String, dynamic>{
      // dataSource == DataSource.local ?
      // '_id' : 'id': id,
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'curcode': curCode,
      'description': description,
      'descriptionfrgn': descriptionFrgn,
    };
  }

  factory CurrencyModel.fromMapByDataSource(
      DataSource dataSource, Map<String, dynamic> map) {
    return CurrencyModel(
      // id not returned
      // id: map[dataSource == DataSource.local ? '_id' : 'id'] as int,
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
      // id: entity.id,
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      curCode: entity.curCode,
      description: entity.description,
      descriptionFrgn: entity.descriptionFrgn,
    );
  }
}
