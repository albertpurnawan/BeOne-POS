// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UomEntity {
  // final int id;
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String uomCode;
  final String uomDesc;
  final int statusActive;
  final int activated;

  UomEntity({
    // required this.id,
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.uomCode,
    required this.uomDesc,
    required this.statusActive,
    required this.activated,
  });

  UomEntity copyWith({
    // int? id,
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? uomCode,
    String? uomDesc,
    int? statusActive,
    int? activated,
  }) {
    return UomEntity(
      // id: id ?? this.id,
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      uomCode: uomCode ?? this.uomCode,
      uomDesc: uomDesc ?? this.uomDesc,
      statusActive: statusActive ?? this.statusActive,
      activated: activated ?? this.activated,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'id': id,
      'docId': docId,
      'createDate': createDate.toIso8601String(),
      'updateDate': updateDate?.toIso8601String(),
      'uomCode': uomCode,
      'uomDesc': uomDesc,
      'statusActive': statusActive,
      'activated': activated,
    };
  }

  factory UomEntity.fromMap(Map<String, dynamic> map) {
    return UomEntity(
      // id: map['id'] as int,
      docId: map['docId'] as String,
      createDate: DateTime.parse(map['createDate']),
      updateDate:
          map['updateDate'] != null ? DateTime.parse(map['updateDate']) : null,
      uomCode: map['uomCode'] as String,
      uomDesc: map['uomDesc'] as String,
      statusActive: map['statusActive'] as int,
      activated: map['activated'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory UomEntity.fromJson(String source) =>
      UomEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Uom(docId: $docId, createDate: $createDate, updateDate: $updateDate, uomCode: $uomCode, uomDesc: $uomDesc, statusActive: $statusActive, activated: $activated)';
  }

  @override
  bool operator ==(covariant UomEntity other) {
    if (identical(this, other)) return true;

    return
        // other.id == id &&
        other.docId == docId &&
            other.createDate == createDate &&
            other.updateDate == updateDate &&
            other.uomCode == uomCode &&
            other.uomDesc == uomDesc &&
            other.statusActive == statusActive &&
            other.activated == activated;
  }

  @override
  int get hashCode {
    return
        // id.hashCode ^
        docId.hashCode ^
            createDate.hashCode ^
            updateDate.hashCode ^
            uomCode.hashCode ^
            uomDesc.hashCode ^
            statusActive.hashCode ^
            activated.hashCode;
  }
}
