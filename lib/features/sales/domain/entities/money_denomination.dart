import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class MoneyDenominationEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? nominal;
  final int? count;
  final String? tcsr1Id;

  MoneyDenominationEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.nominal,
    required this.count,
    required this.tcsr1Id,
  });

  MoneyDenominationEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? nominal,
    int? count,
    String? tcsr1Id,
  }) {
    return MoneyDenominationEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      nominal: nominal ?? this.nominal,
      count: count ?? this.count,
      tcsr1Id: tcsr1Id ?? this.tcsr1Id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'nominal': nominal,
      'count': count,
      'tcsr1Id': tcsr1Id,
    };
  }

  factory MoneyDenominationEntity.fromMap(Map<String, dynamic> map) {
    return MoneyDenominationEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      nominal: map['nominal'] != null ? map['nominal'] as String : null,
      count: map['count'] != null ? map['count'] as int : null,
      tcsr1Id: map['tcsr1Id'] != null ? map['tcsr1Id'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MoneyDenominationEntity.fromJson(String source) =>
      MoneyDenominationEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MoneyDenominationEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, nominal: $nominal, count: $count, tcsr1Id: $tcsr1Id)';
  }

  @override
  bool operator ==(covariant MoneyDenominationEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.nominal == nominal &&
        other.count == count &&
        other.tcsr1Id == tcsr1Id;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        nominal.hashCode ^
        count.hashCode ^
        tcsr1Id.hashCode;
  }
}
