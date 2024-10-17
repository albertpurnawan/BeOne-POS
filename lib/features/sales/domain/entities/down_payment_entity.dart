// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DownPaymentEntity {
  final String? refpos2;
  final String? toinvDocId;
  final double amount;
  final String? refpos3;

  DownPaymentEntity({
    this.refpos2,
    this.toinvDocId,
    required this.amount,
    this.refpos3,
  });

  DownPaymentEntity copyWith({
    String? refpos2,
    String? toinvDocId,
    double? amount,
    String? refpos3,
  }) {
    return DownPaymentEntity(
      refpos2: refpos2 ?? this.refpos2,
      toinvDocId: toinvDocId ?? this.toinvDocId,
      amount: amount ?? this.amount,
      refpos3: refpos3 ?? this.refpos3,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'refpos2': refpos2,
      'toinvDocId': toinvDocId,
      'amount': amount,
      'refpos3': refpos3,
    };
  }

  factory DownPaymentEntity.fromMap(Map<String, dynamic> map) {
    return DownPaymentEntity(
      refpos2: map['refpos2'] != null ? map['refpos2'] as String : null,
      toinvDocId: map['toinvDocId'] != null ? map['toinvDocId'] as String : null,
      amount: map['amount'] as double,
      refpos3: map['refpos3'] != null ? map['refpos3'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DownPaymentEntity.fromJson(String source) =>
      DownPaymentEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DownPaymentEntity(refpos2: $refpos2, toinvDocId: $toinvDocId, amount: $amount, refpos3: $refpos3)';
  }

  @override
  bool operator ==(covariant DownPaymentEntity other) {
    if (identical(this, other)) return true;

    return other.refpos2 == refpos2 &&
        other.toinvDocId == toinvDocId &&
        other.amount == amount &&
        other.refpos3 == refpos3;
  }

  @override
  int get hashCode {
    return refpos2.hashCode ^ toinvDocId.hashCode ^ amount.hashCode ^ refpos3.hashCode;
  }
}
