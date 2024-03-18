import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/vendor.dart';

const String tableVendor = "toven";

class VendorFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    vendCode,
    vendName,
    tovdgId,
    idCard,
    taxNo,
    gender,
    birthdate,
    addr1,
    addr2,
    addr3,
    city,
    toprvId,
    tocryId,
    tozcdId,
    phone,
    email,
    remarks,
    toptrId,
    toplnId,
    maxDiscount,
    statusActive,
    activated,
    tohemId,
    sync,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String vendCode = "vencode";
  static const String vendName = "vendname";
  static const String tovdgId = "tovdgId";
  static const String idCard = "idcard";
  static const String taxNo = "taxno";
  static const String gender = "gender";
  static const String birthdate = "birthdate";
  static const String addr1 = "addr1";
  static const String addr2 = "addr2";
  static const String addr3 = "addr3";
  static const String city = "city";
  static const String toprvId = "toprvId";
  static const String tocryId = "tocryId";
  static const String tozcdId = "tozcdId";
  static const String phone = "phone";
  static const String email = "email";
  static const String remarks = "remarks";
  static const String toptrId = "toptrId";
  static const String toplnId = "toplnId";
  static const String maxDiscount = "maxdiscount";
  static const String statusActive = "statucactive";
  static const String activated = "activated";
  static const String tohemId = "tohemId";
  static const String sync = "sync";
}

class VendorModel extends VendorEntity implements BaseModel {
  VendorModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.vendCode,
    required super.vendName,
    required super.tovdgId,
    required super.idCard,
    required super.taxNo,
    required super.gender,
    required super.birthdate,
    required super.addr1,
    required super.addr2,
    required super.addr3,
    required super.city,
    required super.toprvId,
    required super.tocryId,
    required super.tozcdId,
    required super.phone,
    required super.email,
    required super.remarks,
    required super.toptrId,
    required super.toplnId,
    required super.maxDiscount,
    required super.statusActive,
    required super.activated,
    required super.tohemId,
    required super.sync,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'vendcode': vendCode,
      'vendname': vendName,
      'tovdgId': tovdgId,
      'idcard': idCard,
      'taxno': taxNo,
      'gender': gender,
      'birthdate': birthdate?.toUtc().toIso8601String(),
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
      'maxdiscount': maxDiscount,
      'statusactive': statusActive,
      'activated': activated,
      'tohemId': tohemId,
      'sync': sync,
    };
  }

  factory VendorModel.fromMap(Map<String, dynamic> map) {
    return VendorModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      vendCode: map['vendcode'] as String,
      vendName: map['vendname'] as String,
      tovdgId: map['tovdgId'] != null ? map['tovdgId'] as String : null,
      idCard: map['idcard'] as String,
      taxNo: map['taxno'] as String,
      gender: map['gender'] as String,
      birthdate: map['birthdate'] != null
          ? DateTime.parse(map['birthdate'] as String).toLocal()
          : null,
      addr1: map['addr1'] as String,
      addr2: map['addr2'] != null ? map['addr2'] as String : null,
      addr3: map['addr3'] != null ? map['addr3'] as String : null,
      city: map['city'] as String,
      toprvId: map['toprvId'] != null ? map['toprvId'] as String : null,
      tocryId: map['tocryId'] != null ? map['tocryId'] as String : null,
      tozcdId: map['tozcdId'] != null ? map['tozcdId'] as String : null,
      phone: map['phone'] as String,
      email: map['email'] as String,
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
      toptrId: map['toptrId'] != null ? map['toptrId'] as String : null,
      toplnId: map['toplnId'] != null ? map['toplnId'] as String : null,
      maxDiscount: map['maxdiscount'] as double,
      statusActive: map['statusactive'] as int,
      activated: map['activated'] as int,
      tohemId: map['tohemId'] != null ? map['tohemId'] as String : null,
      sync: map['sync'] as int,
    );
  }

  factory VendorModel.fromMapRemote(Map<String, dynamic> map) {
    return VendorModel.fromMap({
      ...map,
      "tovdgId": map['tovdgdocid'] != null ? map['tovdgdocid'] as String : null,
      "toprvId": map['toprvdocid'] != null ? map['toprvdocid'] as String : null,
      "tocryId": map['tocrydocid'] != null ? map['tocrydocid'] as String : null,
      "tozcdId": map['tozcddocid'] != null ? map['tozcddocid'] as String : null,
      "tohemId": map['tohemdocid'] != null ? map['tohemdocid'] as String : null,
      "maxdiscount": map['maxdiscount'].toDouble() as double,
    });
  }

  factory VendorModel.fromEntity(VendorEntity entity) {
    return VendorModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      vendCode: entity.vendCode,
      vendName: entity.vendName,
      tovdgId: entity.tovdgId,
      idCard: entity.idCard,
      taxNo: entity.taxNo,
      gender: entity.gender,
      birthdate: entity.birthdate,
      addr1: entity.addr1,
      addr2: entity.addr2,
      addr3: entity.addr3,
      city: entity.city,
      toprvId: entity.toprvId,
      tocryId: entity.tocryId,
      tozcdId: entity.tozcdId,
      phone: entity.phone,
      email: entity.email,
      remarks: entity.remarks,
      toptrId: entity.toptrId,
      toplnId: entity.toplnId,
      maxDiscount: entity.maxDiscount,
      statusActive: entity.statusActive,
      activated: entity.activated,
      tohemId: entity.tohemId,
      sync: entity.sync,
    );
  }
}
