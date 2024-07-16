// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:pos_fe/core/resources/receipt_printer.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/core/utilities/helpers.dart';

class PrintQrisUseCase implements UseCase<void, PrintQrisPaymentUsecaseParams> {
  // POS Parameter
  final ReceiptPrinter _receiptPrinter;

  PrintQrisUseCase(this._receiptPrinter);

  @override
  Future<void> call({PrintQrisPaymentUsecaseParams? params}) async {
    try {
      if (params == null) {
        return;
      }

      await _receiptPrinter.printQrisPayment(PrintQrisPaymentDetail(
          expiredTime: Helpers.dateYYYYmmDD(params.expiredTime),
          totalPayment: Helpers.parseMoney(params.totalPayment),
          qrImage: params.qrImage,
          // qrImage: base64Decode(params.qrImage),
          nmid: params.nmid,
          terminalId: params.terminalId));
    } catch (e) {
      rethrow;
    }
  }
}

class PrintQrisPaymentUsecaseParams {
  final String expiredTime;
  final int totalPayment;
  final Uint8List qrImage;
  final String nmid;
  final String terminalId;

  PrintQrisPaymentUsecaseParams({
    required this.expiredTime,
    required this.totalPayment,
    required this.qrImage,
    required this.nmid,
    required this.terminalId,
  });
}

class PrintQrisPaymentDetail {
  final String expiredTime;
  final String totalPayment;
  final Uint8List qrImage;
  final String nmid;
  final String terminalId;

  PrintQrisPaymentDetail({
    required this.expiredTime,
    required this.totalPayment,
    required this.qrImage,
    required this.nmid,
    required this.terminalId,
  });
}
