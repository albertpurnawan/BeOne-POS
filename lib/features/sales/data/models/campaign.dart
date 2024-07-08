import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/campaign.dart';

const String tableCampaign = "tpmt6";

class CampaignFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    campaignCode,
    description,
    form,
  ];

  static const String docId = 'docid';
  static const String createDate = 'createdate';
  static const String updateDate = 'updatedate';
  static const String campaignCode = 'campaigncode';
  static const String description = 'description';
  static const String form = 'form';
}

class CampaignModel extends CampaignEntity implements BaseModel {
  CampaignModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.campaignCode,
    required super.description,
    required super.form,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'campaigncode': campaignCode,
      'description': description,
      'form': form,
    };
  }

  factory CampaignModel.fromMap(Map<String, dynamic> map) {
    return CampaignModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      campaignCode: map['campaigncode'] as String,
      description: map['description'] as String,
      form: map['form'] as String,
    );
  }

  factory CampaignModel.fromMapRemote(Map<String, dynamic> map) {
    return CampaignModel.fromMap({
      ...map,
      "description": map['descriptionn'] as String,
    });
  }

  factory CampaignModel.fromEntity(CampaignEntity entity) {
    return CampaignModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      campaignCode: entity.campaignCode,
      description: entity.description,
      form: entity.form,
    );
  }
}
