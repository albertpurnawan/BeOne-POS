// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ReceiptContentEntity {
  final int? id;
  final int row;
  final String content;
  final int fontSize;
  final bool isBold;
  final int alignment;
  final String? customValue;

  ReceiptContentEntity({
    required this.id,
    required this.row,
    required this.content,
    required this.fontSize,
    required this.isBold,
    required this.alignment,
    required this.customValue,
  });

  ReceiptContentEntity copyWith({
    int? id,
    int? row,
    String? content,
    int? fontSize,
    bool? isBold,
    int? alignment,
    String? customValue,
  }) {
    return ReceiptContentEntity(
      id: id ?? this.id,
      row: row ?? this.row,
      content: content ?? this.content,
      fontSize: fontSize ?? this.fontSize,
      isBold: isBold ?? this.isBold,
      alignment: alignment ?? this.alignment,
      customValue: customValue ?? this.customValue,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'row': row,
      'content': content,
      'fontSize': fontSize,
      'isBold': isBold,
      'alignment': alignment,
      'customValue': customValue,
    };
  }

  factory ReceiptContentEntity.fromMap(Map<String, dynamic> map) {
    return ReceiptContentEntity(
      id: map['id'] != null ? map['id'] as int : null,
      row: map['row'] as int,
      content: map['content'] as String,
      fontSize: map['fontSize'] as int,
      isBold: map['isBold'] as bool,
      alignment: map['alignment'] as int,
      customValue:
          map['customValue'] != null ? map['customValue'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReceiptContentEntity.fromJson(String source) =>
      ReceiptContentEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReceiptContentEntity(id: $id, row: $row, content: $content, fontSize: $fontSize, isBold: $isBold, alignment: $alignment, customValue: $customValue)';
  }

  @override
  bool operator ==(covariant ReceiptContentEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.row == row &&
        other.content == content &&
        other.fontSize == fontSize &&
        other.isBold == isBold &&
        other.alignment == alignment &&
        other.customValue == customValue;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        row.hashCode ^
        content.hashCode ^
        fontSize.hashCode ^
        isBold.hashCode ^
        alignment.hashCode ^
        customValue.hashCode;
  }
}
