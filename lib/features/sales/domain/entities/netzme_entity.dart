// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class NetzMeEntity {
  final String responseMessage;
  final String paymentUrl;
  final String qrImage;
  final String trxId;
  final String terminalId;
  final String nmid;
  final int feeAmount;
  final int totalAmount;
  final String createdTs;
  final String expiredTs;

  NetzMeEntity({
    required this.responseMessage,
    required this.paymentUrl,
    required this.qrImage,
    required this.trxId,
    required this.terminalId,
    required this.nmid,
    required this.feeAmount,
    required this.totalAmount,
    required this.createdTs,
    required this.expiredTs,
  });

  NetzMeEntity copyWith({
    String? responseMessage,
    String? paymentUrl,
    String? qrImage,
    String? trxId,
    String? terminalId,
    String? nmid,
    int? feeAmount,
    int? totalAmount,
    String? createdTs,
    String? expiredTs,
  }) {
    return NetzMeEntity(
      responseMessage: responseMessage ?? this.responseMessage,
      paymentUrl: paymentUrl ?? this.paymentUrl,
      qrImage: qrImage ?? this.qrImage,
      trxId: trxId ?? this.trxId,
      terminalId: terminalId ?? this.terminalId,
      nmid: nmid ?? this.nmid,
      feeAmount: feeAmount ?? this.feeAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      createdTs: createdTs ?? this.createdTs,
      expiredTs: expiredTs ?? this.expiredTs,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'responseMessage': responseMessage,
      'paymentUrl': paymentUrl,
      'qrImage': qrImage,
      'trxId': trxId,
      'terminalId': terminalId,
      'nmid': nmid,
      'feeAmount': feeAmount,
      'totalAmount': totalAmount,
      'createdTs': createdTs,
      'expiredTs': expiredTs,
    };
  }

  factory NetzMeEntity.fromMap(Map<String, dynamic> map) {
    return NetzMeEntity(
      responseMessage: map['responseMessage'] as String,
      paymentUrl: map['paymentUrl'] as String,
      qrImage: map['qrImage'] as String,
      trxId: map['trxId'] as String,
      terminalId: map['terminalId'] as String,
      nmid: map['nmid'] as String,
      feeAmount: map['feeAmount'] as int,
      totalAmount: map['totalAmount'] as int,
      createdTs: map['createdTs'] as String,
      expiredTs: map['expiredTs'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NetzMeEntity.fromJson(String source) =>
      NetzMeEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NetzMeEntity(responseMessage: $responseMessage, paymentUrl: $paymentUrl, qrImage: $qrImage, trxId: $trxId, terminalId: $terminalId, nmid: $nmid, feeAmount: $feeAmount, totalAmount: $totalAmount, createdTs: $createdTs, expiredTs: $expiredTs)';
  }

  @override
  bool operator ==(covariant NetzMeEntity other) {
    if (identical(this, other)) return true;

    return other.responseMessage == responseMessage &&
        other.paymentUrl == paymentUrl &&
        other.qrImage == qrImage &&
        other.trxId == trxId &&
        other.terminalId == terminalId &&
        other.nmid == nmid &&
        other.feeAmount == feeAmount &&
        other.totalAmount == totalAmount &&
        other.createdTs == createdTs &&
        other.expiredTs == expiredTs;
  }

  @override
  int get hashCode {
    return responseMessage.hashCode ^
        paymentUrl.hashCode ^
        qrImage.hashCode ^
        trxId.hashCode ^
        terminalId.hashCode ^
        nmid.hashCode ^
        feeAmount.hashCode ^
        totalAmount.hashCode ^
        createdTs.hashCode ^
        expiredTs.hashCode;
  }
}
