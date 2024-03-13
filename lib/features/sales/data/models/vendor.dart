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
      'docId': docId,
      'createDate': createDate.toUtc().toIso8601String(),
      'updateDate': updateDate?.toUtc().toIso8601String(),
      'vendCode': vendCode,
      'vendName': vendName,
      'tovdgId': tovdgId,
      'idCard': idCard,
      'taxNo': taxNo,
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
      'maxDiscount': maxDiscount,
      'statusActive': statusActive,
      'activated': activated,
      'tohemId': tohemId,
      'sync': sync,
    };
  }

  factory VendorModel.fromMap(Map<String, dynamic> map) {
    return VendorModel(
      docId: map['docId'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updateDate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      vendCode: map['vendCode'] as String,
      vendName: map['vendName'] as String,
      tovdgId: map['tovdgId'] != null ? map['tovdgId'] as String : null,
      idCard: map['idCard'] as String,
      taxNo: map['taxNo'] as String,
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
      maxDiscount: map['maxDiscount'] as double,
      statusActive: map['statusActive'] as int,
      activated: map['activated'] as int,
      tohemId: map['tohemId'] != null ? map['tohemId'] as String : null,
      sync: map['sync'] as int,
    );
  }
}
