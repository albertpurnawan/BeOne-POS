// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MoneyDenominationEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? tcsr1Id;
  final int? coin50;
  final int? coin100;
  final int? coin200;
  final int? coin500;
  final int? coin1k;
  final int? paper1k;
  final int? paper2k;
  final int? paper5k;
  final int? paper10k;
  final int? paper20k;
  final int? paper50k;
  final int? paper100k;

  MoneyDenominationEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.tcsr1Id,
    required this.coin50,
    required this.coin100,
    required this.coin200,
    required this.coin500,
    required this.coin1k,
    required this.paper1k,
    required this.paper2k,
    required this.paper5k,
    required this.paper10k,
    required this.paper20k,
    required this.paper50k,
    required this.paper100k,
  });

  MoneyDenominationEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? tcsr1Id,
    int? coin50,
    int? coin100,
    int? coin200,
    int? coin500,
    int? coin1k,
    int? paper1k,
    int? paper2k,
    int? paper5k,
    int? paper10k,
    int? paper20k,
    int? paper50k,
    int? paper100k,
  }) {
    return MoneyDenominationEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      tcsr1Id: tcsr1Id ?? this.tcsr1Id,
      coin50: coin50 ?? this.coin50,
      coin100: coin100 ?? this.coin100,
      coin200: coin200 ?? this.coin200,
      coin500: coin500 ?? this.coin500,
      coin1k: coin1k ?? this.coin1k,
      paper1k: paper1k ?? this.paper1k,
      paper2k: paper2k ?? this.paper2k,
      paper5k: paper5k ?? this.paper5k,
      paper10k: paper10k ?? this.paper10k,
      paper20k: paper20k ?? this.paper20k,
      paper50k: paper50k ?? this.paper50k,
      paper100k: paper100k ?? this.paper100k,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'tcsr1Id': tcsr1Id,
      'coin50': coin50,
      'coin100': coin100,
      'coin200': coin200,
      'coin500': coin500,
      'coin1k': coin1k,
      'paper1k': paper1k,
      'paper2k': paper2k,
      'paper5k': paper5k,
      'paper10k': paper10k,
      'paper20k': paper20k,
      'paper50k': paper50k,
      'paper100k': paper100k,
    };
  }

  factory MoneyDenominationEntity.fromMap(Map<String, dynamic> map) {
    return MoneyDenominationEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      tcsr1Id: map['tcsr1Id'] != null ? map['tcsr1Id'] as String : null,
      coin50: map['coin50'] != null ? map['coin50'] as int : null,
      coin100: map['coin100'] != null ? map['coin100'] as int : null,
      coin200: map['coin200'] != null ? map['coin200'] as int : null,
      coin500: map['coin500'] != null ? map['coin500'] as int : null,
      coin1k: map['coin1k'] != null ? map['coin1k'] as int : null,
      paper1k: map['paper1k'] != null ? map['paper1k'] as int : null,
      paper2k: map['paper2k'] != null ? map['paper2k'] as int : null,
      paper5k: map['paper5k'] != null ? map['paper5k'] as int : null,
      paper10k: map['paper10k'] != null ? map['paper10k'] as int : null,
      paper20k: map['paper20k'] != null ? map['paper20k'] as int : null,
      paper50k: map['paper50k'] != null ? map['paper50k'] as int : null,
      paper100k: map['paper100k'] != null ? map['paper100k'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MoneyDenominationEntity.fromJson(String source) =>
      MoneyDenominationEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MoneyDenominationEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, tcsr1Id: $tcsr1Id, coin50: $coin50, coin100: $coin100, coin200: $coin200, coin500: $coin500, coin1k: $coin1k, paper1k: $paper1k, paper2k: $paper2k, paper5k: $paper5k, paper10k: $paper10k, paper20k: $paper20k, paper50k: $paper50k, paper100k: $paper100k)';
  }

  @override
  bool operator ==(covariant MoneyDenominationEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.tcsr1Id == tcsr1Id &&
        other.coin50 == coin50 &&
        other.coin100 == coin100 &&
        other.coin200 == coin200 &&
        other.coin500 == coin500 &&
        other.coin1k == coin1k &&
        other.paper1k == paper1k &&
        other.paper2k == paper2k &&
        other.paper5k == paper5k &&
        other.paper10k == paper10k &&
        other.paper20k == paper20k &&
        other.paper50k == paper50k &&
        other.paper100k == paper100k;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        tcsr1Id.hashCode ^
        coin50.hashCode ^
        coin100.hashCode ^
        coin200.hashCode ^
        coin500.hashCode ^
        coin1k.hashCode ^
        paper1k.hashCode ^
        paper2k.hashCode ^
        paper5k.hashCode ^
        paper10k.hashCode ^
        paper20k.hashCode ^
        paper50k.hashCode ^
        paper100k.hashCode;
  }
}
