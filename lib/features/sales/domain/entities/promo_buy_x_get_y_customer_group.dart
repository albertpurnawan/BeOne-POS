// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoBuyXGetYCustomerGroupEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? toprbId;
  final String? tocrgId;
  final String form;

  PromoBuyXGetYCustomerGroupEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    this.toprbId,
    this.tocrgId,
    required this.form,
  });

  PromoBuyXGetYCustomerGroupEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? toprbId,
    String? tocrgId,
    String? form,
  }) {
    return PromoBuyXGetYCustomerGroupEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toprbId: toprbId ?? this.toprbId,
      tocrgId: tocrgId ?? this.tocrgId,
      form: form ?? this.form,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toprbId': toprbId,
      'tocrgId': tocrgId,
      'form': form,
    };
  }

  factory PromoBuyXGetYCustomerGroupEntity.fromMap(Map<String, dynamic> map) {
    return PromoBuyXGetYCustomerGroupEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      toprbId: map['toprbId'] != null ? map['toprbId'] as String : null,
      tocrgId: map['tocrgId'] != null ? map['tocrgId'] as String : null,
      form: map['form'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoBuyXGetYCustomerGroupEntity.fromJson(String source) =>
      PromoBuyXGetYCustomerGroupEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoBuyXGetYCustomerGroupEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, toprbId: $toprbId, tocrgId: $tocrgId, form: $form)';
  }

  @override
  bool operator ==(covariant PromoBuyXGetYCustomerGroupEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toprbId == toprbId &&
        other.tocrgId == tocrgId &&
        other.form == form;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toprbId.hashCode ^
        tocrgId.hashCode ^
        form.hashCode;
  }
}
