// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoGWPCustomerGroupEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? toprgId;
  final String? tocrgId;

  PromoGWPCustomerGroupEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.toprgId,
    required this.tocrgId,
  });

  PromoGWPCustomerGroupEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? toprgId,
    String? tocrgId,
  }) {
    return PromoGWPCustomerGroupEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toprgId: toprgId ?? this.toprgId,
      tocrgId: tocrgId ?? this.tocrgId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toprgId': toprgId,
      'tocrgId': tocrgId,
    };
  }

  factory PromoGWPCustomerGroupEntity.fromMap(Map<String, dynamic> map) {
    return PromoGWPCustomerGroupEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      toprgId: map['toprgId'] != null ? map['toprgId'] as String : null,
      tocrgId: map['tocrgId'] != null ? map['tocrgId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoGWPCustomerGroupEntity.fromJson(String source) =>
      PromoGWPCustomerGroupEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoGWPCustomerGroupEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, toprgId: $toprgId, tocrgId: $tocrgId)';
  }

  @override
  bool operator ==(covariant PromoGWPCustomerGroupEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toprgId == toprgId &&
        other.tocrgId == tocrgId;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toprgId.hashCode ^
        tocrgId.hashCode;
  }
}
