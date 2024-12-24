// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoSpesialMultiItemCustomerGroupEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? topsmId;
  final String? tocrgId;
  final String form;

  PromoSpesialMultiItemCustomerGroupEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    this.topsmId,
    this.tocrgId,
    required this.form,
  });

  PromoSpesialMultiItemCustomerGroupEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? topsmId,
    String? tocrgId,
    String? form,
  }) {
    return PromoSpesialMultiItemCustomerGroupEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      topsmId: topsmId ?? this.topsmId,
      tocrgId: tocrgId ?? this.tocrgId,
      form: form ?? this.form,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'topsmId': topsmId,
      'tocrgId': tocrgId,
      'form': form,
    };
  }

  factory PromoSpesialMultiItemCustomerGroupEntity.fromMap(Map<String, dynamic> map) {
    return PromoSpesialMultiItemCustomerGroupEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int) : null,
      topsmId: map['topsmId'] != null ? map['topsmId'] as String : null,
      tocrgId: map['tocrgId'] != null ? map['tocrgId'] as String : null,
      form: map['form'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoSpesialMultiItemCustomerGroupEntity.fromJson(String source) =>
      PromoSpesialMultiItemCustomerGroupEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoSpesialMultiItemCustomerGroupEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, topsmId: $topsmId, tocrgId: $tocrgId, form: $form)';
  }

  @override
  bool operator ==(covariant PromoSpesialMultiItemCustomerGroupEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.topsmId == topsmId &&
        other.tocrgId == tocrgId &&
        other.form == form;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        topsmId.hashCode ^
        tocrgId.hashCode ^
        form.hashCode;
  }
}
