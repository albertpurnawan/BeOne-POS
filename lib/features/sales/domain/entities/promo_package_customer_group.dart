// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoPackageCustomerGroupEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? toprkId;
  final String? tocrgId;

  PromoPackageCustomerGroupEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.toprkId,
    required this.tocrgId,
  });

  PromoPackageCustomerGroupEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? toprkId,
    String? tocrgId,
  }) {
    return PromoPackageCustomerGroupEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toprkId: toprkId ?? this.toprkId,
      tocrgId: tocrgId ?? this.tocrgId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toprkId': toprkId,
      'tocrgId': tocrgId,
    };
  }

  factory PromoPackageCustomerGroupEntity.fromMap(Map<String, dynamic> map) {
    return PromoPackageCustomerGroupEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      toprkId: map['toprkId'] != null ? map['toprkId'] as String : null,
      tocrgId: map['tocrgId'] != null ? map['tocrgId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoPackageCustomerGroupEntity.fromJson(String source) =>
      PromoPackageCustomerGroupEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoPackageCustomerGroupEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, toprkId: $toprkId, tocrgId: $tocrgId)';
  }

  @override
  bool operator ==(covariant PromoPackageCustomerGroupEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toprkId == toprkId &&
        other.tocrgId == tocrgId;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toprkId.hashCode ^
        tocrgId.hashCode;
  }
}
