import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/customer_address.dart';

const String tableCustomerAddress = "tcus1";

class CustomerAddressFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    tocusId,
    linenum,
    addr1,
    addr2,
    addr3,
    city,
    toprvId,
    tocryId,
    tozcdId,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String tocusId = "updatedate";
  static const String linenum = "linenum";
  static const String addr1 = "addr1";
  static const String addr2 = "addr2";
  static const String addr3 = "addr3";
  static const String city = "city";
  static const String toprvId = "toprvId";
  static const String tocryId = "tocryId";
  static const String tozcdId = "tozcdId";
}

class CustomerAddressModel extends CustomerAddressEntity implements BaseModel {
  CustomerAddressModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.tocusId,
    required super.linenum,
    required super.addr1,
    required super.addr2,
    required super.addr3,
    required super.city,
    required super.toprvId,
    required super.tocryId,
    required super.tozcdId,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.millisecondsSinceEpoch,
      'updatedate': updateDate?.millisecondsSinceEpoch,
      'tocusId': tocusId,
      'linenum': linenum,
      'addr1': addr1,
      'addr2': addr2,
      'addr3': addr3,
      'city': city,
      'toprvId': toprvId,
      'tocryId': tocryId,
      'tozcdId': tozcdId,
    };
  }

  factory CustomerAddressModel.fromMap(Map<String, dynamic> map) {
    return CustomerAddressModel(
      docId: map['docid'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createdate'] as int),
      updateDate: map['updatedate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      tocusId: map['tocusId'] != null ? map['tocusId'] as String : null,
      linenum: map['linenum'] as int,
      addr1: map['addr1'] as String,
      addr2: map['addr2'] != null ? map['addr2'] as String : null,
      addr3: map['addr3'] != null ? map['addr3'] as String : null,
      city: map['city'] as String,
      toprvId: map['toprvId'] != null ? map['toprvId'] as String : null,
      tocryId: map['tocryId'] != null ? map['tocryId'] as String : null,
      tozcdId: map['tozcdId'] != null ? map['tozcdId'] as String : null,
    );
  }

  factory CustomerAddressModel.fromMapRemote(Map<String, dynamic> map) {
    return CustomerAddressModel.fromMap({
      ...map,
      "tocusId": map['tocus_id']['docid'] != null
          ? map['tocus_id']['docid'] as String
          : null,
      "toprvId": map['toprv_id']['docid'] != null
          ? map['toprv_id']['docid'] as String
          : null,
      "tocryId": map['tocry_id']['docid'] != null
          ? map['tocry_id']['docid'] as String
          : null,
      "tozcdId": map['tozcd_id']['docid'] != null
          ? map['tozcd_id']['docid'] as String
          : null,
    });
  }

  factory CustomerAddressModel.fromEntity(CustomerAddressEntity entity) {
    return CustomerAddressModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      tocusId: entity.tocusId,
      linenum: entity.linenum,
      addr1: entity.addr1,
      addr2: entity.addr2,
      addr3: entity.addr3,
      city: entity.city,
      toprvId: entity.toprvId,
      tocryId: entity.tocryId,
      tozcdId: entity.tozcdId,
    );
  }
}
