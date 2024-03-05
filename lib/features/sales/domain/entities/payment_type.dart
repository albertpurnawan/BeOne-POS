// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PaymentTypeEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String payTypeCode;
  final String description;

  PaymentTypeEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.payTypeCode,
    required this.description,
  });

  PaymentTypeEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? payTypeCode,
    String? description,
  }) {
    return PaymentTypeEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      payTypeCode: payTypeCode ?? this.payTypeCode,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'payTypeCode': payTypeCode,
      'description': description,
    };
  }

  factory PaymentTypeEntity.fromMap(Map<String, dynamic> map) {
    return PaymentTypeEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      payTypeCode: map['payTypeCode'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentTypeEntity.fromJson(String source) =>
      PaymentTypeEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PaymentTypeEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, payTypeCode: $payTypeCode, description: $description)';
  }

  @override
  bool operator ==(covariant PaymentTypeEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.payTypeCode == payTypeCode &&
        other.description == description;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        payTypeCode.hashCode ^
        description.hashCode;
  }
}
