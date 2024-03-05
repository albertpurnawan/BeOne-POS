// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PaymentTermEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String paymentCode;
  final String description;
  final String base;
  final int dueon;
  final int statusActive;
  final int activated;

  PaymentTermEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.paymentCode,
    required this.description,
    required this.base,
    required this.dueon,
    required this.statusActive,
    required this.activated,
  });

  PaymentTermEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? paymentCode,
    String? description,
    String? base,
    int? dueon,
    int? statusActive,
    int? activated,
  }) {
    return PaymentTermEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      paymentCode: paymentCode ?? this.paymentCode,
      description: description ?? this.description,
      base: base ?? this.base,
      dueon: dueon ?? this.dueon,
      statusActive: statusActive ?? this.statusActive,
      activated: activated ?? this.activated,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'paymentCode': paymentCode,
      'description': description,
      'base': base,
      'dueon': dueon,
      'statusActive': statusActive,
      'activated': activated,
    };
  }

  factory PaymentTermEntity.fromMap(Map<String, dynamic> map) {
    return PaymentTermEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      paymentCode: map['paymentCode'] as String,
      description: map['description'] as String,
      base: map['base'] as String,
      dueon: map['dueon'] as int,
      statusActive: map['statusActive'] as int,
      activated: map['activated'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentTermEntity.fromJson(String source) =>
      PaymentTermEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PaymentTermEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, paymentCode: $paymentCode, description: $description, base: $base, dueon: $dueon, statusActive: $statusActive, activated: $activated)';
  }

  @override
  bool operator ==(covariant PaymentTermEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.paymentCode == paymentCode &&
        other.description == description &&
        other.base == base &&
        other.dueon == dueon &&
        other.statusActive == statusActive &&
        other.activated == activated;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        paymentCode.hashCode ^
        description.hashCode ^
        base.hashCode ^
        dueon.hashCode ^
        statusActive.hashCode ^
        activated.hashCode;
  }
}
