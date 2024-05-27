// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoDiskonGroupItemBuyConditionEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? topdgId;
  final String? tocatId;
  final String form;

  PromoDiskonGroupItemBuyConditionEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    this.topdgId,
    this.tocatId,
    required this.form,
  });

  PromoDiskonGroupItemBuyConditionEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? topdgId,
    String? tocatId,
    String? form,
  }) {
    return PromoDiskonGroupItemBuyConditionEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      topdgId: topdgId ?? this.topdgId,
      tocatId: tocatId ?? this.tocatId,
      form: form ?? this.form,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'topdgId': topdgId,
      'tocatId': tocatId,
      'form': form,
    };
  }

  factory PromoDiskonGroupItemBuyConditionEntity.fromMap(
      Map<String, dynamic> map) {
    return PromoDiskonGroupItemBuyConditionEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      topdgId: map['topdgId'] != null ? map['topdgId'] as String : null,
      tocatId: map['tocatId'] != null ? map['tocatId'] as String : null,
      form: map['form'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoDiskonGroupItemBuyConditionEntity.fromJson(String source) =>
      PromoDiskonGroupItemBuyConditionEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoDiskonGroupItemBuyConditionEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, topdgId: $topdgId, tocatId: $tocatId, form: $form)';
  }

  @override
  bool operator ==(covariant PromoDiskonGroupItemBuyConditionEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.topdgId == topdgId &&
        other.tocatId == tocatId &&
        other.form == form;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        topdgId.hashCode ^
        tocatId.hashCode ^
        form.hashCode;
  }
}
