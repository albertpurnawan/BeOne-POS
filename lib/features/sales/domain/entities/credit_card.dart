// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CreditCardEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String ccCode;
  final String description;
  final int cardType;
  final int statusActive;
  final int activated;
  final String? tpmt5Id;
  final String form;

  CreditCardEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    required this.ccCode,
    required this.description,
    required this.cardType,
    required this.statusActive,
    required this.activated,
    this.tpmt5Id,
    required this.form,
  });

  CreditCardEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? ccCode,
    String? description,
    int? cardType,
    int? statusActive,
    int? activated,
    String? tpmt5Id,
    String? form,
  }) {
    return CreditCardEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      ccCode: ccCode ?? this.ccCode,
      description: description ?? this.description,
      cardType: cardType ?? this.cardType,
      statusActive: statusActive ?? this.statusActive,
      activated: activated ?? this.activated,
      tpmt5Id: tpmt5Id ?? this.tpmt5Id,
      form: form ?? this.form,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'ccCode': ccCode,
      'description': description,
      'cardType': cardType,
      'statusActive': statusActive,
      'activated': activated,
      'tpmt5Id': tpmt5Id,
      'form': form,
    };
  }

  factory CreditCardEntity.fromMap(Map<String, dynamic> map) {
    return CreditCardEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      ccCode: map['ccCode'] as String,
      description: map['description'] as String,
      cardType: map['cardType'] as int,
      statusActive: map['statusActive'] as int,
      activated: map['activated'] as int,
      tpmt5Id: map['tpmt5Id'] != null ? map['tpmt5Id'] as String : null,
      form: map['form'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreditCardEntity.fromJson(String source) =>
      CreditCardEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CreditCardEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, ccCode: $ccCode, description: $description, cardType: $cardType, statusActive: $statusActive, activated: $activated, tpmt5Id: $tpmt5Id, form: $form)';
  }

  @override
  bool operator ==(covariant CreditCardEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.ccCode == ccCode &&
        other.description == description &&
        other.cardType == cardType &&
        other.statusActive == statusActive &&
        other.activated == activated &&
        other.tpmt5Id == tpmt5Id &&
        other.form == form;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        ccCode.hashCode ^
        description.hashCode ^
        cardType.hashCode ^
        statusActive.hashCode ^
        activated.hashCode ^
        tpmt5Id.hashCode ^
        form.hashCode;
  }
}
