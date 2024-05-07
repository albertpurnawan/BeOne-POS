// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoDiskonGroupItemCustomerGroupEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? topdgId;
  final String? tocrgId;

  PromoDiskonGroupItemCustomerGroupEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.topdgId,
    required this.tocrgId,
  });

  PromoDiskonGroupItemCustomerGroupEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? topdgId,
    String? tocrgId,
  }) {
    return PromoDiskonGroupItemCustomerGroupEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      topdgId: topdgId ?? this.topdgId,
      tocrgId: tocrgId ?? this.tocrgId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'topdgId': topdgId,
      'tocrgId': tocrgId,
    };
  }

  factory PromoDiskonGroupItemCustomerGroupEntity.fromMap(
      Map<String, dynamic> map) {
    return PromoDiskonGroupItemCustomerGroupEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      topdgId: map['topdgId'] != null ? map['topdgId'] as String : null,
      tocrgId: map['tocrgId'] != null ? map['tocrgId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoDiskonGroupItemCustomerGroupEntity.fromJson(String source) =>
      PromoDiskonGroupItemCustomerGroupEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoDiskonGroupItemCustomerGroupEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, topdgId: $topdgId, tocrgId: $tocrgId)';
  }

  @override
  bool operator ==(covariant PromoDiskonGroupItemCustomerGroupEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.topdgId == topdgId &&
        other.tocrgId == tocrgId;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        topdgId.hashCode ^
        tocrgId.hashCode;
  }
}
