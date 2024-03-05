// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoBertingkatCustomerGroupEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? toprpId;
  final String? tocrgId;

  PromoBertingkatCustomerGroupEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.toprpId,
    required this.tocrgId,
  });

  PromoBertingkatCustomerGroupEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? toprpId,
    String? tocrgId,
  }) {
    return PromoBertingkatCustomerGroupEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toprpId: toprpId ?? this.toprpId,
      tocrgId: tocrgId ?? this.tocrgId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toprpId': toprpId,
      'tocrgId': tocrgId,
    };
  }

  factory PromoBertingkatCustomerGroupEntity.fromMap(Map<String, dynamic> map) {
    return PromoBertingkatCustomerGroupEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      toprpId: map['toprpId'] != null ? map['toprpId'] as String : null,
      tocrgId: map['tocrgId'] != null ? map['tocrgId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoBertingkatCustomerGroupEntity.fromJson(String source) =>
      PromoBertingkatCustomerGroupEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoBertingkatCustomerGroupEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, toprpId: $toprpId, tocrgId: $tocrgId)';
  }

  @override
  bool operator ==(covariant PromoBertingkatCustomerGroupEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toprpId == toprpId &&
        other.tocrgId == tocrgId;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toprpId.hashCode ^
        tocrgId.hashCode;
  }
}
