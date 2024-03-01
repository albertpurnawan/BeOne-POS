// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CustomerContactPersonEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? tocusId;
  final int linenum;
  final String title;
  final String fullname;
  final String phone;
  final String email;
  final String position;
  final String idcard;
  final String taxno;
  final String gender;
  final DateTime birthdate;

  CustomerContactPersonEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.tocusId,
    required this.linenum,
    required this.title,
    required this.fullname,
    required this.phone,
    required this.email,
    required this.position,
    required this.idcard,
    required this.taxno,
    required this.gender,
    required this.birthdate,
  });

  CustomerContactPersonEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? tocusId,
    int? linenum,
    String? title,
    String? fullname,
    String? phone,
    String? email,
    String? position,
    String? idcard,
    String? taxno,
    String? gender,
    DateTime? birthdate,
  }) {
    return CustomerContactPersonEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      tocusId: tocusId ?? this.tocusId,
      linenum: linenum ?? this.linenum,
      title: title ?? this.title,
      fullname: fullname ?? this.fullname,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      position: position ?? this.position,
      idcard: idcard ?? this.idcard,
      taxno: taxno ?? this.taxno,
      gender: gender ?? this.gender,
      birthdate: birthdate ?? this.birthdate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'tocusId': tocusId,
      'linenum': linenum,
      'title': title,
      'fullname': fullname,
      'phone': phone,
      'email': email,
      'position': position,
      'idcard': idcard,
      'taxno': taxno,
      'gender': gender,
      'birthdate': birthdate.millisecondsSinceEpoch,
    };
  }

  factory CustomerContactPersonEntity.fromMap(Map<String, dynamic> map) {
    return CustomerContactPersonEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      tocusId: map['tocusId'] != null ? map['tocusId'] as String : null,
      linenum: map['linenum'] as int,
      title: map['title'] as String,
      fullname: map['fullname'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      position: map['position'] as String,
      idcard: map['idcard'] as String,
      taxno: map['taxno'] as String,
      gender: map['gender'] as String,
      birthdate: DateTime.fromMillisecondsSinceEpoch(map['birthdate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerContactPersonEntity.fromJson(String source) =>
      CustomerContactPersonEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CustomerContactPersonEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, tocusId: $tocusId, linenum: $linenum, title: $title, fullname: $fullname, phone: $phone, email: $email, position: $position, idcard: $idcard, taxno: $taxno, gender: $gender, birthdate: $birthdate)';
  }

  @override
  bool operator ==(covariant CustomerContactPersonEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.tocusId == tocusId &&
        other.linenum == linenum &&
        other.title == title &&
        other.fullname == fullname &&
        other.phone == phone &&
        other.email == email &&
        other.position == position &&
        other.idcard == idcard &&
        other.taxno == taxno &&
        other.gender == gender &&
        other.birthdate == birthdate;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        tocusId.hashCode ^
        linenum.hashCode ^
        title.hashCode ^
        fullname.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        position.hashCode ^
        idcard.hashCode ^
        taxno.hashCode ^
        gender.hashCode ^
        birthdate.hashCode;
  }
}
