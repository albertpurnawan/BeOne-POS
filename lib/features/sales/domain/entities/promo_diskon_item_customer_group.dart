// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoDiskonItemCustomerGroupEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? topdiId;
  final String? tocrgId;
  final String form;

  PromoDiskonItemCustomerGroupEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    this.topdiId,
    this.tocrgId,
    required this.form,
  });

  PromoDiskonItemCustomerGroupEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? topdiId,
    String? tocrgId,
    String? form,
  }) {
    return PromoDiskonItemCustomerGroupEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      topdiId: topdiId ?? this.topdiId,
      tocrgId: tocrgId ?? this.tocrgId,
      form: form ?? this.form,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'topdiId': topdiId,
      'tocrgId': tocrgId,
      'form': form,
    };
  }

  factory PromoDiskonItemCustomerGroupEntity.fromMap(Map<String, dynamic> map) {
    return PromoDiskonItemCustomerGroupEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      topdiId: map['topdiId'] != null ? map['topdiId'] as String : null,
      tocrgId: map['tocrgId'] != null ? map['tocrgId'] as String : null,
      form: map['form'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoDiskonItemCustomerGroupEntity.fromJson(String source) =>
      PromoDiskonItemCustomerGroupEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoDiskonItemCustomerGroupEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, topdiId: $topdiId, tocrgId: $tocrgId, form: $form)';
  }

  @override
  bool operator ==(covariant PromoDiskonItemCustomerGroupEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.topdiId == topdiId &&
        other.tocrgId == tocrgId &&
        other.form == form;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        topdiId.hashCode ^
        tocrgId.hashCode ^
        form.hashCode;
  }
}
