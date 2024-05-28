// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProvinceEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String provncCode;
  final String description;
  final String descriptionFrgn;
  final String? tocryId;
  final String form;

  ProvinceEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    required this.provncCode,
    required this.description,
    required this.descriptionFrgn,
    this.tocryId,
    required this.form,
  });

  ProvinceEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? provncCode,
    String? description,
    String? descriptionFrgn,
    String? tocryId,
    String? form,
  }) {
    return ProvinceEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      provncCode: provncCode ?? this.provncCode,
      description: description ?? this.description,
      descriptionFrgn: descriptionFrgn ?? this.descriptionFrgn,
      tocryId: tocryId ?? this.tocryId,
      form: form ?? this.form,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'provncCode': provncCode,
      'description': description,
      'descriptionFrgn': descriptionFrgn,
      'tocryId': tocryId,
      'form': form,
    };
  }

  factory ProvinceEntity.fromMap(Map<String, dynamic> map) {
    return ProvinceEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      provncCode: map['provncCode'] as String,
      description: map['description'] as String,
      descriptionFrgn: map['descriptionFrgn'] as String,
      tocryId: map['tocryId'] != null ? map['tocryId'] as String : null,
      form: map['form'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProvinceEntity.fromJson(String source) =>
      ProvinceEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProvinceEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, provncCode: $provncCode, description: $description, descriptionFrgn: $descriptionFrgn, tocryId: $tocryId, form: $form)';
  }

  @override
  bool operator ==(covariant ProvinceEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.provncCode == provncCode &&
        other.description == description &&
        other.descriptionFrgn == descriptionFrgn &&
        other.tocryId == tocryId &&
        other.form == form;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        provncCode.hashCode ^
        description.hashCode ^
        descriptionFrgn.hashCode ^
        tocryId.hashCode ^
        form.hashCode;
  }
}
