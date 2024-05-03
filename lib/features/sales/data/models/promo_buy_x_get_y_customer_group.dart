import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_buy_x_get_y_customer_group.dart';

const String tablePromoBuyXGetYCustomerGroup = "tprb5";

class PromoBuyXGetYCustomerGroupFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toprbId,
    tocrgId,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String toprbId = "toprbId";
  static const String tocrgId = "tocrgId";
}

class PromoBuyXGetYCustomerGroupModel extends PromoBuyXGetYCustomerGroupEntity
    implements BaseModel {
  PromoBuyXGetYCustomerGroupModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toprbId,
    required super.tocrgId,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'toprbId': toprbId,
      'tocrgId': tocrgId,
    };
  }

  factory PromoBuyXGetYCustomerGroupModel.fromMap(Map<String, dynamic> map) {
    return PromoBuyXGetYCustomerGroupModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      toprbId: map['toprbId'] != null ? map['toprbId'] as String : null,
      tocrgId: map['tocrgId'] != null ? map['tocrgId'] as String : null,
    );
  }

  factory PromoBuyXGetYCustomerGroupModel.fromMapRemote(
      Map<String, dynamic> map) {
    return PromoBuyXGetYCustomerGroupModel.fromMap({
      ...map,
      "toprbId": map['toprbdocid'] != null ? map['toprbdocid'] as String : null,
      "tocrgId": map['tocrgdocid'] != null ? map['tocrgdocid'] as String : null,
    });
  }

  factory PromoBuyXGetYCustomerGroupModel.fromEntity(
      PromoBuyXGetYCustomerGroupEntity entity) {
    return PromoBuyXGetYCustomerGroupModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toprbId: entity.toprbId,
      tocrgId: entity.tocrgId,
    );
  }
}
