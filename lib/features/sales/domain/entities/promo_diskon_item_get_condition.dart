// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoDiskonItemGetConditionEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? topdiId;
  final double promoValue;
  final double discount1;
  final double discount2;
  final double discount3;
  final String form;

  PromoDiskonItemGetConditionEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    this.topdiId,
    required this.promoValue,
    required this.discount1,
    required this.discount2,
    required this.discount3,
    required this.form,
  });

  PromoDiskonItemGetConditionEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? topdiId,
    double? promoValue,
    double? discount1,
    double? discount2,
    double? discount3,
    String? form,
  }) {
    return PromoDiskonItemGetConditionEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      topdiId: topdiId ?? this.topdiId,
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
      'topdiId': topdiId,
      'promoValue': promoValue,
      'discount1': discount1,
      'discount2': discount2,
      'discount3': discount3,
      'form': form,
    };
  }

  factory PromoDiskonItemGetConditionEntity.fromMap(Map<String, dynamic> map) {
    return PromoDiskonItemGetConditionEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      topdiId: map['topdiId'] != null ? map['topdiId'] as String : null,
      promoValue: map['promoValue'] as double,
      discount1: map['discount1'] as double,
      discount2: map['discount2'] as double,
      discount3: map['discount3'] as double,
      form: map['form'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoDiskonItemGetConditionEntity.fromJson(String source) =>
      PromoDiskonItemGetConditionEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoDiskonItemGetConditionEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, topdiId: $topdiId, promoValue: $promoValue, discount1: $discount1, discount2: $discount2, discount3: $discount3, form: $form)';
  }

  @override
  bool operator ==(covariant PromoDiskonItemGetConditionEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.topdiId == topdiId &&
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
        topdiId.hashCode ^
        promoValue.hashCode ^
        discount1.hashCode ^
        discount2.hashCode ^
        discount3.hashCode ^
        form.hashCode;
  }
}
