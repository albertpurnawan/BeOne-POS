import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_credit_card_customer_group.dart';

const String tablePromoCreditCardCustomerGroup = "tprc4";

class PromoCreditCardCustomerGroupFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toprcId,
    tocrgId,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedae";
  static const String toprcId = "toprcId";
  static const String tocrgId = "tocrgId";
}

class PromoCreditCardCustomerGroupModel
    extends PromoCreditCardCustomerGroupEntity implements BaseModel {
  PromoCreditCardCustomerGroupModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toprcId,
    required super.tocrgId,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'toprcId': toprcId,
      'tocrgId': tocrgId,
    };
  }

  factory PromoCreditCardCustomerGroupModel.fromMap(Map<String, dynamic> map) {
    return PromoCreditCardCustomerGroupModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      toprcId: map['toprcId'] != null ? map['toprcId'] as String : null,
      tocrgId: map['tocrgId'] != null ? map['tocrgId'] as String : null,
    );
  }

  factory PromoCreditCardCustomerGroupModel.fromMapRemote(
      Map<String, dynamic> map) {
    return PromoCreditCardCustomerGroupModel.fromMap({
      ...map,
      "toprcId": map['toprc_id']?['docid'] != null
          ? map['toprc_id']['docid'] as String
          : null,
      "tocrgId": map['tocrg_id']?['docid'] != null
          ? map['tocrg_id']['docid'] as String
          : null,
    });
  }

  factory PromoCreditCardCustomerGroupModel.fromEntity(
      PromoCreditCardCustomerGroupEntity entity) {
    return PromoCreditCardCustomerGroupModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toprcId: entity.toprcId,
      tocrgId: entity.tocrgId,
    );
  }
}
