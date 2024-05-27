import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/customer_cst.dart';

const tableCustomerCst = "tocus";

class CustomerCstFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    custCode,
    custName,
    tocrgId,
    phone,
    email,
    taxNo,
    maxDiscount,
    toplnId,
    joinDate,
    isEmployee,
    tohemId,
    docid_crm,
    statusActive,
    activated,
    form,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String custCode = "custcode";
  static const String custName = "custname";
  static const String tocrgId = "tocrgId";
  static const String phone = "phone";
  static const String email = "email";
  static const String taxNo = "taxno";
  static const String maxDiscount = "maxdiscount";
  static const String toplnId = "toplnId";
  static const String joinDate = "joindate";
  static const String isEmployee = "isemployee";
  static const String tohemId = "tohemId";
  static const String docid_crm = "docid_crm";
  static const String statusActive = "statusactive";
  static const String activated = "activated";
  static const String form = "form";
}

class CustomerCstModel extends CustomerCstEntity implements BaseModel {
  CustomerCstModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.custCode,
    required super.custName,
    required super.tocrgId,
    required super.phone,
    required super.email,
    required super.taxNo,
    required super.maxDiscount,
    required super.toplnId,
    required super.joinDate,
    required super.isEmployee,
    required super.tohemId,
    required super.docid_crm,
    required super.statusActive,
    required super.activated,
    required super.form,
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
      'phone': phone,
      'email': email,
      'taxno': taxNo,
      'maxdiscount': maxDiscount,
      'toplnId': toplnId,
      'joindate': joinDate?.toLocal().toIso8601String(),
      'isemployee': isEmployee,
      'tohemId': tohemId,
      'docid_crm': docid_crm,
      'statusactive': statusActive,
      'activated': activated,
      'form': form,
    };
  }

  factory CustomerCstModel.fromMap(Map<String, dynamic> map) {
    return CustomerCstModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate']).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate']).toLocal()
          : null,
      custCode: map['custcode'] as String,
      custName: map['custname'] as String,
      tocrgId: map['tocrgId'] != null ? map['tocrgId'] as String : null,
      phone: map['phone'] as String,
      email: map['email'] as String,
      taxNo: map['taxno'] as String,
      maxDiscount: map['maxdiscount'] as double,
      toplnId: map['toplnId'] != null ? map['toplnId'] as String : null,
      joinDate: map['joindate'] != null
          ? DateTime.parse(map['joindate']).toLocal()
          : null,
      isEmployee: map['isemployee'] as int,
      tohemId: map['tohemId'] != null ? map['tohemId'] as String : null,
      docid_crm: map['docid_crm'] != null ? map['docid_crm'] as String : null,
      statusActive: map['statusactive'] as int,
      activated: map['activated'] as int,
      form: map['form'] as String,
    );
  }

  factory CustomerCstModel.fromMapRemote(Map<String, dynamic> map) {
    return CustomerCstModel.fromMap({
      ...map,
      "tocrgId": map['tocrgdocid'] != null ? map['tocrgdocid'] as String : null,
      "toplnId": map['toplndocid'] != null ? map['toplndocid'] as String : null,
      "tohemId": map['tohemdocid'] != null ? map['tohemdocid'] as String : null,
      "maxdiscount": map['maxdiscount'].toDouble() as double,
    });
  }

  factory CustomerCstModel.fromEntity(CustomerCstEntity entity) {
    return CustomerCstModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      custCode: entity.custCode,
      custName: entity.custName,
      tocrgId: entity.tocrgId,
      phone: entity.phone,
      email: entity.email,
      taxNo: entity.taxNo,
      maxDiscount: entity.maxDiscount,
      toplnId: entity.toplnId,
      joinDate: entity.joinDate,
      isEmployee: entity.isEmployee,
      tohemId: entity.tohemId,
      docid_crm: entity.docid_crm,
      statusActive: entity.statusActive,
      activated: entity.activated,
      form: entity.form,
    );
  }
}
