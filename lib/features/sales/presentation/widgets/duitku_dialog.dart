import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/features/sales/data/data_sources/remote/duitku_service.dart';
import 'package:pos_fe/features/sales/domain/entities/duitku_entity.dart';
import 'package:pos_fe/features/sales/presentation/widgets/duitku_expired_dialog.dart';

class DuitkuDialog extends StatefulWidget {
  final DuitkuEntity data;

  final void Function(String status) onPaymentSuccess;
  const DuitkuDialog({super.key, required this.data, required this.onPaymentSuccess});

  @override
  State<DuitkuDialog> createState() => _DuitkuDialogState();
}

class _DuitkuDialogState extends State<DuitkuDialog> {
  bool isCheckingStatus = false;
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  @override
  void initState() {
    super.initState();
    _startCheckDuitkuStatus();
    log("bankDetails - ${widget.data.bankVADetails}");
  }

  @override
  void dispose() {
    isCheckingStatus = false;
    super.dispose();
  }

  void _startCheckDuitkuStatus() async {
    setState(() {
      isCheckingStatus = true;
    });

    for (int i = 0; i < 5; i++) {
      if (!mounted) break;

      String status = '';
      await Future.delayed(const Duration(seconds: 3), () async {
        status = await _checkDuitkuStatus();
      });

      if (status == 'SUCCESS') {
        widget.onPaymentSuccess(status);
        break;
      }

      if (status == 'EXPIRED') {
        if (mounted) {
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return const DuitkuExpiredDialog();
              });
        }
        break;
      }
    }

    if (mounted) {
      setState(() {
        isCheckingStatus = false;
      });
    }
  }

  Future<String> _checkDuitkuStatus() async {
    if (!mounted) return "";
    final signature = await GetIt.instance<DuitkuApi>().createCheckStatusSignature(widget.data.merchantOrderId);
    final paymentStatus =
        await GetIt.instance<DuitkuApi>().checkVAPaymentStatus(signature, widget.data.merchantOrderId);
    return paymentStatus['statusMessage'];
  }

  Future<void> _manualCheckDuitkuStatus() async {
    try {
      setState(() {
        isCheckingStatus = true;
      });
      if (!mounted) return;

      String status = '';
      await Future.delayed(const Duration(seconds: 3), () async {
        status = await _checkDuitkuStatus();
      });

      if (status == 'SUCCESS') {
        widget.onPaymentSuccess(status);
        return;
      }

      if (status == 'EXPIRED') {
        if (mounted) {
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return const DuitkuExpiredDialog();
              });
        }
        return;
      }

      if (mounted) {
        setState(() {
          isCheckingStatus = false;
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      node: _focusScopeNode,
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event.runtimeType == KeyUpEvent) return KeyEventResult.handled;

        if (event.physicalKey == PhysicalKeyboardKey.f12) {
          _manualCheckDuitkuStatus();
          return KeyEventResult.handled;
        } else if (event.physicalKey == PhysicalKeyboardKey.escape) {
          context.pop();
          return KeyEventResult.handled;
        } else if (event.physicalKey == PhysicalKeyboardKey.f9) {
          return KeyEventResult.handled;
        }

        return KeyEventResult.ignored;
      },
      child: AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
        title: Container(
          decoration: const BoxDecoration(
            color: ProjectColors.primary,
            borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
          ),
          padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Duitku Payment',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ],
          ),
        ),
        titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        contentPadding: const EdgeInsets.all(0),
        content: SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Text("Amount - ${widget.data.amount}"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Payment Method"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          widget.data.bankVADetails['paymentImage'].endsWith(".SVG")
                              ? SvgPicture.network(
                                  widget.data.bankVADetails['paymentImage'],
                                  width: 30,
                                  height: 30,
                                )
                              : Image.network(
                                  widget.data.bankVADetails['paymentImage'],
                                  width: 75,
                                  height: 50,
                                ),
                        ],
                      )
                    ],
                  ),
                  SelectableText("VANumber - ${widget.data.vaNumber}"),
                  Text("Reference - ${widget.data.reference}"),
                  Text("Created - ${widget.data.createdTs}"),
                  Text("Expired - ${widget.data.expiredTs}"),
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
                        borderRadius: BorderRadius.circular(5), side: const BorderSide(color: ProjectColors.primary))),
                    backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                    overlayColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary.withOpacity(.2))),
                onPressed: () {
                  context.pop(false);
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
              Expanded(
                child: TextButton(
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => isCheckingStatus ? Colors.grey : ProjectColors.primary),
                      overlayColor: MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
                  onPressed: isCheckingStatus ? null : () async => await _manualCheckDuitkuStatus(),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        !isCheckingStatus
                            ? const SizedBox(
                                width: 13,
                              )
                            : const SizedBox.shrink(),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "Check Status",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: isCheckingStatus ? ProjectColors.lightBlack : Colors.white,
                                  )),
                              TextSpan(
                                  text: "  (F12)",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: isCheckingStatus ? ProjectColors.lightBlack : Colors.white,
                                  )),
                            ],
                          ),
                          overflow: TextOverflow.clip,
                        ),
                        isCheckingStatus
                            ? const SizedBox(
                                width: 10,
                              )
                            : const SizedBox(
                                width: 13,
                              ),
                        isCheckingStatus
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  color: ProjectColors.lightBlack,
                                ))
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
