import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_credit_card_detail.dart';

const String tablePromoCreditCardDetail = "tprc1";

class PromoCreditCardDetailFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toprcId,
    tpmt2Id,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String toprcId = "toprcId";
  static const String tpmt2Id = "tpmt2Id";
}

class PromoCreditCardDetailModel extends PromoCreditCardDetailEntity
    implements BaseModel {
  PromoCreditCardDetailModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toprcId,
    required super.tpmt2Id,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'toprcId': toprcId,
      'tpmt2Id': tpmt2Id,
    };
  }

  factory PromoCreditCardDetailModel.fromMap(Map<String, dynamic> map) {
    return PromoCreditCardDetailModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      toprcId: map['toprcId'] != null ? map['toprcId'] as String : null,
      tpmt2Id: map['tpmt2Id'] != null ? map['tpmt2Id'] as String : null,
    );
  }

  factory PromoCreditCardDetailModel.fromMapRemote(Map<String, dynamic> map) {
    return PromoCreditCardDetailModel.fromMap({
      ...map,
      "toprcId": map['toprc_id']?['docid'] != null
          ? map['toprc_id']['docid'] as String
          : null,
      "tpmt2Id": map['tpmt2_id']?['docid'] != null
          ? map['tpmt2_id']['docid'] as String
          : null,
    });
  }

  factory PromoCreditCardDetailModel.fromEntity(
      PromoCreditCardDetailEntity entity) {
    return PromoCreditCardDetailModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toprcId: entity.toprcId,
      tpmt2Id: entity.tpmt2Id,
    );
  }
}
