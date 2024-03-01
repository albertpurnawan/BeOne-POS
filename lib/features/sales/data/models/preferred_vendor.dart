import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/preferred_vendor.dart';

const String tablePreferredVendor = "tvitm";

class PreferredVendorFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    tsitmId,
    tovenId,
    listing,
    minOrder,
    multipyOrder,
    canOrder,
    dflt,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String tsitmId = "tsitmId";
  static const String tovenId = "tovenId";
  static const String listing = "listing";
  static const String minOrder = "minorder";
  static const String multipyOrder = "multiplyorder";
  static const String canOrder = "canorder";
  static const String dflt = "dflt";
}

class PreferredVendorModel extends PreferredVendorEntity implements BaseModel {
  PreferredVendorModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.tsitmId,
    required super.tovenId,
    required super.listing,
    required super.minOrder,
    required super.multipyOrder,
    required super.canOrder,
    required super.dflt,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toLocal().toIso8601String(),
      'updatedate': updateDate?.toLocal().toIso8601String(),
      'tsitmId': tsitmId,
      'tovenId': tovenId,
      'listing': listing,
      'minorder': minOrder,
      'multipyorder': multipyOrder,
      'canorder': canOrder,
      'dflt': dflt,
    };
  }

  factory PreferredVendorModel.fromMapRemote(Map<String, dynamic> map) {
    return PreferredVendorModel.fromMap({
      ...map,
      "tsitmId": map['tsitm_id']["docid"] != null
          ? map['tsitm_id']["docid"] as String
          : null,
      "tovenId": map['toven_id']["docid"] != null
          ? map['toven_id']["docid"] as String
          : null,
      "minorder": map['minorder'].toDouble() as double,
      "multipyorder": map['multipyorder'].toDouble() as double,
    });
  }

  factory PreferredVendorModel.fromMap(Map<String, dynamic> map) {
    return PreferredVendorModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate']).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate']).toLocal()
          : null,
      tsitmId: map['tsitmId'] != null ? map['tsitmId'] as String : null,
      tovenId: map['tovenId'] != null ? map['tovenId'] as String : null,
      listing: map['listing'] as int,
      minOrder: map['minorder'] as double,
      multipyOrder: map['multipyorder'] as double,
      canOrder: map['canorder'] as int,
      dflt: map['dflt'] as int,
    );
  }

  factory PreferredVendorModel.fromEntity(PreferredVendorEntity entity) {
    return PreferredVendorModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      tsitmId: entity.tsitmId,
      tovenId: entity.tovenId,
      listing: entity.listing,
      minOrder: entity.minOrder,
      multipyOrder: entity.multipyOrder,
      canOrder: entity.canOrder,
      dflt: entity.dflt,
    );
  }
}
