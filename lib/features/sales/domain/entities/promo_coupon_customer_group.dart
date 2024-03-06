// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoCouponCustomerGroupEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? toprnId;
  final String? tocrgId;

  PromoCouponCustomerGroupEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.toprnId,
    required this.tocrgId,
  });

  PromoCouponCustomerGroupEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? toprnId,
    String? tocrgId,
  }) {
    return PromoCouponCustomerGroupEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toprnId: toprnId ?? this.toprnId,
      tocrgId: tocrgId ?? this.tocrgId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toprnId': toprnId,
      'tocrgId': tocrgId,
    };
  }

  factory PromoCouponCustomerGroupEntity.fromMap(Map<String, dynamic> map) {
    return PromoCouponCustomerGroupEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      toprnId: map['toprnId'] != null ? map['toprnId'] as String : null,
      tocrgId: map['tocrgId'] != null ? map['tocrgId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoCouponCustomerGroupEntity.fromJson(String source) =>
      PromoCouponCustomerGroupEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoCouponCustomerGroupEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, toprnId: $toprnId, tocrgId: $tocrgId)';
  }

  @override
  bool operator ==(covariant PromoCouponCustomerGroupEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toprnId == toprnId &&
        other.tocrgId == tocrgId;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toprnId.hashCode ^
        tocrgId.hashCode;
  }
}
