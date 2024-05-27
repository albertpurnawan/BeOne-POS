// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class VendorEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String vendCode;
  final String vendName;
  final String? tovdgId;
  // final String idCard;
  // final String taxNo;
  // final String gender;
  // final DateTime? birthdate;
  // final String addr1;
  // final String? addr2;
  // final String? addr3;
  // final String city;
  // final String? toprvId;
  // final String? tocryId;
  // final String? tozcdId;
  // final String phone;
  // final String email;
  final String? remarks;
  // final String? toptrId;
  // final String? toplnId;
  // final double maxDiscount;
  // final int statusActive;
  // final int activated;
  // final String? tohemId;
  // final int sync;
  final String form;

  VendorEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    required this.vendCode,
    required this.vendName,
    this.tovdgId,
    this.remarks,
    required this.form,
  });

  VendorEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? vendCode,
    String? vendName,
    String? tovdgId,
    String? remarks,
    String? form,
  }) {
    return VendorEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      vendCode: vendCode ?? this.vendCode,
      vendName: vendName ?? this.vendName,
      tovdgId: tovdgId ?? this.tovdgId,
      remarks: remarks ?? this.remarks,
      form: form ?? this.form,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'vendCode': vendCode,
      'vendName': vendName,
      'tovdgId': tovdgId,
      'remarks': remarks,
      'form': form,
    };
  }

  factory VendorEntity.fromMap(Map<String, dynamic> map) {
    return VendorEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      vendCode: map['vendCode'] as String,
      vendName: map['vendName'] as String,
      tovdgId: map['tovdgId'] != null ? map['tovdgId'] as String : null,
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
      form: map['form'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory VendorEntity.fromJson(String source) =>
      VendorEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VendorEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, vendCode: $vendCode, vendName: $vendName, tovdgId: $tovdgId, remarks: $remarks, form: $form)';
  }

  @override
  bool operator ==(covariant VendorEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.vendCode == vendCode &&
        other.vendName == vendName &&
        other.tovdgId == tovdgId &&
        other.remarks == remarks &&
        other.form == form;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        vendCode.hashCode ^
        vendName.hashCode ^
        tovdgId.hashCode ^
        remarks.hashCode ^
        form.hashCode;
  }
}
