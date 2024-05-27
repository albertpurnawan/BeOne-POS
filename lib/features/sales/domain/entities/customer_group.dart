// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CustomerGroupEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String custgroupCode;
  final String description;
  final double maxDiscount;
  final int statusActive;
  final int activated;
  final String form;

  CustomerGroupEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    required this.custgroupCode,
    required this.description,
    required this.maxDiscount,
    required this.statusActive,
    required this.activated,
    required this.form,
  });

  CustomerGroupEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? custgroupCode,
    String? description,
    double? maxDiscount,
    int? statusActive,
    int? activated,
    String? form,
  }) {
    return CustomerGroupEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      custgroupCode: custgroupCode ?? this.custgroupCode,
      description: description ?? this.description,
      maxDiscount: maxDiscount ?? this.maxDiscount,
      statusActive: statusActive ?? this.statusActive,
      activated: activated ?? this.activated,
      form: form ?? this.form,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'custgroupCode': custgroupCode,
      'description': description,
      'maxDiscount': maxDiscount,
      'statusActive': statusActive,
      'activated': activated,
      'form': form,
    };
  }

  factory CustomerGroupEntity.fromMap(Map<String, dynamic> map) {
    return CustomerGroupEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      custgroupCode: map['custgroupCode'] as String,
      description: map['description'] as String,
      maxDiscount: map['maxDiscount'] as double,
      statusActive: map['statusActive'] as int,
      activated: map['activated'] as int,
      form: map['form'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerGroupEntity.fromJson(String source) =>
      CustomerGroupEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CustomerGroupEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, custgroupCode: $custgroupCode, description: $description, maxDiscount: $maxDiscount, statusActive: $statusActive, activated: $activated, form: $form)';
  }

  @override
  bool operator ==(covariant CustomerGroupEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.custgroupCode == custgroupCode &&
        other.description == description &&
        other.maxDiscount == maxDiscount &&
        other.statusActive == statusActive &&
        other.activated == activated &&
        other.form == form;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        custgroupCode.hashCode ^
        description.hashCode ^
        maxDiscount.hashCode ^
        statusActive.hashCode ^
        activated.hashCode ^
        form.hashCode;
  }
}
