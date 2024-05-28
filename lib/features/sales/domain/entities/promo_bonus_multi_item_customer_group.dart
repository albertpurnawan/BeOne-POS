import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class PromoBonusMultiItemCustomerGroupEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? topmiId;
  final String? tocrgId;
  final String form;

  PromoBonusMultiItemCustomerGroupEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.topmiId,
    required this.tocrgId,
    required this.form,
  });

  PromoBonusMultiItemCustomerGroupEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? topmiId,
    String? tocrgId,
    String? form,
  }) {
    return PromoBonusMultiItemCustomerGroupEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      topmiId: topmiId ?? this.topmiId,
      tocrgId: tocrgId ?? this.tocrgId,
      form: form ?? this.form,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'topmiId': topmiId,
      'tocrgId': tocrgId,
      'form': form,
    };
  }

  factory PromoBonusMultiItemCustomerGroupEntity.fromMap(
      Map<String, dynamic> map) {
    return PromoBonusMultiItemCustomerGroupEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      topmiId: map['topmiId'] != null ? map['topmiId'] as String : null,
      tocrgId: map['tocrgId'] != null ? map['tocrgId'] as String : null,
      form: map['form'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoBonusMultiItemCustomerGroupEntity.fromJson(String source) =>
      PromoBonusMultiItemCustomerGroupEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoBonusMultiItemCustomerGroupEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, topmiId: $topmiId, tocrgId: $tocrgId, form: $form)';
  }

  @override
  bool operator ==(covariant PromoBonusMultiItemCustomerGroupEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.topmiId == topmiId &&
        other.tocrgId == tocrgId &&
        other.form == form;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        topmiId.hashCode ^
        tocrgId.hashCode ^
        form.hashCode;
  }
}
