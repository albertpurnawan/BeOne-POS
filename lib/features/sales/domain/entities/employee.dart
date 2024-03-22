// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class EmployeeEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String empCode;
  final String empName;
  final String email;
  final String phone;
  final String addr1;
  final String? addr2;
  final String? addr3;
  final String city;
  final String? remarks;
  final String? toprvId;
  final String? tocryId;
  final String? tozcdId;
  final String idCard;
  final String gender;
  final DateTime birthdate;
  final dynamic photo;
  final DateTime joinDate;
  final DateTime? resignDate;
  final int statusActive;
  final int activated;
  final String empDept;
  final String empTitle;
  final String empWorkplace;
  final double empDebt;

  EmployeeEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.empCode,
    required this.empName,
    required this.email,
    required this.phone,
    required this.addr1,
    required this.addr2,
    required this.addr3,
    required this.city,
    required this.remarks,
    required this.toprvId,
    required this.tocryId,
    required this.tozcdId,
    required this.idCard,
    required this.gender,
    required this.birthdate,
    required this.photo,
    required this.joinDate,
    required this.resignDate,
    required this.statusActive,
    required this.activated,
    required this.empDept,
    required this.empTitle,
    required this.empWorkplace,
    required this.empDebt,
  });

  EmployeeEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? empCode,
    String? empName,
    String? email,
    String? phone,
    String? addr1,
    String? addr2,
    String? addr3,
    String? city,
    String? remarks,
    String? toprvId,
    String? tocryId,
    String? tozcdId,
    String? idCard,
    String? gender,
    DateTime? birthdate,
    dynamic photo,
    DateTime? joinDate,
    DateTime? resignDate,
    int? statusActive,
    int? activated,
    String? empDept,
    String? empTitle,
    String? empWorkplace,
    double? empDebt,
  }) {
    return EmployeeEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      empCode: empCode ?? this.empCode,
      empName: empName ?? this.empName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      addr1: addr1 ?? this.addr1,
      addr2: addr2 ?? this.addr2,
      addr3: addr3 ?? this.addr3,
      city: city ?? this.city,
      remarks: remarks ?? this.remarks,
      toprvId: toprvId ?? this.toprvId,
      tocryId: tocryId ?? this.tocryId,
      tozcdId: tozcdId ?? this.tozcdId,
      idCard: idCard ?? this.idCard,
      gender: gender ?? this.gender,
      birthdate: birthdate ?? this.birthdate,
      photo: photo ?? this.photo,
      joinDate: joinDate ?? this.joinDate,
      resignDate: resignDate ?? this.resignDate,
      statusActive: statusActive ?? this.statusActive,
      activated: activated ?? this.activated,
      empDept: empDept ?? this.empDept,
      empTitle: empTitle ?? this.empTitle,
      empWorkplace: empWorkplace ?? this.empWorkplace,
      empDebt: empDebt ?? this.empDebt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'empCode': empCode,
      'empName': empName,
      'email': email,
      'phone': phone,
      'addr1': addr1,
      'addr2': addr2,
      'addr3': addr3,
      'city': city,
      'remarks': remarks,
      'toprvId': toprvId,
      'tocryId': tocryId,
      'tozcdId': tozcdId,
      'idCard': idCard,
      'gender': gender,
      'birthdate': birthdate.millisecondsSinceEpoch,
      'photo': photo,
      'joinDate': joinDate.millisecondsSinceEpoch,
      'resignDate': resignDate?.millisecondsSinceEpoch,
      'statusActive': statusActive,
      'activated': activated,
      'empDept': empDept,
      'empTitle': empTitle,
      'empWorkplace': empWorkplace,
      'empDebt': empDebt,
    };
  }

  factory EmployeeEntity.fromMap(Map<String, dynamic> map) {
    return EmployeeEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      empCode: map['empCode'] as String,
      empName: map['empName'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      addr1: map['addr1'] as String,
      addr2: map['addr2'] != null ? map['addr2'] as String : null,
      addr3: map['addr3'] != null ? map['addr3'] as String : null,
      city: map['city'] as String,
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
      toprvId: map['toprvId'] != null ? map['toprvId'] as String : null,
      tocryId: map['tocryId'] != null ? map['tocryId'] as String : null,
      tozcdId: map['tozcdId'] != null ? map['tozcdId'] as String : null,
      idCard: map['idCard'] as String,
      gender: map['gender'] as String,
      birthdate: DateTime.fromMillisecondsSinceEpoch(map['birthdate'] as int),
      photo: map['photo'] != null ? map['photo'] as dynamic : null,
      joinDate: DateTime.fromMillisecondsSinceEpoch(map['joinDate'] as int),
      resignDate: map['resignDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['resignDate'] as int)
          : null,
      statusActive: map['statusActive'] as int,
      activated: map['activated'] as int,
      empDept: map['empDept'] as String,
      empTitle: map['empTitle'] as String,
      empWorkplace: map['empWorkplace'] as String,
      empDebt: map['empDebt'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory EmployeeEntity.fromJson(String source) =>
      EmployeeEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EmployeeEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, empCode: $empCode, empName: $empName, email: $email, phone: $phone, addr1: $addr1, addr2: $addr2, addr3: $addr3, city: $city, remarks: $remarks, toprvId: $toprvId, tocryId: $tocryId, tozcdId: $tozcdId, idCard: $idCard, gender: $gender, birthdate: $birthdate, photo: $photo, joinDate: $joinDate, resignDate: $resignDate, statusActive: $statusActive, activated: $activated, empDept: $empDept, empTitle: $empTitle, empWorkplace: $empWorkplace, empDebt: $empDebt)';
  }

  @override
  bool operator ==(covariant EmployeeEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.empCode == empCode &&
        other.empName == empName &&
        other.email == email &&
        other.phone == phone &&
        other.addr1 == addr1 &&
        other.addr2 == addr2 &&
        other.addr3 == addr3 &&
        other.city == city &&
        other.remarks == remarks &&
        other.toprvId == toprvId &&
        other.tocryId == tocryId &&
        other.tozcdId == tozcdId &&
        other.idCard == idCard &&
        other.gender == gender &&
        other.birthdate == birthdate &&
        other.photo == photo &&
        other.joinDate == joinDate &&
        other.resignDate == resignDate &&
        other.statusActive == statusActive &&
        other.activated == activated &&
        other.empDept == empDept &&
        other.empTitle == empTitle &&
        other.empWorkplace == empWorkplace &&
        other.empDebt == empDebt;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        empCode.hashCode ^
        empName.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        addr1.hashCode ^
        addr2.hashCode ^
        addr3.hashCode ^
        city.hashCode ^
        remarks.hashCode ^
        toprvId.hashCode ^
        tocryId.hashCode ^
        tozcdId.hashCode ^
        idCard.hashCode ^
        gender.hashCode ^
        birthdate.hashCode ^
        photo.hashCode ^
        joinDate.hashCode ^
        resignDate.hashCode ^
        statusActive.hashCode ^
        activated.hashCode ^
        empDept.hashCode ^
        empTitle.hashCode ^
        empWorkplace.hashCode ^
        empDebt.hashCode;
  }
}
