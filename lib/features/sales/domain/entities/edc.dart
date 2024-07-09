// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class EDCEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String edcCode;
  final String description;
  final String form;

  EDCEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.edcCode,
    required this.description,
    required this.form,
  });

  EDCEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? edcCode,
    String? description,
    String? form,
  }) {
    return EDCEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      edcCode: edcCode ?? this.edcCode,
      description: description ?? this.description,
      form: form ?? this.form,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'edcCode': edcCode,
      'description': description,
      'form': form,
    };
  }

  factory EDCEntity.fromMap(Map<String, dynamic> map) {
    return EDCEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      edcCode: map['edcCode'] as String,
      description: map['description'] as String,
      form: map['form'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory EDCEntity.fromJson(String source) =>
      EDCEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EDCEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, edcCode: $edcCode, description: $description, form: $form)';
  }

  @override
  bool operator ==(covariant EDCEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.edcCode == edcCode &&
        other.description == description &&
        other.form == form;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        edcCode.hashCode ^
        description.hashCode ^
        form.hashCode;
  }
}
