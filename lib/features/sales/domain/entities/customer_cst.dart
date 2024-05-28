// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

class CustomerCstEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String custCode;
  final String custName;
  final String? tocrgId;
  final String phone;
  final String email;
  final String taxNo;
  final double maxDiscount;
  final String? toplnId;
  final DateTime? joinDate;
  final int isEmployee;
  final String? tohemId;
  final String? docid_crm;
  final int statusActive;
  final int activated;
  final String form;

  CustomerCstEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    required this.custCode,
    required this.custName,
    this.tocrgId,
    required this.phone,
    required this.email,
    required this.taxNo,
    required this.maxDiscount,
    this.toplnId,
    this.joinDate,
    required this.isEmployee,
    this.tohemId,
    this.docid_crm,
    required this.statusActive,
    required this.activated,
    required this.form,
  });

  CustomerCstEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? custCode,
    String? custName,
    String? tocrgId,
    String? phone,
    String? email,
    String? taxNo,
    double? maxDiscount,
    String? toplnId,
    DateTime? joinDate,
    int? isEmployee,
    String? tohemId,
    String? docid_crm,
    int? statusActive,
    int? activated,
    String? form,
  }) {
    return CustomerCstEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      custCode: custCode ?? this.custCode,
      custName: custName ?? this.custName,
      tocrgId: tocrgId ?? this.tocrgId,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      taxNo: taxNo ?? this.taxNo,
      maxDiscount: maxDiscount ?? this.maxDiscount,
      toplnId: toplnId ?? this.toplnId,
      joinDate: joinDate ?? this.joinDate,
      isEmployee: isEmployee ?? this.isEmployee,
      tohemId: tohemId ?? this.tohemId,
      docid_crm: docid_crm ?? this.docid_crm,
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
      'custCode': custCode,
      'custName': custName,
      'tocrgId': tocrgId,
      'phone': phone,
      'email': email,
      'taxNo': taxNo,
      'maxDiscount': maxDiscount,
      'toplnId': toplnId,
      'joinDate': joinDate?.millisecondsSinceEpoch,
      'isEmployee': isEmployee,
      'tohemId': tohemId,
      'docid_crm': docid_crm,
      'statusActive': statusActive,
      'activated': activated,
      'form': form,
    };
  }

  factory CustomerCstEntity.fromMap(Map<String, dynamic> map) {
    return CustomerCstEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      custCode: map['custCode'] as String,
      custName: map['custName'] as String,
      tocrgId: map['tocrgId'] != null ? map['tocrgId'] as String : null,
      phone: map['phone'] as String,
      email: map['email'] as String,
      taxNo: map['taxNo'] as String,
      maxDiscount: map['maxDiscount'] as double,
      toplnId: map['toplnId'] != null ? map['toplnId'] as String : null,
      joinDate: map['joinDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['joinDate'] as int)
          : null,
      isEmployee: map['isEmployee'] as int,
      tohemId: map['tohemId'] != null ? map['tohemId'] as String : null,
      docid_crm: map['docid_crm'] != null ? map['docid_crm'] as String : null,
      statusActive: map['statusActive'] as int,
      activated: map['activated'] as int,
      form: map['form'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerCstEntity.fromJson(String source) =>
      CustomerCstEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CustomerCstEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, custCode: $custCode, custName: $custName, tocrgId: $tocrgId, phone: $phone, email: $email, taxNo: $taxNo, maxDiscount: $maxDiscount, toplnId: $toplnId, joinDate: $joinDate, isEmployee: $isEmployee, tohemId: $tohemId, docid_crm: $docid_crm, statusActive: $statusActive, activated: $activated, form: $form)';
  }

  @override
  bool operator ==(covariant CustomerCstEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.custCode == custCode &&
        other.custName == custName &&
        other.tocrgId == tocrgId &&
        other.phone == phone &&
        other.email == email &&
        other.taxNo == taxNo &&
        other.maxDiscount == maxDiscount &&
        other.toplnId == toplnId &&
        other.joinDate == joinDate &&
        other.isEmployee == isEmployee &&
        other.tohemId == tohemId &&
        other.docid_crm == docid_crm &&
        other.statusActive == statusActive &&
        other.activated == activated &&
        other.form == form;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        custCode.hashCode ^
        custName.hashCode ^
        tocrgId.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        taxNo.hashCode ^
        maxDiscount.hashCode ^
        toplnId.hashCode ^
        joinDate.hashCode ^
        isEmployee.hashCode ^
        tohemId.hashCode ^
        docid_crm.hashCode ^
        statusActive.hashCode ^
        activated.hashCode ^
        form.hashCode;
  }
}
