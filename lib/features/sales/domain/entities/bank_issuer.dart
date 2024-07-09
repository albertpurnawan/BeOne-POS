// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BankIssuerEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String bankCode;
  final String description;
  final String form;

  BankIssuerEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.bankCode,
    required this.description,
    required this.form,
  });

  BankIssuerEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? bankCode,
    String? description,
    String? form,
  }) {
    return BankIssuerEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      bankCode: bankCode ?? this.bankCode,
      description: description ?? this.description,
      form: form ?? this.form,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'bankCode': bankCode,
      'description': description,
      'form': form,
    };
  }

  factory BankIssuerEntity.fromMap(Map<String, dynamic> map) {
    return BankIssuerEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      bankCode: map['bankCode'] as String,
      description: map['description'] as String,
      form: map['form'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BankIssuerEntity.fromJson(String source) =>
      BankIssuerEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BankIssuerEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, bankCode: $bankCode, description: $description, form: $form)';
  }

  @override
  bool operator ==(covariant BankIssuerEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.bankCode == bankCode &&
        other.description == description &&
        other.form == form;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        bankCode.hashCode ^
        description.hashCode ^
        form.hashCode;
  }
}
