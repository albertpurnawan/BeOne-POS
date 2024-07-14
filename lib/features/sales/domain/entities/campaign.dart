// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CampaignEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String campaignCode;
  final String description;
  // final int statusActive;
  final String form;

  CampaignEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    required this.campaignCode,
    required this.description,
    // required this.statusActive,
    required this.form,
  });

  CampaignEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? campaignCode,
    String? description,
    // int? statusActive,
    String? form,
  }) {
    return CampaignEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      campaignCode: campaignCode ?? this.campaignCode,
      description: description ?? this.description,
      // statusActive: statusActive ?? this.statusActive,
      form: form ?? this.form,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'campaignCode': campaignCode,
      'description': description,
      // 'statusActive': statusActive,
      'form': form,
    };
  }

  factory CampaignEntity.fromMap(Map<String, dynamic> map) {
    return CampaignEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int) : null,
      campaignCode: map['campaignCode'] as String,
      description: map['description'] as String,
      // statusActive: map['statusActive'] as int,
      form: map['form'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CampaignEntity.fromJson(String source) => CampaignEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CampaignEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, campaignCode: $campaignCode, description: $description, form: $form)';
  }

  @override
  bool operator ==(covariant CampaignEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.campaignCode == campaignCode &&
        other.description == description &&
        // other.statusActive == statusActive &&
        other.form == form;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        campaignCode.hashCode ^
        description.hashCode ^
        // statusActive.hashCode ^
        form.hashCode;
  }
}
