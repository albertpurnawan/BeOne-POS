// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CurrencyEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String curCode;
  final String description;
  final String descriptionFrgn;
  final String form;

  CurrencyEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    required this.curCode,
    required this.description,
    required this.descriptionFrgn,
    required this.form,
  });

  CurrencyEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? curCode,
    String? description,
    String? descriptionFrgn,
    String? form,
  }) {
    return CurrencyEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      curCode: curCode ?? this.curCode,
      description: description ?? this.description,
      descriptionFrgn: descriptionFrgn ?? this.descriptionFrgn,
      form: form ?? this.form,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'curCode': curCode,
      'description': description,
      'descriptionFrgn': descriptionFrgn,
      'form': form,
    };
  }

  factory CurrencyEntity.fromMap(Map<String, dynamic> map) {
    return CurrencyEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      curCode: map['curCode'] as String,
      description: map['description'] as String,
      descriptionFrgn: map['descriptionFrgn'] as String,
      form: map['form'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CurrencyEntity.fromJson(String source) =>
      CurrencyEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CurrencyEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, curCode: $curCode, description: $description, descriptionFrgn: $descriptionFrgn, form: $form)';
  }

  @override
  bool operator ==(covariant CurrencyEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.curCode == curCode &&
        other.description == description &&
        other.descriptionFrgn == descriptionFrgn &&
        other.form == form;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        curCode.hashCode ^
        description.hashCode ^
        descriptionFrgn.hashCode ^
        form.hashCode;
  }
}
