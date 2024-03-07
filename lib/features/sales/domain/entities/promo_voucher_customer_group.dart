// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoVoucherCustomerGroupEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? toprrId;
  final String? tocrgId;

  PromoVoucherCustomerGroupEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.toprrId,
    required this.tocrgId,
  });

  PromoVoucherCustomerGroupEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? toprrId,
    String? tocrgId,
  }) {
    return PromoVoucherCustomerGroupEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toprrId: toprrId ?? this.toprrId,
      tocrgId: tocrgId ?? this.tocrgId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toprrId': toprrId,
      'tocrgId': tocrgId,
    };
  }

  factory PromoVoucherCustomerGroupEntity.fromMap(Map<String, dynamic> map) {
    return PromoVoucherCustomerGroupEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      toprrId: map['toprrId'] != null ? map['toprrId'] as String : null,
      tocrgId: map['tocrgId'] != null ? map['tocrgId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoVoucherCustomerGroupEntity.fromJson(String source) =>
      PromoVoucherCustomerGroupEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoVoucherCustomerGroupEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, toprrId: $toprrId, tocrgId: $tocrgId)';
  }

  @override
  bool operator ==(covariant PromoVoucherCustomerGroupEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toprrId == toprrId &&
        other.tocrgId == tocrgId;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toprrId.hashCode ^
        tocrgId.hashCode;
  }
}
