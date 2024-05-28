// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoDiskonGroupItemGetConditionEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? topdgId;
  final double promoValue;
  final double discount1;
  final double discount2;
  final double discount3;
  final String form;

  PromoDiskonGroupItemGetConditionEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    this.topdgId,
    required this.promoValue,
    required this.discount1,
    required this.discount2,
    required this.discount3,
    required this.form,
  });

  PromoDiskonGroupItemGetConditionEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? topdgId,
    double? promoValue,
    double? discount1,
    double? discount2,
    double? discount3,
    String? form,
  }) {
    return PromoDiskonGroupItemGetConditionEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      topdgId: topdgId ?? this.topdgId,
      promoValue: promoValue ?? this.promoValue,
      discount1: discount1 ?? this.discount1,
      discount2: discount2 ?? this.discount2,
      discount3: discount3 ?? this.discount3,
      form: form ?? this.form,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'topdgId': topdgId,
      'promoValue': promoValue,
      'discount1': discount1,
      'discount2': discount2,
      'discount3': discount3,
      'form': form,
    };
  }

  factory PromoDiskonGroupItemGetConditionEntity.fromMap(
      Map<String, dynamic> map) {
    return PromoDiskonGroupItemGetConditionEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      topdgId: map['topdgId'] != null ? map['topdgId'] as String : null,
      promoValue: map['promoValue'] as double,
      discount1: map['discount1'] as double,
      discount2: map['discount2'] as double,
      discount3: map['discount3'] as double,
      form: map['form'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoDiskonGroupItemGetConditionEntity.fromJson(String source) =>
      PromoDiskonGroupItemGetConditionEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoDiskonGroupItemGetConditionEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, topdgId: $topdgId, promoValue: $promoValue, discount1: $discount1, discount2: $discount2, discount3: $discount3, form: $form)';
  }

  @override
  bool operator ==(covariant PromoDiskonGroupItemGetConditionEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.topdgId == topdgId &&
        other.promoValue == promoValue &&
        other.discount1 == discount1 &&
        other.discount2 == discount2 &&
        other.discount3 == discount3 &&
        other.form == form;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        topdgId.hashCode ^
        promoValue.hashCode ^
        discount1.hashCode ^
        discount2.hashCode ^
        discount3.hashCode ^
        form.hashCode;
  }
}
