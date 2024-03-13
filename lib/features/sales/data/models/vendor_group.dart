import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/vendor_group.dart';

const String tableVendorGroup = "tovdg";

class VendorGroupFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    vendorGroupCode,
    description,
    maxDiscount,
    statusActive,
    activated,
    sync,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String vendorGroupCode = "vendorgroupcode";
  static const String description = "description";
  static const String maxDiscount = "maxdiscount";
  static const String statusActive = "statusactive";
  static const String activated = "activated";
  static const String sync = "sync";
}

class VendorGroupModel extends VendorGroupEntity implements BaseModel {
  VendorGroupModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.vendorGroupCode,
    required super.description,
    required super.maxDiscount,
    required super.statusActive,
    required super.activated,
    required super.sync,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'vendorgroupcode': vendorGroupCode,
      'description': description,
      'maxdiscount': maxDiscount,
      'statusactive': statusActive,
      'activated': activated,
      'sync': sync,
    };
  }

  factory VendorGroupModel.fromMap(Map<String, dynamic> map) {
    return VendorGroupModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      vendorGroupCode: map['vendorgroupcode'] as String,
      description: map['description'] as String,
      maxDiscount: map['maxdiscount'] as double,
      statusActive: map['statusactive'] as int,
      activated: map['activated'] as int,
      sync: map['sync'] as int,
    );
  }
}
