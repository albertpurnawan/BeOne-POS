import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/features/sales/data/data_sources/remote/netzme_service.dart';
import 'package:pos_fe/features/sales/domain/entities/netzme_entity.dart';
import 'package:pos_fe/features/sales/presentation/widgets/qris_expired_dialog.dart';

class QRISDialog extends StatefulWidget {
  final NetzMeEntity data;
  final String accessToken;
  final void Function(String status) onPaymentSuccess;

  const QRISDialog({
    Key? key,
    required this.data,
    required this.accessToken,
    required this.onPaymentSuccess,
  }) : super(key: key);

  @override
  State<QRISDialog> createState() => _QRISDialogState();
}

class _QRISDialogState extends State<QRISDialog> {
  bool isCheckingStatus = false;

  @override
  void initState() {
    super.initState();
    _startCheckQRISStatus();
  }

  @override
  void dispose() {
    isCheckingStatus = false;
    super.dispose();
  }

  void _startCheckQRISStatus() async {
    setState(() {
      isCheckingStatus = true;
    });

    for (int i = 0; i < 36; i++) {
      String status = '';
      await Future.delayed(const Duration(seconds: 5), () async {
        status = await _checkQRISStatus();
        dev.log("status - $status");
      });
      if (status == 'paid') {
        widget.onPaymentSuccess(status);
        break;
      }
      if (status == 'expired') {
        if (mounted) {
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return const QRISExpiredDialog();
              });
        }
        break;
      }
    }

    setState(() {
      isCheckingStatus = false;
    });
  }

  Uint8List base64Decode(String str) {
    final decoder = base64.decoder;
    return decoder.convert(str);
  }

  String generateRandomString(int length) {
    const characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(
      length,
      (_) => characters.codeUnitAt(random.nextInt(characters.length)),
    ));
  }

  Future<String> _checkQRISStatus() async {
    final netzme = await GetIt.instance<AppDatabase>().netzmeDao.readAll();
    final url = netzme[0].url;
    final clientKey = netzme[0].clientKey;
    final clientSecret = netzme[0].clientSecret;
    final privateKey = netzme[0].privateKey;
    final bodyDetail = {
      "originalPartnerReferenceNo": widget.data.trxId,
      "additionalInfo": {"partnerReferenceNo": generateRandomString(10)}
    };
    final serviceSignature = await GetIt.instance<NetzmeApi>()
        .createSignatureService(
            url,
            clientKey,
            clientSecret,
            privateKey,
            widget.accessToken,
            "api-invoice/v1.0/transaction-history-detail",
            bodyDetail);

    final paymentStatus = await GetIt.instance<NetzmeApi>().checkPaymentStatus(
      url,
      clientKey,
      privateKey,
      serviceSignature,
      bodyDetail,
    );
    return paymentStatus;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      title: Container(
        decoration: const BoxDecoration(
          color: ProjectColors.primary,
          borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
        ),
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
        child: const Text(
          'QRIS Payment',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      contentPadding: const EdgeInsets.all(0),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.7,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Pay Before: ${Helpers.dateYYYYmmDD(widget.data.expiredTs)}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: ProjectColors.mediumBlack,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: ProjectColors.green,
                    borderRadius: BorderRadius.circular(36.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
                    child: Text(
                      "Total Payment: Rp ${Helpers.parseMoney(widget.data.totalAmount)}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Image.memory(
                  base64Decode(widget.data.qrImage),
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.5,
                ),
                Text("Nmid: ${widget.data.nmid}"),
                Text("TerminalId: ${widget.data.terminalId}"),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        Row(
          children: [
            Expanded(
                child: TextButton(
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(color: ProjectColors.primary))),
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.white),
                  overlayColor: MaterialStateColor.resolveWith(
                      (states) => ProjectColors.primary.withOpacity(.2))),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Center(
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "Cancel",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                        text: "  (Esc)",
                        style: TextStyle(fontWeight: FontWeight.w300),
                      ),
                    ],
                    style: TextStyle(color: ProjectColors.primary),
                  ),
                  overflow: TextOverflow.clip,
                ),
              ),
            )),
            const SizedBox(width: 10),
          ],
        ),
      ],
    );
  }
}
