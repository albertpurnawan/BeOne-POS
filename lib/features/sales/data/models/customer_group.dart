import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/customer_group.dart';

const String tableCustomerGroup = "tocrg";

class CustomerGroupFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    custgroupCode,
    description,
    maxDiscount,
    statusActive,
    activated,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String custgroupCode = "custgroupcode";
  static const String description = "description";
  static const String maxDiscount = "maxdiscount";
  static const String statusActive = "statusactive";
  static const String activated = "activated";
}

class CustomerGroupModel extends CustomerGroupEntity implements BaseModel {
  CustomerGroupModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.custgroupCode,
    required super.description,
    required super.maxDiscount,
    required super.statusActive,
    required super.activated,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toLocal().toIso8601String(),
      'updatedate': updateDate?.toLocal().toIso8601String(),
      'custgroupcode': custgroupCode,
      'description': description,
      'maxdiscount': maxDiscount,
      'statusactive': statusActive,
      'activated': activated,
    };
  }

  factory CustomerGroupModel.fromMap(Map<String, dynamic> map) {
    return CustomerGroupModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate']).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate']).toLocal()
          : null,
      custgroupCode: map['custgroupcode'] as String,
      description: map['description'] as String,
      maxDiscount: map['maxdiscount'].toDouble(),
      statusActive: map['statusactive'] as int,
      activated: map['activated'] as int,
    );
  }

  factory CustomerGroupModel.fromMapRemote(Map<String, dynamic> map) {
    return CustomerGroupModel.fromMap({
      ...map,
      "maxdiscount": map['maxdiscount'].toDouble() as double,
    });
  }

  factory CustomerGroupModel.fromEntity(CustomerGroupEntity entity) {
    return CustomerGroupModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      custgroupCode: entity.custgroupCode,
      description: entity.description,
      maxDiscount: entity.maxDiscount,
      statusActive: entity.statusActive,
      activated: entity.activated,
    );
  }
}
