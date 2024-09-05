// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DownPaymentEntity {
  final String? toinvDocId;
  final double amount;

  DownPaymentEntity({
    this.toinvDocId,
    required this.amount,
  });

  DownPaymentEntity copyWith({
    String? toinvDocId,
    double? amount,
  }) {
    return DownPaymentEntity(
      toinvDocId: toinvDocId ?? this.toinvDocId,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'toinvDocId': toinvDocId,
      'amount': amount,
    };
  }

  factory DownPaymentEntity.fromMap(Map<String, dynamic> map) {
    return DownPaymentEntity(
      toinvDocId: map['toinvDocId'] != null ? map['toinvDocId'] as String : null,
      amount: map['amount'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory DownPaymentEntity.fromJson(String source) =>
      DownPaymentEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'DownPaymentEntity(toinvDocId: $toinvDocId, amount: $amount)';

  @override
  bool operator ==(covariant DownPaymentEntity other) {
    if (identical(this, other)) return true;

    return other.toinvDocId == toinvDocId && other.amount == amount;
  }

  @override
  int get hashCode => toinvDocId.hashCode ^ amount.hashCode;
}
