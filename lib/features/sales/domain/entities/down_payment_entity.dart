// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DownPaymentEntity {
  final String? refpos2;
  final String? toinvDocId;
  final double amount;

  DownPaymentEntity({
    this.refpos2,
    this.toinvDocId,
    required this.amount,
  });

  DownPaymentEntity copyWith({
    String? refpos2,
    String? toinvDocId,
    double? amount,
  }) {
    return DownPaymentEntity(
      refpos2: refpos2 ?? this.refpos2,
      toinvDocId: toinvDocId ?? this.toinvDocId,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'refpos2': refpos2,
      'toinvDocId': toinvDocId,
      'amount': amount,
    };
  }

  factory DownPaymentEntity.fromMap(Map<String, dynamic> map) {
    return DownPaymentEntity(
      refpos2: map['refpos2'] != null ? map['refpos2'] as String : null,
      toinvDocId: map['toinvDocId'] != null ? map['toinvDocId'] as String : null,
      amount: map['amount'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory DownPaymentEntity.fromJson(String source) =>
      DownPaymentEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'DownPaymentEntity(refpos2: $refpos2, toinvDocId: $toinvDocId, amount: $amount)';

  @override
  bool operator ==(covariant DownPaymentEntity other) {
    if (identical(this, other)) return true;

    return other.refpos2 == refpos2 && other.toinvDocId == toinvDocId && other.amount == amount;
  }

  @override
  int get hashCode => refpos2.hashCode ^ toinvDocId.hashCode ^ amount.hashCode;
}
