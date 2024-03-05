import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/customer_contact_person.dart';

const String tableCustomerContactPerson = "tcus2";

class CustomerContactPersonFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    tocusId,
    linenum,
    title,
    fullname,
    phone,
    email,
    position,
    idcard,
    taxno,
    gender,
    birthdate,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String tocusId = "tocusId";
  static const String linenum = "linenum";
  static const String title = "title";
  static const String fullname = "fullname";
  static const String phone = "phone";
  static const String email = "email";
  static const String position = "position";
  static const String idcard = "idcard";
  static const String taxno = "taxno";
  static const String gender = "gender";
  static const String birthdate = "birthdate";
}

class CustomerContactPersonModel extends CustomerContactPersonEntity
    implements BaseModel {
  CustomerContactPersonModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.tocusId,
    required super.linenum,
    required super.title,
    required super.fullname,
    required super.phone,
    required super.email,
    required super.position,
    required super.idcard,
    required super.taxno,
    required super.gender,
    required super.birthdate,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toLocal().toIso8601String(),
      'updatedate': updateDate?.toLocal().toIso8601String(),
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
      'birthdate': birthdate.toLocal().toIso8601String(),
    };
  }

  factory CustomerContactPersonModel.fromMap(Map<String, dynamic> map) {
    return CustomerContactPersonModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate']).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate']).toLocal()
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
      birthdate: DateTime.parse(map['updatedate']).toLocal(),
    );
  }

  factory CustomerContactPersonModel.fromMapRemote(Map<String, dynamic> map) {
    return CustomerContactPersonModel.fromMap({
      ...map,
      "tocusId": map['tocus_id']['docid'] != null
          ? map['tocus_id']['docid'] as String
          : null,
    });
  }

  factory CustomerContactPersonModel.fromEntity(
      CustomerContactPersonEntity entity) {
    return CustomerContactPersonModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      tocusId: entity.tocusId,
      linenum: entity.linenum,
      title: entity.title,
      fullname: entity.fullname,
      phone: entity.phone,
      email: entity.email,
      position: entity.position,
      idcard: entity.idcard,
      taxno: entity.taxno,
      gender: entity.gender,
      birthdate: entity.birthdate,
    );
  }
}
