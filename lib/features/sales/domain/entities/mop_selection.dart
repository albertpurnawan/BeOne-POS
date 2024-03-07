// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MopSelectionEntity {
  final String tpmt3Id;
  final String tpmt1Id;
  final String mopAlias;
  final double? bankCharge;

  MopSelectionEntity({
    required this.tpmt3Id,
    required this.tpmt1Id,
    required this.mopAlias,
    required this.bankCharge,
  });

  MopSelectionEntity copyWith({
    String? tpmt3Id,
    String? tpmt1Id,
    String? mopAlias,
    double? bankCharge,
  }) {
    return MopSelectionEntity(
      tpmt3Id: tpmt3Id ?? this.tpmt3Id,
      tpmt1Id: tpmt1Id ?? this.tpmt1Id,
      mopAlias: mopAlias ?? this.mopAlias,
      bankCharge: bankCharge ?? this.bankCharge,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tpmt3Id': tpmt3Id,
      'tpmt1Id': tpmt1Id,
      'mopAlias': mopAlias,
      'bankCharge': bankCharge,
    };
  }

  factory MopSelectionEntity.fromMap(Map<String, dynamic> map) {
    return MopSelectionEntity(
      tpmt3Id: map['tpmt3Id'] as String,
      tpmt1Id: map['tpmt1Id'] as String,
      mopAlias: map['mopAlias'] as String,
      bankCharge:
          map['bankCharge'] != null ? map['bankCharge'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MopSelectionEntity.fromJson(String source) =>
      MopSelectionEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MopSelectionEntity(tpmt3Id: $tpmt3Id, tpmt1Id: $tpmt1Id, mopAlias: $mopAlias, bankCharge: $bankCharge)';
  }

  @override
  bool operator ==(covariant MopSelectionEntity other) {
    if (identical(this, other)) return true;

    return other.tpmt3Id == tpmt3Id &&
        other.tpmt1Id == tpmt1Id &&
        other.mopAlias == mopAlias &&
        other.bankCharge == bankCharge;
  }

  @override
  int get hashCode {
    return tpmt3Id.hashCode ^
        tpmt1Id.hashCode ^
        mopAlias.hashCode ^
        bankCharge.hashCode;
  }
}
