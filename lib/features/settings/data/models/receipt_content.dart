import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/settings/domain/entities/receipt_content.dart';

const String tableReceiptContents = "receiptcontents";

class ReceiptContentFields {
  static const List<String> values = [
    id,
    row,
    content,
    fontSize,
    isBold,
    alignment,
    customValue,
  ];

  static const String id = 'id';
  static const String row = 'row';
  static const String content = 'content';
  static const String fontSize = 'fontsize';
  static const String isBold = 'isbold';
  static const String alignment = 'alignment';
  static const String customValue = 'customvalue';
}

class ReceiptContentModel extends ReceiptContentEntity implements BaseModel {
  ReceiptContentModel({
    required super.id,
    required super.row,
    required super.content,
    required super.fontSize,
    required super.isBold,
    required super.alignment,
    required super.customValue,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'row': row,
      'content': content,
      'fontsize': fontSize,
      'isbold': isBold ? 1 : 0,
      'alignment': alignment,
      'customvalue': customValue,
    };
  }

  factory ReceiptContentModel.fromMap(Map<String, dynamic> map) {
    return ReceiptContentModel(
      id: map['id'] != null ? map['id'] as int : null,
      row: map['row'] as int,
      content: map['content'] as String,
      fontSize: map['fontsize'] as int,
      isBold: (map['isbold'] as int) == 1 ? true : false,
      alignment: map['alignment'] as int,
      customValue:
          map['customvalue'] != null ? map['customvalue'] as String : null,
    );
  }

  factory ReceiptContentModel.fromEntity(ReceiptContentEntity entity) {
    return ReceiptContentModel(
      id: entity.id,
      row: entity.row,
      content: entity.content,
      fontSize: entity.fontSize,
      isBold: entity.isBold,
      alignment: entity.alignment,
      customValue: entity.customValue,
    );
  }
}
