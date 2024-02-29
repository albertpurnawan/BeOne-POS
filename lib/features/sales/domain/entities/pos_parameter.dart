// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class POSParameterEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String tostrId;
  final String storeName;
  final String tcurrId;
  final String currCode;
  final String toplnId;

  POSParameterEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    required this.tostrId,
    required this.storeName,
    required this.tcurrId,
    required this.currCode,
    required this.toplnId,
  });

  POSParameterEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? tostrId,
    String? storeName,
    String? tcurrId,
    String? currCode,
    String? toplnId,
  }) {
    return POSParameterEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      tostrId: tostrId ?? this.tostrId,
      storeName: storeName ?? this.storeName,
      tcurrId: tcurrId ?? this.tcurrId,
      currCode: currCode ?? this.currCode,
      toplnId: toplnId ?? this.toplnId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'tostrId': tostrId,
      'storeName': storeName,
      'tcurrId': tcurrId,
      'currCode': currCode,
      'toplnId': toplnId,
    };
  }

  factory POSParameterEntity.fromMap(Map<String, dynamic> map) {
    return POSParameterEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      tostrId: map['tostrId'] as String,
      storeName: map['storeName'] as String,
      tcurrId: map['tcurrId'] as String,
      currCode: map['currCode'] as String,
      toplnId: map['toplnId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory POSParameterEntity.fromJson(String source) =>
      POSParameterEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'POSParameterEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, tostrId: $tostrId, storeName: $storeName, tcurrId: $tcurrId, currCode: $currCode, toplnId: $toplnId)';
  }

  @override
  bool operator ==(covariant POSParameterEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.tostrId == tostrId &&
        other.storeName == storeName &&
        other.tcurrId == tcurrId &&
        other.currCode == currCode &&
        other.toplnId == toplnId;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        tostrId.hashCode ^
        storeName.hashCode ^
        tcurrId.hashCode ^
        currCode.hashCode ^
        toplnId.hashCode;
  }
}
