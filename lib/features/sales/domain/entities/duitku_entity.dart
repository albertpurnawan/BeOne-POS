// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pos_fe/features/sales/domain/entities/duitku_va_details.dart';

class DuitkuEntity {
  final String merchantCode;
  final String merchantOrderId;
  final String paymentUrl;
  final String vaNumber;
  final String reference;
  final int amount;
  final int feeAmount;
  final String responseMessage;
  final String createdTs;
  final String expiredTs;
  final DuitkuVADetailsEntity duitkuVA;

  DuitkuEntity({
    required this.merchantCode,
    required this.merchantOrderId,
    required this.paymentUrl,
    required this.vaNumber,
    required this.reference,
    required this.amount,
    required this.feeAmount,
    required this.responseMessage,
    required this.createdTs,
    required this.expiredTs,
    required this.duitkuVA,
  });

  DuitkuEntity copyWith({
    String? merchantCode,
    String? merchantOrderId,
    String? paymentUrl,
    String? vaNumber,
    String? reference,
    int? amount,
    int? feeAmount,
    String? responseMessage,
    String? createdTs,
    String? expiredTs,
    DuitkuVADetailsEntity? duitkuVA,
  }) {
    return DuitkuEntity(
      merchantCode: merchantCode ?? this.merchantCode,
      merchantOrderId: merchantOrderId ?? this.merchantOrderId,
      paymentUrl: paymentUrl ?? this.paymentUrl,
      vaNumber: vaNumber ?? this.vaNumber,
      reference: reference ?? this.reference,
      amount: amount ?? this.amount,
      feeAmount: feeAmount ?? this.feeAmount,
      responseMessage: responseMessage ?? this.responseMessage,
      createdTs: createdTs ?? this.createdTs,
      expiredTs: expiredTs ?? this.expiredTs,
      duitkuVA: duitkuVA ?? this.duitkuVA,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'merchantCode': merchantCode,
      'merchantOrderId': merchantOrderId,
      'paymentUrl': paymentUrl,
      'vaNumber': vaNumber,
      'reference': reference,
      'amount': amount,
      'feeAmount': feeAmount,
      'responseMessage': responseMessage,
      'createdTs': createdTs,
      'expiredTs': expiredTs,
      'duitkuVA': duitkuVA.toMap(),
    };
  }

  factory DuitkuEntity.fromMap(Map<String, dynamic> map) {
    return DuitkuEntity(
      merchantCode: map['merchantCode'] as String,
      merchantOrderId: map['merchantOrderId'] as String,
      paymentUrl: map['paymentUrl'] as String,
      vaNumber: map['vaNumber'] as String,
      reference: map['reference'] as String,
      amount: map['amount'] as int,
      feeAmount: map['feeAmount'] as int,
      responseMessage: map['responseMessage'] as String,
      createdTs: map['createdTs'] as String,
      expiredTs: map['expiredTs'] as String,
      duitkuVA: DuitkuVADetailsEntity.fromMap(map['duitkuVA'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory DuitkuEntity.fromJson(String source) => DuitkuEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DuitkuEntity(merchantCode: $merchantCode, merchantOrderId: $merchantOrderId, paymentUrl: $paymentUrl, vaNumber: $vaNumber, reference: $reference, amount: $amount, feeAmount: $feeAmount, responseMessage: $responseMessage, createdTs: $createdTs, expiredTs: $expiredTs, duitkuVA: $duitkuVA)';
  }

  @override
  bool operator ==(covariant DuitkuEntity other) {
    if (identical(this, other)) return true;

    return other.merchantCode == merchantCode &&
        other.merchantOrderId == merchantOrderId &&
        other.paymentUrl == paymentUrl &&
        other.vaNumber == vaNumber &&
        other.reference == reference &&
        other.amount == amount &&
        other.feeAmount == feeAmount &&
        other.responseMessage == responseMessage &&
        other.createdTs == createdTs &&
        other.expiredTs == expiredTs &&
        other.duitkuVA == duitkuVA;
  }

  @override
  int get hashCode {
    return merchantCode.hashCode ^
        merchantOrderId.hashCode ^
        paymentUrl.hashCode ^
        vaNumber.hashCode ^
        reference.hashCode ^
        amount.hashCode ^
        feeAmount.hashCode ^
        responseMessage.hashCode ^
        createdTs.hashCode ^
        expiredTs.hashCode ^
        duitkuVA.hashCode;
  }
}
