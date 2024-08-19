import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_coupon_customer_group.dart';

const String tablePromoCouponCustomerGroup = "tprn4";

class PromoCouponCustomerGroupFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toprnId,
    tocrgId,
    form,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String toprnId = "toprnId";
  static const String tocrgId = "tocrgId";
  static const String form = "form";
}

class PromoCouponCustomerGroupModel extends PromoCouponCustomerGroupEntity implements BaseModel {
  PromoCouponCustomerGroupModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toprnId,
    required super.tocrgId,
    required super.form,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'toprnId': toprnId,
      'tocrgId': tocrgId,
      'form': form,
    };
  }

  factory PromoCouponCustomerGroupModel.fromMap(Map<String, dynamic> map) {
    return PromoCouponCustomerGroupModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null ? DateTime.parse(map['updatedate'] as String).toLocal() : null,
      toprnId: map['toprnId'] != null ? map['toprnId'] as String : null,
      tocrgId: map['tocrgId'] != null ? map['tocrgId'] as String : null,
      form: map['form'] as String,
    );
  }

  factory PromoCouponCustomerGroupModel.fromMapRemote(Map<String, dynamic> map) {
    return PromoCouponCustomerGroupModel.fromMap({
      ...map,
      'toprnId': map['toprndocid'] != null ? map['toprndocid'] as String : null,
      'tocrgId': map['tocrgdocid'] != null ? map['tocrgdocid'] as String : null,
    });
  }

  factory PromoCouponCustomerGroupModel.fromEntity(PromoCouponCustomerGroupEntity entity) {
    return PromoCouponCustomerGroupModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toprnId: entity.toprnId,
      tocrgId: entity.tocrgId,
      form: entity.form,
    );
  }
}
