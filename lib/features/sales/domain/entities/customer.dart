// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CustomerEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String custCode;
  final String custName;
  final String? tocrgId;
  final String idCard;
  final String taxNo;
  final String gender;
  final DateTime birthdate;
  final String addr1;
  final String? addr2;
  final String? addr3;
  final String city;
  final String? toprvId;
  final String? tocryId;
  final String? tozcdId;
  final String phone;
  final String email;
  final String remarks;
  final String? toptrId;
  final String? toplnId;
  final DateTime? joinDate;
  final double maxDiscount;
  final int statusActive;
  final int activated;
  final int isEmployee;
  final String? tohemId;

  CustomerEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.custCode,
    required this.custName,
    required this.tocrgId,
    required this.idCard,
    required this.taxNo,
    required this.gender,
    required this.birthdate,
    required this.addr1,
    required this.addr2,
    required this.addr3,
    required this.city,
    required this.toprvId,
    required this.tocryId,
    required this.tozcdId,
    required this.phone,
    required this.email,
    required this.remarks,
    required this.toptrId,
    required this.toplnId,
    required this.joinDate,
    required this.maxDiscount,
    required this.statusActive,
    required this.activated,
    required this.isEmployee,
    required this.tohemId,
  });

  CustomerEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? custCode,
    String? custName,
    String? tocrgId,
    String? idCard,
    String? taxNo,
    String? gender,
    DateTime? birthdate,
    String? addr1,
    String? addr2,
    String? addr3,
    String? city,
    String? toprvId,
    String? tocryId,
    String? tozcdId,
    String? phone,
    String? email,
    String? remarks,
    String? toptrId,
    String? toplnId,
    DateTime? joinDate,
    double? maxDiscount,
    int? statusActive,
    int? activated,
    int? isEmployee,
    String? tohemId,
  }) {
    return CustomerEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      custCode: custCode ?? this.custCode,
      custName: custName ?? this.custName,
      tocrgId: tocrgId ?? this.tocrgId,
      idCard: idCard ?? this.idCard,
      taxNo: taxNo ?? this.taxNo,
      gender: gender ?? this.gender,
      birthdate: birthdate ?? this.birthdate,
      addr1: addr1 ?? this.addr1,
      addr2: addr2 ?? this.addr2,
      addr3: addr3 ?? this.addr3,
      city: city ?? this.city,
      toprvId: toprvId ?? this.toprvId,
      tocryId: tocryId ?? this.tocryId,
      tozcdId: tozcdId ?? this.tozcdId,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      remarks: remarks ?? this.remarks,
      toptrId: toptrId ?? this.toptrId,
      toplnId: toplnId ?? this.toplnId,
      joinDate: joinDate ?? this.joinDate,
      maxDiscount: maxDiscount ?? this.maxDiscount,
      statusActive: statusActive ?? this.statusActive,
      activated: activated ?? this.activated,
      isEmployee: isEmployee ?? this.isEmployee,
      tohemId: tohemId ?? this.tohemId,
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
      'idCard': idCard,
      'taxNo': taxNo,
      'gender': gender,
      'birthdate': birthdate.millisecondsSinceEpoch,
      'addr1': addr1,
      'addr2': addr2,
      'addr3': addr3,
      'city': city,
      'toprvId': toprvId,
      'tocryId': tocryId,
      'tozcdId': tozcdId,
      'phone': phone,
      'email': email,
      'remarks': remarks,
      'toptrId': toptrId,
      'toplnId': toplnId,
      'joinDate': joinDate?.millisecondsSinceEpoch,
      'maxDiscount': maxDiscount,
      'statusActive': statusActive,
      'activated': activated,
      'isEmployee': isEmployee,
      'tohemId': tohemId,
    };
  }

  factory CustomerEntity.fromMap(Map<String, dynamic> map) {
    return CustomerEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      custCode: map['custCode'] as String,
      custName: map['custName'] as String,
      tocrgId: map['tocrgId'] != null ? map['tocrgId'] as String : null,
      idCard: map['idCard'] as String,
      taxNo: map['taxNo'] as String,
      gender: map['gender'] as String,
      birthdate: DateTime.fromMillisecondsSinceEpoch(map['birthdate'] as int),
      addr1: map['addr1'] as String,
      addr2: map['addr2'] != null ? map['addr2'] as String : null,
      addr3: map['addr3'] != null ? map['addr3'] as String : null,
      city: map['city'] as String,
      toprvId: map['toprvId'] != null ? map['toprvId'] as String : null,
      tocryId: map['tocryId'] != null ? map['tocryId'] as String : null,
      tozcdId: map['tozcdId'] != null ? map['tozcdId'] as String : null,
      phone: map['phone'] as String,
      email: map['email'] as String,
      remarks: map['remarks'] as String,
      toptrId: map['toptrId'] != null ? map['toptrId'] as String : null,
      toplnId: map['toplnId'] != null ? map['toplnId'] as String : null,
      joinDate: map['joinDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['joinDate'] as int)
          : null,
      maxDiscount: map['maxDiscount'] as double,
      statusActive: map['statusActive'] as int,
      activated: map['activated'] as int,
      isEmployee: map['isEmployee'] as int,
      tohemId: map['tohemId'] != null ? map['tohemId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerEntity.fromJson(String source) =>
      CustomerEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CustomerEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, custCode: $custCode, custName: $custName, tocrgId: $tocrgId, idCard: $idCard, taxNo: $taxNo, gender: $gender, birthdate: $birthdate, addr1: $addr1, addr2: $addr2, addr3: $addr3, city: $city, toprvId: $toprvId, tocryId: $tocryId, tozcdId: $tozcdId, phone: $phone, email: $email, remarks: $remarks, toptrId: $toptrId, toplnId: $toplnId, joinDate: $joinDate, maxDiscount: $maxDiscount, statusActive: $statusActive, activated: $activated, isEmployee: $isEmployee, tohemId: $tohemId)';
  }

  @override
  bool operator ==(covariant CustomerEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.custCode == custCode &&
        other.custName == custName &&
        other.tocrgId == tocrgId &&
        other.idCard == idCard &&
        other.taxNo == taxNo &&
        other.gender == gender &&
        other.birthdate == birthdate &&
        other.addr1 == addr1 &&
        other.addr2 == addr2 &&
        other.addr3 == addr3 &&
        other.city == city &&
        other.toprvId == toprvId &&
        other.tocryId == tocryId &&
        other.tozcdId == tozcdId &&
        other.phone == phone &&
        other.email == email &&
        other.remarks == remarks &&
        other.toptrId == toptrId &&
        other.toplnId == toplnId &&
        other.joinDate == joinDate &&
        other.maxDiscount == maxDiscount &&
        other.statusActive == statusActive &&
        other.activated == activated &&
        other.isEmployee == isEmployee &&
        other.tohemId == tohemId;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        custCode.hashCode ^
        custName.hashCode ^
        tocrgId.hashCode ^
        idCard.hashCode ^
        taxNo.hashCode ^
        gender.hashCode ^
        birthdate.hashCode ^
        addr1.hashCode ^
        addr2.hashCode ^
        addr3.hashCode ^
        city.hashCode ^
        toprvId.hashCode ^
        tocryId.hashCode ^
        tozcdId.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        remarks.hashCode ^
        toptrId.hashCode ^
        toplnId.hashCode ^
        joinDate.hashCode ^
        maxDiscount.hashCode ^
        statusActive.hashCode ^
        activated.hashCode ^
        isEmployee.hashCode ^
        tohemId.hashCode;
  }
}
