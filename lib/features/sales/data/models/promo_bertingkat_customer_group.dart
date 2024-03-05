import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_bertingkat_customer_group.dart';

const String tablePromoBertingkatCustomerGroup = "tprp4";

class PromoBertingkatCustomerGroupFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toprpId,
    tocrgId,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String toprpId = "toprpId";
  static const String tocrgId = "tocrgId";
}

class PromoBertingkatCustomerGroupModel
    extends PromoBertingkatCustomerGroupEntity implements BaseModel {
  PromoBertingkatCustomerGroupModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toprpId,
    required super.tocrgId,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'toprpId': toprpId,
      'tocrgId': tocrgId,
    };
  }

  factory PromoBertingkatCustomerGroupModel.fromMap(Map<String, dynamic> map) {
    return PromoBertingkatCustomerGroupModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      toprpId: map['toprpId'] != null ? map['toprpId'] as String : null,
      tocrgId: map['tocrgId'] != null ? map['tocrgId'] as String : null,
    );
  }

  factory PromoBertingkatCustomerGroupModel.fromMapRemote(
      Map<String, dynamic> map) {
    return PromoBertingkatCustomerGroupModel.fromMap({
      ...map,
      "toprpId": map['toprp_id']?['docid'] != null
          ? map['toprp_id']['docid'] as String
          : null,
      "tocrgId": map['tocrg_id']?['docid'] != null
          ? map['tocrg_id']['docid'] as String
          : null,
    });
  }

  factory PromoBertingkatCustomerGroupModel.fromEntity(
      PromoBertingkatCustomerGroupEntity entity) {
    return PromoBertingkatCustomerGroupModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toprpId: entity.toprpId,
      tocrgId: entity.tocrgId,
    );
  }
}
