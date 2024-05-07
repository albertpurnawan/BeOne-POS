// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoHargaSpesialCustomerGroupEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? topsbId;
  final String? tocrgId;

  PromoHargaSpesialCustomerGroupEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.topsbId,
    required this.tocrgId,
  });

  PromoHargaSpesialCustomerGroupEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? topsbId,
    String? tocrgId,
  }) {
    return PromoHargaSpesialCustomerGroupEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      topsbId: topsbId ?? this.topsbId,
      tocrgId: tocrgId ?? this.tocrgId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'topsbId': topsbId,
      'tocrgId': tocrgId,
    };
  }

  factory PromoHargaSpesialCustomerGroupEntity.fromMap(
      Map<String, dynamic> map) {
    return PromoHargaSpesialCustomerGroupEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      topsbId: map['topsbId'] != null ? map['topsbId'] as String : null,
      tocrgId: map['tocrgId'] != null ? map['tocrgId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoHargaSpesialCustomerGroupEntity.fromJson(String source) =>
      PromoHargaSpesialCustomerGroupEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoHargaSpesialCustomerGroupEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, topsbId: $topsbId, tocrgId: $tocrgId)';
  }

  @override
  bool operator ==(covariant PromoHargaSpesialCustomerGroupEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.topsbId == topsbId &&
        other.tocrgId == tocrgId;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        topsbId.hashCode ^
        tocrgId.hashCode;
  }
}
