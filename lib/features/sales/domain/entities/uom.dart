// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UomEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String uomCode;
  final String uomDesc;
  final int statusActive;
  final int activated;
  final String form;

  UomEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    required this.uomCode,
    required this.uomDesc,
    required this.statusActive,
    required this.activated,
    required this.form,
  });

  UomEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? uomCode,
    String? uomDesc,
    int? statusActive,
    int? activated,
    String? form,
  }) {
    return UomEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      uomCode: uomCode ?? this.uomCode,
      uomDesc: uomDesc ?? this.uomDesc,
      statusActive: statusActive ?? this.statusActive,
      activated: activated ?? this.activated,
      form: form ?? this.form,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'uomCode': uomCode,
      'uomDesc': uomDesc,
      'statusActive': statusActive,
      'activated': activated,
      'form': form,
    };
  }

  factory UomEntity.fromMap(Map<String, dynamic> map) {
    return UomEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      uomCode: map['uomCode'] as String,
      uomDesc: map['uomDesc'] as String,
      statusActive: map['statusActive'] as int,
      activated: map['activated'] as int,
      form: map['form'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UomEntity.fromJson(String source) =>
      UomEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UomEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, uomCode: $uomCode, uomDesc: $uomDesc, statusActive: $statusActive, activated: $activated, form: $form)';
  }

  @override
  bool operator ==(covariant UomEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.uomCode == uomCode &&
        other.uomDesc == uomDesc &&
        other.statusActive == statusActive &&
        other.activated == activated &&
        other.form == form;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        uomCode.hashCode ^
        uomDesc.hashCode ^
        statusActive.hashCode ^
        activated.hashCode ^
        form.hashCode;
  }
}
