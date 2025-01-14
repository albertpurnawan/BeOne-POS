import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/customer.dart';

const String tableCustomer = "tocus";

class CustomerFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    custCode,
    custName,
    tocrgId,
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
    joinDate,
    maxDiscount,
    statusActive,
    activated,
    isEmployee,
    tohemId,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String custCode = "custcode";
  static const String custName = "custname";
  static const String tocrgId = "tocrgId";
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
  static const String joinDate = "joindate";
  static const String maxDiscount = "maxdiscount";
  static const String statusActive = "statusactive";
  static const String activated = "activated";
  static const String isEmployee = "isemployee";
  static const String tohemId = "tohemId";
}

class CustomerModel extends CustomerEntity implements BaseModel {
  CustomerModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.custCode,
    required super.custName,
    required super.tocrgId,
    required super.taxNo,
    required super.phone,
    required super.email,
    required super.toplnId,
    required super.joinDate,
    required super.maxDiscount,
    required super.statusActive,
    required super.activated,
    required super.isEmployee,
    required super.tohemId,
    // ignore: non_constant_identifier_names
    required super.docid_crm,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toLocal().toIso8601String(),
      'updatedate': updateDate?.toLocal().toIso8601String(),
      'custcode': custCode,
      'custname': custName,
      'tocrgId': tocrgId,
      'taxno': taxNo,
      'phone': phone,
      'email': email,
      'toplnId': toplnId,
      'joindate': joinDate?.toLocal().toIso8601String(),
      'maxdiscount': maxDiscount,
      'statusactive': statusActive,
      'activated': activated,
      'isemployee': isEmployee,
      'tohemId': tohemId,
      'docid_crm': docid_crm,
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
        docId: map['docid'] as String,
        createDate: DateTime.parse(map['createdate']).toLocal(),
        updateDate: map['updatedate'] != null
            ? DateTime.parse(map['updatedate']).toLocal()
            : null,
        custCode: map['custcode'] as String,
        custName: map['custname'] as String,
        tocrgId: map['tocrgId'] != null ? map['tocrgId'] as String : null,
        taxNo: map['taxno'] as String,
        phone: map['phone'] as String,
        email: map['email'] as String,
        toplnId: map['toplnId'] != null ? map['toplnId'] as String : null,
        joinDate: map['joindate'] != null
            ? DateTime.parse(map['joindate']).toLocal()
            : null,
        maxDiscount: map['maxdiscount'].toDouble(),
        statusActive: map['statusactive'] as int,
        activated: map['activated'] as int,
        isEmployee: map['isemployee'] as int,
        tohemId: map['tohemId'] != null ? map['tohemId'] as String : null,
        docid_crm:
            map['docid_crm'] != null ? map['docid_crm'] as String : null);
  }

  factory CustomerModel.fromMapRemote(Map<String, dynamic> map) {
    return CustomerModel.fromMap({
      ...map,
      "tocrgId": map['tocrgdocid'] != null ? map['tocrgdocid'] as String : null,
      "toprvId": map['toprvdocid'] != null ? map['toprvdocid'] as String : null,
      "tocryId": map['tocrydocid'] != null ? map['tocrydocid'] as String : null,
      "tozcdId": map['tozcddocid'] != null ? map['tozcddocid'] as String : null,
      "toptrId": map['toptrdocid'] != null ? map['toptrdocid'] as String : null,
      "toplnId": map['toplndocid'] != null ? map['toplndocid'] as String : null,
      "tohemId": map['tohemdocid'] != null ? map['tohemdocid'] as String : null,
    });
  }

  factory CustomerModel.fromEntity(CustomerEntity entity) {
    return CustomerModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      custCode: entity.custCode,
      custName: entity.custName,
      tocrgId: entity.tocrgId,
      taxNo: entity.taxNo,
      phone: entity.phone,
      email: entity.email,
      toplnId: entity.toplnId,
      joinDate: entity.joinDate,
      maxDiscount: entity.maxDiscount,
      statusActive: entity.statusActive,
      activated: entity.activated,
      isEmployee: entity.isEmployee,
      tohemId: entity.tohemId,
      docid_crm: entity.docid_crm,
    );
  }
}
