// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class VendorGroupEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String vendorGroupCode;
  final String description;
  final double maxDiscount;
  final int statusActive;
  final int activated;
  final int sync;

  VendorGroupEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.vendorGroupCode,
    required this.description,
    required this.maxDiscount,
    required this.statusActive,
    required this.activated,
    required this.sync,
  });

  VendorGroupEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? vendorGroupCode,
    String? description,
    double? maxDiscount,
    int? statusActive,
    int? activated,
    int? sync,
  }) {
    return VendorGroupEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      vendorGroupCode: vendorGroupCode ?? this.vendorGroupCode,
      description: description ?? this.description,
      maxDiscount: maxDiscount ?? this.maxDiscount,
      statusActive: statusActive ?? this.statusActive,
      activated: activated ?? this.activated,
      sync: sync ?? this.sync,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'vendorGroupCode': vendorGroupCode,
      'description': description,
      'maxDiscount': maxDiscount,
      'statusActive': statusActive,
      'activated': activated,
      'sync': sync,
    };
  }

  factory VendorGroupEntity.fromMap(Map<String, dynamic> map) {
    return VendorGroupEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      vendorGroupCode: map['vendorGroupCode'] as String,
      description: map['description'] as String,
      maxDiscount: map['maxDiscount'] as double,
      statusActive: map['statusActive'] as int,
      activated: map['activated'] as int,
      sync: map['sync'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory VendorGroupEntity.fromJson(String source) =>
      VendorGroupEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VendorGroupEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, vendorGroupCode: $vendorGroupCode, description: $description, maxDiscount: $maxDiscount, statusActive: $statusActive, activated: $activated, sync: $sync)';
  }

  @override
  bool operator ==(covariant VendorGroupEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.vendorGroupCode == vendorGroupCode &&
        other.description == description &&
        other.maxDiscount == maxDiscount &&
        other.statusActive == statusActive &&
        other.activated == activated &&
        other.sync == sync;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        vendorGroupCode.hashCode ^
        description.hashCode ^
        maxDiscount.hashCode ^
        statusActive.hashCode ^
        activated.hashCode ^
        sync.hashCode;
  }
}
