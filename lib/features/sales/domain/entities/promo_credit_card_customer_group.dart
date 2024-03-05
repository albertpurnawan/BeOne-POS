// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoCreditCardCustomerGroupEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? toprcId;
  final String? tocrgId;

  PromoCreditCardCustomerGroupEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.toprcId,
    required this.tocrgId,
  });

  PromoCreditCardCustomerGroupEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? toprcId,
    String? tocrgId,
  }) {
    return PromoCreditCardCustomerGroupEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toprcId: toprcId ?? this.toprcId,
      tocrgId: tocrgId ?? this.tocrgId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toprcId': toprcId,
      'tocrgId': tocrgId,
    };
  }

  factory PromoCreditCardCustomerGroupEntity.fromMap(Map<String, dynamic> map) {
    return PromoCreditCardCustomerGroupEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      toprcId: map['toprcId'] != null ? map['toprcId'] as String : null,
      tocrgId: map['tocrgId'] != null ? map['tocrgId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoCreditCardCustomerGroupEntity.fromJson(String source) =>
      PromoCreditCardCustomerGroupEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoCreditCardCustomerGroupEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, toprcId: $toprcId, tocrgId: $tocrgId)';
  }

  @override
  bool operator ==(covariant PromoCreditCardCustomerGroupEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toprcId == toprcId &&
        other.tocrgId == tocrgId;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toprcId.hashCode ^
        tocrgId.hashCode;
  }
}
