// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/number_input_formatter.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/core/widgets/progress_indicator.dart';
import 'package:pos_fe/features/dual_screen/services/send_data_window_service.dart';
import 'package:pos_fe/features/login/presentation/pages/keyboard_widget.dart';
import 'package:pos_fe/features/sales/data/data_sources/remote/duitku_service.dart';
import 'package:pos_fe/features/sales/data/data_sources/remote/invoice_service.dart';
import 'package:pos_fe/features/sales/data/data_sources/remote/netzme_service.dart';
import 'package:pos_fe/features/sales/data/models/user.dart';
import 'package:pos_fe/features/sales/domain/entities/currency.dart';
import 'package:pos_fe/features/sales/domain/entities/down_payment_entity.dart';
import 'package:pos_fe/features/sales/domain/entities/duitku_entity.dart';
import 'package:pos_fe/features/sales/domain/entities/duitku_va_details.dart';
import 'package:pos_fe/features/sales/domain/entities/mop_selection.dart';
import 'package:pos_fe/features/sales/domain/entities/netzme_entity.dart';
import 'package:pos_fe/features/sales/domain/entities/payment_type.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';
import 'package:pos_fe/features/sales/domain/entities/vouchers_selection.dart';
import 'package:pos_fe/features/sales/domain/repository/mop_selection_repository.dart';
import 'package:pos_fe/features/sales/domain/usecases/apply_manual_rounding.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_store_master.dart';
import 'package:pos_fe/features/sales/domain/usecases/print_receipt.dart';
import 'package:pos_fe/features/sales/presentation/cubit/mop_selections_cubit.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';
import 'package:pos_fe/features/sales/presentation/widgets/approval_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/confirm_reset_vouchers_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/discount_and_rounding_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/duitku_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/edc_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/input_duitku_va_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/input_mop_amount.dart';
import 'package:pos_fe/features/sales/presentation/widgets/promotion_summary_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/qris_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/rounding_up_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/voucher_redeem_dialog.dart';
import 'package:pos_fe/features/settings/data/data_sources/remote/duitku_va_list_service.dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class MopType {
  final String name;
  final List<String> payTypeCodes;

  MopType({required this.name, required this.payTypeCodes});
}

class CheckoutDialog extends StatefulWidget {
  final bool? isCharged;
  const CheckoutDialog({super.key, this.isCharged});

  @override
  State<CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<CheckoutDialog> {
  bool isPrinting = false;
  bool isCharged = false;
  bool isLoadingQRIS = false;
  bool isLoadingDuitku = false;
  bool isCharging = false;
  bool isMultiMOPs = true;
  bool isConnected = true;
  bool _isRoundedUp = false;
  bool _isRoundedDown = false;
  double? _originalValue;
  int cancelCount = 0;
  List<PaymentTypeEntity> paymentType = [];
  final FocusNode _keyboardListenerFocusNode = FocusNode();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  bool _showKeyboard = true;
  bool _currentNumericMode = true;
  bool _isDropdownShown = false;
  final FocusNode _keyboardFocusNode = FocusNode();
  final GlobalKey _iconButtonKey = GlobalKey();

  void _toggleKeyboard() {
    if (_isDropdownShown) {
      setState(() {
        _showKeyboard = !_showKeyboard;
      });
    } else {
      _showDropdown();
    }
  }

  void _showDropdown() async {
    final RenderBox renderBox =
        _iconButtonKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    await showMenu(
      context: context,
      surfaceTintColor: Colors.transparent,
      color: const Color.fromARGB(255, 245, 245, 245),
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + renderBox.size.height,
        offset.dx + renderBox.size.width,
        offset.dy,
      ),
      items: [
        const PopupMenuItem(
          value: "Alphanumeric",
          child: Text("Alphanumeric"),
        ),
        const PopupMenuItem(
          value: "Numeric",
          child: Text("Numeric"),
        ),
        const PopupMenuItem(
          value: "Off",
          child: Text("Off"),
        ),
      ],
    ).then((value) {
      if (value != null) {
        switch (value) {
          case 'Off':
            setState(() {
              _showKeyboard = false;
            });
            break;
          case 'Alphanumeric':
            setState(() {
              _showKeyboard = true;
              _currentNumericMode = false;
            });
            break;
          case 'Numeric':
            setState(() {
              _showKeyboard = true;
              _currentNumericMode = true;
            });
            break;
          default:
            setState(() {
              _showKeyboard = true;
            });
            break;
        }
      }
    });
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

  Future<void> _checkConnection() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      setState(() {
        isConnected = false;
        SnackBarHelper.presentErrorSnackBar(context,
            "No internet connection detected. Please check your network settings and try again");
      });
    } else if (connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet) ||
        connectivityResult.contains(ConnectivityResult.mobile)) {
      setState(() {
        isConnected = true;
      });
    }
  }

  void showQRISDialog(
      BuildContext context, NetzMeEntity data, String accessToken) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return QRISDialog(
          data: data,
          accessToken: accessToken,
          onPaymentSuccess: (String status) async {
            if (status == 'SUCCESS') {
              await context.read<ReceiptCubit>().charge();

              await Future.delayed(const Duration(milliseconds: 200), () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                showDialog(
                    context: context,
                    builder: (context) {
                      return const CheckoutDialog(
                        isCharged: true,
                      );
                    });
              });
            }
          },
        );
      },
    );
  }

  void showDuitkuDialog(
      BuildContext context, DuitkuEntity data, String docnumDuitku) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return DuitkuDialog(
              data: data,
              docnumDuitku: docnumDuitku,
              onPaymentSuccess: (String status) async {
                if (status == 'PAID') {
                  try {
                    await context.read<ReceiptCubit>().charge();
                  } catch (e) {
                    dev.log("Error during charge: $e");
                  }

                  await Future.delayed(const Duration(milliseconds: 200), () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    showDialog(
                        context: context,
                        builder: (context) {
                          return const CheckoutDialog(
                            isCharged: true,
                          );
                        });
                  });
                }
              });
        });
  }

  Future<void> charge() async {
    try {
      setState(() {
        isCharging = true;
      });
      final ReceiptEntity state = context.read<ReceiptCubit>().state;
      dev.log("state - --- ${state.receiptItems}");

      // Validate total payment must be greater than grand total
      if (state.grandTotal >= 0
          ? (state.totalPayment ?? 0) < state.grandTotal
          : (state.totalPayment ?? 0) > state.grandTotal) {
        setState(() {
          isCharging = false;
        });
        throw "Insufficient payment";
      }

      if (state.grandTotal < 0 &&
          ((state.totalPayment ?? 0) - state.grandTotal).abs() > 1) {
        setState(() {
          isCharging = false;
        });
        throw "Refund must match grand total";
      }

      // Trigger approval when grand total is 0
      if (state.grandTotal == 0) {
        final bool? isAuthorized = await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (context) => const ApprovalDialog());
        if (isAuthorized != true) {
          setState(() {
            isCharging = false;
          });
          return;
        }
      }

      // Show QRIS/ DUITKU HERE
      final selectedMOPs = state.mopSelections;
      final invoiceDocNum = state.docNum;

      final List<MopSelectionEntity> qrisMop =
          selectedMOPs.where((element) => element.payTypeCode == '5').toList();
      final List<MopSelectionEntity> duitkuMop = selectedMOPs
          .where((element) => element.mopAlias == 'duitku')
          .toList();
      final String duitkuTs =
          DateFormat('yyyyMMddHHmmss').format(DateTime.now());
      final String merchantOrderId =
          duitkuTs + Helpers.generateRandomString(10);

      if (qrisMop.isNotEmpty) {
        setState(() {
          isLoadingQRIS = true;
        });
        final topos =
            await GetIt.instance<AppDatabase>().posParameterDao.readAll();
        final tostr = await GetIt.instance<AppDatabase>()
            .storeMasterDao
            .readByDocId(topos[0].tostrId!, null);
        if (tostr == null) {
          throw Exception("Store data not found.");
        }
        final url = tostr.netzmeUrl;
        final clientKey = tostr.netzmeClientKey;
        final clientSecret = tostr.netzmeClientSecret;
        final privateKey = tostr.netzmeClientPrivateKey;
        final channelId = tostr.netzmeChannelId;

        if (url == null ||
            clientKey == null ||
            clientSecret == null ||
            privateKey == null ||
            channelId == null) {
          setState(() {
            isLoadingQRIS = false;
            isCharging = false;
          });
          throw Exception(
              "Missing required Netzme data. Please check Store data.");
        }

        final signature = await GetIt.instance<NetzmeApi>()
            .createSignature(url, clientKey, privateKey);

        final accessToken = await GetIt.instance<NetzmeApi>()
            .requestAccessToken(url, clientKey, privateKey, signature);

        final bodyDetail = {
          "custIdMerchant": tostr.netzmeCustidMerchant,
          "partnerReferenceNo":
              invoiceDocNum + tostr.otpChannel! + generateRandomString(5),
          "amount": {
            "value": Helpers.revertMoneyToString(qrisMop.first.amount!),
            "currency": "IDR"
          }, // value grandtotal idr
          "amountDetail": {
            "basicAmount": {
              "value": Helpers.revertMoneyToString(qrisMop.first.amount!),
              "currency": "IDR"
            }, // total semua item
            "shippingAmount": {"value": "0", "currency": "IDR"}
          },
          "PayMethod": "QRIS", // constant
          "commissionPercentage": "0",
          "expireInSecond": "3600",
          "feeType": "on_seller",
          "apiSource": "topup_deposit",
          "additionalInfo": {
            "email": "testabc@gmail.com", // diambil dari customer kalau member
            "notes": "desc",
            "description": "description",
            "phoneNumber":
                "+6285270427851", // diambil dari customer kalau member
            "imageUrl": "a",
            "fullname": "Tester 213@" // diambil dari customer kalau member
          }
        };
        final serviceSignature = await GetIt.instance<NetzmeApi>()
            .createSignatureService(url, clientKey, clientSecret, privateKey,
                accessToken, "api/v1.0/invoice/create-transaction", bodyDetail);

        final transactionQris =
            await GetIt.instance<NetzmeApi>().createTransactionQRIS(
          url,
          clientKey,
          clientSecret,
          privateKey,
          serviceSignature,
          channelId,
          bodyDetail,
        );
        // dev.log("transactionQris - $transactionQris");

        setState(() {
          isLoadingQRIS = false;
        });

        showQRISDialog(context, transactionQris, accessToken);
      } else if (duitkuMop.isNotEmpty) {
        setState(() {
          isLoadingDuitku = true;
        });

        final duitkuAmount = (duitkuMop.first.amount ?? 0).toInt();
        final duitkuSignature = await GetIt.instance<DuitkuApi>()
            .createTransactionSignature(duitkuAmount, merchantOrderId);

        final custId = state.customerEntity?.docId;
        final docnumDuitku = const Uuid().v4();
        final duitkuVA = await GetIt.instance<DuitkuApi>().createTransactionVA(
            (duitkuMop.first.cardHolder ?? ""),
            duitkuSignature,
            duitkuAmount,
            (custId ?? ""),
            merchantOrderId,
            docnumDuitku);
        final topos = await GetIt.instance<GetPosParameterUseCase>().call();
        if (topos == null) throw "POS Parameter not found";
        final store = await GetIt.instance<AppDatabase>()
            .storeMasterDao
            .readByDocId(topos.tostrId ?? "", null);
        if (store == null) throw "Store Parameter not found";

        setState(() {
          isLoadingDuitku = false;
        });

        final String createdTs = Helpers.dateddMMMyyyyHHmmss(DateTime.now());
        final String expiredTs = Helpers.dateddMMMyyyyHHmmss(DateTime.now()
            .add(Duration(minutes: store.duitkuExpiryPeriod ?? 60)));

        DuitkuVADetailsEntity vaDuitku = DuitkuVADetailsEntity(
          docId: duitkuMop.first.tpmt7Id ?? "",
          paymentMethod: duitkuMop.first.cardHolder ?? "",
          paymentName: duitkuMop.first.cardName ?? "",
          paymentImage: duitkuMop.first.edcDesc ?? "",
          totalFee: int.parse(duitkuMop.first.tpmt7Id ?? "0"),
          statusActive: int.parse(duitkuMop.first.tpmt7Id ?? "0"),
        );

        DuitkuEntity duitku = DuitkuEntity(
          merchantCode: duitkuVA['data']['merchantCode'].toString(),
          merchantOrderId: merchantOrderId,
          paymentUrl: duitkuVA['data']['paymentUrl'].toString(),
          vaNumber: duitkuVA['data']['vaNumber'].toString(),
          reference: duitkuVA['data']['reference'].toString(),
          amount: duitkuAmount,
          feeAmount: 0,
          responseMessage: duitkuVA['data']['statusMessage'].toString(),
          createdTs: createdTs,
          expiredTs: expiredTs,
          duitkuVA: vaDuitku,
        );

        dev.log("duitku - $duitku");
        await _checkConnection();
        if (isConnected == false) {
          SnackBarHelper.presentFailSnackBar(context,
              "No internet connection detected. Please check your network settings and try again");
          return;
        }
        showDuitkuDialog(context, duitku, docnumDuitku);
      } else {
        await context.read<ReceiptCubit>().charge();
        await Future.delayed(const Duration(milliseconds: 200), () {
          setState(() {
            isCharged = true;
          });
        });
      }
      setState(() {
        isCharging = false;
      });
      await _sendToDisplay();
    } catch (e) {
      SnackBarHelper.presentFailSnackBar(context, e.toString());
      return;
    }
  }

  Future<void> _sendToDisplay() async {
    try {
      if (await GetIt.instance<GetPosParameterUseCase>().call() != null &&
          (await GetIt.instance<GetPosParameterUseCase>().call())!
                  .customerDisplayActive ==
              0) {
        return;
      }
      final windows = await DesktopMultiWindow.getAllSubWindowIds();
      if (windows.isEmpty) {
        debugPrint('No display window found');
        return;
      }
      final windowId = windows[0];
      final state = context.read<ReceiptCubit>().state;

      // Calculate total payment and change
      final List<MopSelectionEntity> mopSelections = state.mopSelections;
      final double totalPayment =
          mopSelections.fold(0.0, (sum, mop) => sum + (mop.amount ?? 0));
      final double grandTotal = state.grandTotal;
      final double changed =
          totalPayment > grandTotal ? totalPayment - grandTotal : 0.0;

      final Map<String, dynamic> data = {
        'docNum': state.docNum,
        'grandTotal': grandTotal,
        'transDateTime': state.transDateTime?.toIso8601String(),
        'totalPayment': totalPayment,
        'changed': changed,
        'mopSelections': mopSelections
            .map((mop) => {
                  'mopAlias': mop.mopAlias,
                  'amount': mop.amount,
                  'payTypeCode': mop.payTypeCode,
                  'cardName': mop.cardName,
                  'tpmt2Id': mop.tpmt2Id,
                  'tpmt3Id': mop.tpmt3Id,
                  'tpmt1Id': mop.tpmt1Id,
                  'description': mop.description,
                  'subType': mop.subType,
                })
            .toList(),
        'customerName': state.customerEntity?.custName ?? 'NON MEMBER',
        'items': state.receiptItems.map((item) {
          final totalDiscount = item.promos.fold(
              0.0,
              (sum, promo) =>
                  sum +
                  ((item.itemEntity.includeTax == 1)
                      ? (-1 * promo.discAmount!) *
                          ((100 + item.itemEntity.taxRate) / 100)
                      : (-1 * promo.discAmount!)));
          return {
            'name': item.itemEntity.itemName,
            'quantity': item.quantity.toInt(),
            'discount': Helpers.parseMoney(totalDiscount.round()),
            'total': item.totalAmount,
          };
        }).toList(),
      };

      final jsonData = jsonEncode(data);
      debugPrint("Sending data to display from checkout2: $jsonData");
      final sendingData = await sendData(
          windowId, jsonData, 'updateTransactionSuccess', 'Checkout');

      debugPrint("Send result: $sendingData");
    } catch (e, stackTrace) {
      print('Error send data to client display from sales: $e');
      print('Stacktrace: $stackTrace');
    }
  }

  Future<void> printDraftBill() async {
    try {
      setState(() {
        isPrinting = true;
      });
      await Future.delayed(Durations.extralong1, null);
      await GetIt.instance<PrintReceiptUseCase>().call(
          params: PrintReceiptUseCaseParams(
              printType: 2, receiptEntity: context.read<ReceiptCubit>().state));
      setState(() {
        isPrinting = false;
      });
    } catch (e) {
      setState(() {
        isPrinting = false;
      });
      SnackBarHelper.presentFailSnackBar(context, "Failed to print draft bill");
    }
  }

  Future<void> showAppliedPromotions() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => PromotionSummaryDialog(
              receiptEntity: context.read<ReceiptCubit>().state,
            ));

    _keyboardListenerFocusNode.requestFocus();
  }

  Future<void> showDiscountAndRoundingDialog(BuildContext childContext) async {
    try {
      final ReceiptItemEntity? dpItem = context
          .read<ReceiptCubit>()
          .state
          .receiptItems
          .where((e) => e.itemEntity.barcode == "99")
          .firstOrNull;
      if (dpItem != null && dpItem.quantity > 0) {
        throw "Discount or Rounding cannot be applied on Receive DP";
      }

      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => DiscountAndRoundingDialog(
                docnum: context.read<ReceiptCubit>().state.docNum,
                manualRounded: _isRoundedDown || _isRoundedUp,
              )).then((value) {
        if (value != null) {
          SnackBarHelper.presentSuccessSnackBar(
              childContext, "Discount Applied", 3);
        }
      });
    } catch (e) {
      SnackBarHelper.presentErrorSnackBar(context, e.toString());
    }
  }

  Future<void> showRoundUpDialog(BuildContext childContext) async {
    try {
      final ReceiptItemEntity? dpItem = context
          .read<ReceiptCubit>()
          .state
          .receiptItems
          .where((e) => e.itemEntity.barcode == "99")
          .firstOrNull;
      if (dpItem != null && dpItem.quantity > 0) {
        throw "Rounding cannot be applied on Receive DP";
      }

      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const RoundingUpDialog()).then((value) {
        if (value != null && value == true) {
          SnackBarHelper.presentSuccessSnackBar(
              childContext, "Rounding Applied", 3);
          setState(() {
            _isRoundedUp = true;
            _isRoundedDown = false;
          });
        } else if (value == false) {
          setState(() {
            _isRoundedUp = false;
            _isRoundedDown = false;
          });
        }
      });
    } catch (e) {
      SnackBarHelper.presentErrorSnackBar(context, e.toString());
    }
  }

  Future<void> toggleMultiMOPs() async {
    setState(() {
      isMultiMOPs = !isMultiMOPs;
    });
  }

  Future<void> manualRounding(RoundingMode mode) async {
    try {
      final cubit = context.read<ReceiptCubit>();
      final ReceiptItemEntity? dpItem = cubit.state.receiptItems
          .where((e) => e.itemEntity.barcode == "99")
          .firstOrNull;
      if (dpItem != null && dpItem.quantity > 0) {
        throw "Rounding cannot be applied on Receive DP";
      }

      final double beforeRounding = cubit.state.subtotal -
          (cubit.state.discAmount ?? 0) -
          cubit.state.couponDiscount +
          cubit.state.taxAmount;

      _originalValue ??= beforeRounding;

      if (mode == RoundingMode.down) {
        if (_isRoundedDown) {
          cubit.resetRounding(_originalValue!);
          setState(() {
            _isRoundedUp = false;
            _isRoundedDown = false;
          });
        } else if (_isRoundedUp) {
          cubit.resetRounding(_originalValue!);
          setState(() {
            _isRoundedUp = false;
            _isRoundedDown = false;
          });
        } else {
          await cubit.applyManualRounding(RoundingMode.down, null);
          setState(() {
            _isRoundedDown = true;
            _isRoundedUp = false;
          });
        }
      } else if (mode == RoundingMode.up) {
        if (_isRoundedUp) {
          return;
        } else if (_isRoundedDown) {
          cubit.resetRounding(_originalValue!);
          setState(() {
            _isRoundedUp = false;
            _isRoundedDown = false;
          });
        } else {
          await cubit.applyManualRounding(RoundingMode.up, null);
          setState(() {
            _isRoundedUp = true;
            _isRoundedDown = false;
          });
        }
      }
    } catch (e) {}
  }

  @override
  void initState() {
    getDefaultKeyboardPOSParameter();
    super.initState();
    isCharged = widget.isCharged ?? false;
    if (context.read<ReceiptCubit>().state.grandTotal <= 0) isMultiMOPs = false;
  }

  @override
  void dispose() {
    _keyboardListenerFocusNode.dispose();
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  Future<void> getDefaultKeyboardPOSParameter() async {
    try {
      final POSParameterEntity? posParameterEntity =
          await GetIt.instance<GetPosParameterUseCase>().call();
      if (posParameterEntity == null) throw "Failed to retrieve POS Parameter";
      setState(() {
        _showKeyboard =
            (posParameterEntity.defaultShowKeyboard == 0) ? false : true;
      });
    } catch (e) {
      if (mounted) {
        SnackBarHelper.presentFailSnackBar(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (childContext) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: FocusScope(
          // skipTraversal: true,
          onKeyEvent: (node, event) {
            if (event.runtimeType == KeyUpEvent) return KeyEventResult.handled;

            if (event.physicalKey == PhysicalKeyboardKey.f12 && !isCharged) {
              charge();
              return KeyEventResult.handled;
            } else if (event.physicalKey == PhysicalKeyboardKey.f12 &&
                isCharged) {
              isCharged = false;
              Navigator.of(context).pop();
              context.read<ReceiptCubit>().resetReceipt();
              return KeyEventResult.handled;
            } else if (event.physicalKey == PhysicalKeyboardKey.escape &&
                !isCharged) {
              context.pop();
              return KeyEventResult.handled;
            } else if (event.physicalKey == PhysicalKeyboardKey.arrowDown &&
                node.hasPrimaryFocus) {
              node.nextFocus();
              return KeyEventResult.handled;
            } else if (event.physicalKey == PhysicalKeyboardKey.f4 &&
                !isCharged) {
              manualRounding(RoundingMode.down);
              return KeyEventResult.handled;
            } else if (event.physicalKey == PhysicalKeyboardKey.f5 &&
                !isCharged) {
              showRoundUpDialog(childContext);
              return KeyEventResult.handled;
            } else if (event.physicalKey == PhysicalKeyboardKey.f6 &&
                !isCharged) {
              showDiscountAndRoundingDialog(childContext);
              setState(() {
                _isRoundedUp = false;
                _isRoundedDown = false;
                _originalValue = null;
              });
              return KeyEventResult.handled;
            } else if (event.physicalKey == PhysicalKeyboardKey.f7 &&
                !isCharged) {
              showAppliedPromotions()
                  .then((value) => _focusScopeNode.requestFocus());
              return KeyEventResult.handled;
            } else if (event.physicalKey == PhysicalKeyboardKey.f8 &&
                !isCharged) {
              printDraftBill();
              return KeyEventResult.handled;
            } else if (event.physicalKey == PhysicalKeyboardKey.f9 &&
                !isCharged) {
              toggleMultiMOPs();
              return KeyEventResult.handled;
            }

            return KeyEventResult.ignored;
          },
          node: _focusScopeNode,
          autofocus: true,
          child: AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            title: ExcludeFocusTraversal(
              child: Container(
                decoration: const BoxDecoration(
                  color: ProjectColors.primary,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(5.0)),
                ),
                padding: const EdgeInsets.fromLTRB(25, 5, 10, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Checkout',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    isCharged
                        ? const SizedBox.shrink()
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              OutlinedButton(
                                focusNode: FocusNode(skipTraversal: true),
                                style: OutlinedButton.styleFrom(
                                  elevation: 5,
                                  shadowColor: Colors.black87,
                                  backgroundColor: ProjectColors.primary,
                                  padding: const EdgeInsets.all(10),
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                                onPressed: () async {
                                  await manualRounding(RoundingMode.down);
                                },
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.arrow_downward_outlined,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    RichText(
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Round \nDown",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          TextSpan(
                                            text: " (F4)",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                        style:
                                            TextStyle(height: 1, fontSize: 12),
                                      ),
                                      overflow: TextOverflow.clip,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              OutlinedButton(
                                focusNode: FocusNode(skipTraversal: true),
                                style: OutlinedButton.styleFrom(
                                  elevation: 5,
                                  shadowColor: Colors.black87,
                                  backgroundColor: ProjectColors.primary,
                                  padding: const EdgeInsets.all(10),
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                                onPressed: () async {
                                  await showRoundUpDialog(childContext);
                                },
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.arrow_upward_outlined,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    RichText(
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Round \nUp",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          TextSpan(
                                            text: " (F5)",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                        style:
                                            TextStyle(height: 1, fontSize: 12),
                                      ),
                                      overflow: TextOverflow.clip,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              OutlinedButton(
                                focusNode: FocusNode(skipTraversal: true),
                                style: OutlinedButton.styleFrom(
                                  elevation: 5,
                                  shadowColor: Colors.black87,
                                  backgroundColor: ProjectColors.primary,
                                  padding: const EdgeInsets.all(10),
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                                onPressed: () async {
                                  await showDiscountAndRoundingDialog(
                                      childContext);
                                  setState(() {
                                    _isRoundedUp = false;
                                    _isRoundedDown = false;
                                    _originalValue = null;
                                  });
                                },
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.cut,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    RichText(
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Disc.\n",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          TextSpan(
                                            text: "(F6)",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                        style:
                                            TextStyle(height: 1, fontSize: 12),
                                      ),
                                      overflow: TextOverflow.clip,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              OutlinedButton(
                                focusNode: FocusNode(skipTraversal: true),
                                style: OutlinedButton.styleFrom(
                                  elevation: 5,
                                  shadowColor: Colors.black87,
                                  backgroundColor: ProjectColors.primary,
                                  padding: const EdgeInsets.all(10),
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                                onPressed: () async =>
                                    await showAppliedPromotions(),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.discount_outlined,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    RichText(
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Applied\nPromos",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          TextSpan(
                                            text: " (F7)",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                        style:
                                            TextStyle(height: 1, fontSize: 12),
                                      ),
                                      overflow: TextOverflow.clip,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  elevation: 5,
                                  shadowColor: Colors.black87,
                                  backgroundColor: ProjectColors.primary,
                                  padding: const EdgeInsets.all(10),
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                                onPressed: () async => await printDraftBill(),
                                child: isPrinting
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator
                                            .adaptive())
                                    : Row(
                                        children: [
                                          const Icon(
                                            Icons.print_outlined,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          RichText(
                                            text: const TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "Print\nOrder",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                TextSpan(
                                                  text: "(F8)",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ],
                                              style: TextStyle(
                                                  height: 1, fontSize: 12),
                                            ),
                                            overflow: TextOverflow.clip,
                                          ),
                                        ],
                                      ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Row(
                                children: [
                                  Switch(
                                      thumbIcon: MaterialStatePropertyAll(Icon(
                                        isMultiMOPs ? Icons.check : Icons.close,
                                        color: isMultiMOPs
                                            ? ProjectColors.green
                                            : ProjectColors.lightBlack,
                                      )),
                                      trackOutlineWidth:
                                          const MaterialStatePropertyAll(0),
                                      value: isMultiMOPs,
                                      onChanged: (value) => setState(() {
                                            isMultiMOPs = value;
                                          })),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: "Multi MOPs\n",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300),
                                        ),
                                        TextSpan(
                                          text: isMultiMOPs ? "ON" : "OFF",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                        const TextSpan(
                                          text: " (F9)",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                      style: const TextStyle(
                                          height: 1, fontSize: 12),
                                    ),
                                    overflow: TextOverflow.clip,
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: _showKeyboard
                                      ? const Color.fromARGB(255, 110, 0, 0)
                                      : ProjectColors.primary,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(360)),
                                ),
                                child: IconButton(
                                  key: _iconButtonKey,
                                  focusColor:
                                      const Color.fromARGB(255, 110, 0, 0),
                                  focusNode: _keyboardFocusNode,
                                  icon: Icon(
                                    _showKeyboard
                                        ? Icons.keyboard_hide_outlined
                                        : Icons.keyboard_outlined,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    _toggleKeyboard();
                                  },
                                  tooltip: 'Toggle Keyboard',
                                ),
                              ),
                            ],
                          )
                  ],
                ),
              ),
            ),
            titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            contentPadding: const EdgeInsets.all(0),
            content: isCharged
                ? const _CheckoutSuccessDialogContent()
                : isCharging
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: progressDialog,
                      )
                    : CheckoutDialogContent(
                        isMultiMOPs: isMultiMOPs,
                        showKeyboard: _showKeyboard,
                        keyboardNumeric: _currentNumericMode,
                      ),
            actions: isCharged
                ? [
                    Column(
                      children: [
                        // Row(
                        //   children: [
                        //     Expanded(
                        //         child: TextButton(
                        //       style: ButtonStyle(
                        //           shape: MaterialStatePropertyAll(
                        //               RoundedRectangleBorder(
                        //                   borderRadius: BorderRadius.circular(5),
                        //                   side: const BorderSide(
                        //                       color: ProjectColors.primary))),
                        //           backgroundColor: MaterialStateColor.resolveWith(
                        //               (states) => Colors.white),
                        //           overlayColor: MaterialStateColor.resolveWith(
                        //               (states) => Colors.black.withOpacity(.2))),
                        //       onPressed: () {
                        //         // Navigator.of(context).pop();
                        //       },
                        //       child: const Center(
                        //           child: Text(
                        //         "Send Receipt",
                        //         style: TextStyle(color: ProjectColors.primary),
                        //       )),
                        //     )),
                        //     const SizedBox(
                        //       width: 10,
                        //     ),
                        //     Expanded(
                        //         child: TextButton(
                        //       style: ButtonStyle(
                        //           shape: MaterialStatePropertyAll(
                        //               RoundedRectangleBorder(
                        //                   borderRadius: BorderRadius.circular(5),
                        //                   side: const BorderSide(
                        //                       color: ProjectColors.primary))),
                        //           backgroundColor: MaterialStateColor.resolveWith(
                        //               (states) => Colors.white),
                        //           overlayColor: MaterialStateColor.resolveWith(
                        //               (states) => Colors.black.withOpacity(.2))),
                        //       onPressed: () {
                        //         GetIt.instance<PrintReceiptUseCase>()
                        //             .call(params: context.read<ReceiptCubit>().state);
                        //         // Navigator.of(context).pop();
                        //       },
                        //       child: const Center(
                        //           child: Text(
                        //         "Print Receipt",
                        //         style: TextStyle(color: ProjectColors.primary),
                        //       )),
                        //     )),
                        //   ],
                        // ),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        TextButton(
                          style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => ProjectColors.primary),
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white.withOpacity(.2))),
                          onPressed: () async {
                            isCharged = false;
                            Navigator.of(context).pop();
                            final windows =
                                await DesktopMultiWindow.getAllSubWindowIds();
                            if (windows.isEmpty) {
                              debugPrint('No display window found');
                              return;
                            }
                            final windowId = windows[0];
                            context.read<ReceiptCubit>().resetReceipt();
                            final Map<String, dynamic> data = {
                              'done': true,
                            };

                            final jsonData = jsonEncode(data);
                            debugPrint(
                                "Sending data to display from sales: $jsonData");
                            final sendingData = await sendData(
                                windowId,
                                jsonData,
                                'updateTransactionSuccessDone',
                                'Checkout');
                          },
                          child: Center(
                            child: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Done",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  TextSpan(
                                    text: "  (F12)",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ),
                      ],
                    )
                  ]
                : <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                            child: TextButton(
                          style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side: const BorderSide(
                                          color: ProjectColors.primary))),
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white),
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.black.withOpacity(.2))),
                          onPressed: isCharging
                              ? null
                              : () async {
                                  if (context
                                      .read<ReceiptCubit>()
                                      .state
                                      .vouchers
                                      .isNotEmpty) {
                                    final bool? isProceed =
                                        await showDialog<bool>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) =>
                                          const ConfirmResetVouchersDialog(),
                                    );
                                    if (isProceed == null) return;
                                    if (!isProceed) return;
                                  }

                                  try {
                                    final String cashierName =
                                        GetIt.instance<SharedPreferences>()
                                                .getString("username") ??
                                            "";
                                    final UserModel? user =
                                        await GetIt.instance<AppDatabase>()
                                            .userDao
                                            .readByUsername(cashierName, null);
                                    List<DownPaymentEntity> dpList = context
                                            .read<ReceiptCubit>()
                                            .state
                                            .downPayments ??
                                        [];
                                    List<String> docnumList = [];
                                    if (dpList.isNotEmpty) {
                                      for (DownPaymentEntity dp in dpList) {
                                        if (dp.isSelected == true &&
                                            dp.isReceive == false) {
                                          docnumList.add(dp.refpos2 ?? "");
                                        }
                                      }

                                      if (user != null) {
                                        String checkLock =
                                            await GetIt.instance<InvoiceApi>()
                                                .unlockInvoice(
                                                    user.docId, docnumList);
                                        if (checkLock !=
                                            'Unlock Down Payment success') {
                                          setState(() {
                                            cancelCount++;
                                          });
                                          SnackBarHelper.presentErrorSnackBar(
                                              context,
                                              "Please check your connection and try again ($cancelCount/3)");

                                          if (cancelCount >= 3) {
                                            setState(() {
                                              cancelCount = 0;
                                            });
                                            Future.delayed(Durations.extralong4,
                                                () {
                                              SnackBarHelper.presentErrorSnackBar(
                                                  context,
                                                  "Down Payment disabled $docnumList");
                                              context.pop(false);
                                            });
                                          }
                                          return;
                                        }
                                      }
                                    }
                                  } catch (e) {
                                    return;
                                  }
                                  setState(() {
                                    cancelCount = 0;
                                    _isRoundedUp = false;
                                    _isRoundedDown = false;
                                    _originalValue = null;
                                  });
                                  context.pop(false);
                                },
                          child: Center(
                            child: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Cancel",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  TextSpan(
                                    text: "  (Esc)",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300),
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
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                              TextButton(
                                style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5))),
                                    backgroundColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => ProjectColors.primary),
                                    overlayColor:
                                        MaterialStateColor.resolveWith(
                                            (states) =>
                                                Colors.white.withOpacity(.2))),
                                onPressed: isCharging
                                    ? null
                                    : isLoadingQRIS
                                        ? null
                                        : () async {
                                            await charge();
                                            setState(() {
                                              _isRoundedUp = false;
                                              _isRoundedDown = false;
                                              _originalValue = null;
                                            });
                                          },
                                child: Center(
                                  child: isLoadingQRIS
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator
                                              .adaptive(
                                                  // backgroundColor: Colors.white,
                                                  ),
                                        )
                                      : RichText(
                                          text: const TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "Paid",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              TextSpan(
                                                text: "  (F12)",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ],
                                          ),
                                          overflow: TextOverflow.clip,
                                        ),
                                ),
                              )
                            ])),
                      ],
                    ),
                  ],
            actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          ),
        ),
      );
    });
  }
}

class CheckoutDialogContent extends StatefulWidget {
  const CheckoutDialogContent({
    Key? key,
    required this.isMultiMOPs,
    required this.showKeyboard,
    required this.keyboardNumeric,
  }) : super(key: key);
  final bool isMultiMOPs;
  final bool showKeyboard;
  final bool keyboardNumeric;

  @override
  State<CheckoutDialogContent> createState() => _CheckoutDialogContentState();
}

class _CheckoutDialogContentState extends State<CheckoutDialogContent> {
  double chipCount = 0;
  List<MopSelectionEntity> _values = [];
  int _vouchersAmount = 0;
  bool voucherIsExceedPurchase = false;
  List<PaymentTypeEntity> paymentTypes = [];
  bool isZeroGrandTotal = false;
  List<Widget> selectedVoucherChips = [];
  bool isQRISorVA = false;
  bool isConnected = true;

  final List<VouchersSelectionEntity> _vouchers = [];
  final _textEditingControllerCashAmount = TextEditingController();
  final _focusNodeCashAmount = FocusNode(
    onKeyEvent: (node, event) {
      if (event.runtimeType == KeyUpEvent) return KeyEventResult.handled;

      if (event.physicalKey == PhysicalKeyboardKey.arrowDown &&
          node.hasPrimaryFocus) {
        node.nextFocus();
        return KeyEventResult.handled;
      }

      return KeyEventResult.ignored;
    },
  );

  String currencyName = "";
  late final StreamSubscription<ReceiptEntity> _grandTotalSubs;

  bool _showKeyboardContent = true;
  bool _shiftEnabled = false;
  bool _keyboardNumeric = false;

  @override
  void initState() {
    super.initState();
    context.read<MopSelectionsCubit>().getMopSelections();
    getPaymentTypes();
    // getCurrencyName();
    checkAndHandleZeroGrandTotal();
    refreshQRISChip();
    _grandTotalSubs = context.read<ReceiptCubit>().stream.listen((event) {
      checkAndHandleZeroGrandTotal();
    });
    setState(() {
      _showKeyboardContent = widget.showKeyboard;
      _keyboardNumeric = widget.keyboardNumeric;
    });
  }

  @override
  void dispose() {
    _textEditingControllerCashAmount.dispose();
    _focusNodeCashAmount.dispose();
    _grandTotalSubs.cancel();
    super.dispose();
  }

  Future<void> _checkConnection() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      setState(() {
        isConnected = false;
      });
    } else if (connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet) ||
        connectivityResult.contains(ConnectivityResult.mobile)) {
      setState(() {
        isConnected = true;
      });
    }
  }

  void getCurrencyName() async {
    try {
      final POSParameterEntity? posParameterEntity =
          await GetIt.instance<GetPosParameterUseCase>().call();
      if (posParameterEntity == null) return;
      final StoreMasterEntity? storeMasterEntity =
          await GetIt.instance<GetStoreMasterUseCase>()
              .call(params: posParameterEntity.tostrId);
      if (storeMasterEntity == null) return;
      if (storeMasterEntity.tcurrId == null) return;
      final CurrencyEntity? currencyEntity = await GetIt.instance<AppDatabase>()
          .currencyDao
          .readByDocId(storeMasterEntity.tcurrId!, null);
      if (currencyEntity == null) return;

      setState(() {
        currencyName = "${currencyEntity.curCode} ";
      });
    } catch (e) {
      dev.log(e.toString());
    }
  }

  Widget _selectedMopChip(MopSelectionEntity mop, int color, int index) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(
            spreadRadius: 0.5,
            blurRadius: 5,
            color: Color.fromRGBO(0, 0, 0, 0.222),
          ),
        ],
        color: color == 1
            ? const Color.fromARGB(255, 11, 57, 84)
            // : const Color.fromARGB(255, 255, 102, 99),
            : const Color.fromARGB(255, 255, 149, 5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            (mop.cardName != null)
                ? "${mop.mopAlias} - ${mop.cardName}"
                : mop.mopAlias,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              // color: Colors.black,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Text(
            "$currencyName${Helpers.parseMoney(mop.amount ?? 0)}",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              // color: Colors.black,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: !isZeroGrandTotal
                ? () {
                    setState(() {
                      _values.removeAt(index);
                      if (mop.payTypeCode == "1") {
                        _textEditingControllerCashAmount.text = "";
                      }
                      if (mop.payTypeCode == "5" || mop.payTypeCode == "7") {
                        isQRISorVA = false;
                      }
                    });

                    updateReceiptMop();
                  }
                : null,
            child: const Icon(
              Icons.close,
              size: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> refreshQRISChip() async {
    final mopState = context.read<ReceiptCubit>().state.mopSelections;
    final filteredMopState =
        mopState.where((mop) => mop.payTypeCode == "1").toList();

    if (mopState.isEmpty) return;
    if (filteredMopState.isEmpty) {
      setState(() {
        _values = context.read<ReceiptCubit>().state.mopSelections;
      });
    } else {
      setState(() {
        _values = context.read<ReceiptCubit>().state.mopSelections;
        _textEditingControllerCashAmount.text =
            Helpers.parseMoney(filteredMopState[0].amount!.toInt());
      });
    }
  }

  Future<void> _refreshVouchersChips(
      List<VouchersSelectionEntity> vouchers, int color) async {
    final Map<String, num> amountByTpmt3Ids = {};
    final List<Widget> result = [];

    for (final voucher in vouchers) {
      if (amountByTpmt3Ids[voucher.tpmt3Id] == null) {
        amountByTpmt3Ids[voucher.tpmt3Id!] = voucher.voucherAmount;
      } else {
        amountByTpmt3Ids[voucher.tpmt3Id!] =
            amountByTpmt3Ids[voucher.tpmt3Id!]! + voucher.voucherAmount;
      }
    }

    for (final tpmt3Id in amountByTpmt3Ids.keys) {
      final MopSelectionEntity? mopSelectionEntity =
          await GetIt.instance<MopSelectionRepository>()
              .getMopSelectionByTpmt3Id(tpmt3Id);
      result.add(Container(
        padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
              spreadRadius: 0.5,
              blurRadius: 5,
              color: Color.fromRGBO(0, 0, 0, 0.222),
            ),
          ],
          color: color == 1
              ? const Color.fromARGB(255, 11, 57, 84)
              // : const Color.fromARGB(255, 255, 102, 99),
              : const Color.fromARGB(255, 255, 149, 5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              mopSelectionEntity?.mopAlias ?? "Unknown Voucher",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                // color: Colors.black,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              "$currencyName${Helpers.parseMoney(amountByTpmt3Ids[tpmt3Id]!)}",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                // color: Colors.black,
              ),
            ),
          ],
        ),
      ));
    }

    setState(() {
      selectedVoucherChips = result;
    });
  }

  void _onChangedCashAmountTextField(
      {required String value, required List<MopSelectionEntity> mopsByType}) {
    final double cashAmount = Helpers.revertMoneyToDecimalFormat(value);

    if (cashAmount == double.negativeInfinity) return;

    if (cashAmount == 0) {
      setState(() {
        _values = (widget.isMultiMOPs
            ? _values.where((e) => e.tpmt3Id != mopsByType[0].tpmt3Id).toList()
            : <MopSelectionEntity>[]);
      });
      updateReceiptMop();
      return;
    }

    setState(() {
      _values = (widget.isMultiMOPs
              ? _values
                  .where((e) => e.tpmt3Id != mopsByType[0].tpmt3Id)
                  .toList()
              : <MopSelectionEntity>[]) +
          [mopsByType[0].copyWith(amount: cashAmount)];
    });
    updateReceiptMop();
  }

  void _onTapCashAmountTextFieldSuffix(
      {required List<MopSelectionEntity> mopsByType}) {
    setState(() {
      _values = (widget.isMultiMOPs
          ? _values.where((e) => e.tpmt3Id != mopsByType[0].tpmt3Id).toList()
          : <MopSelectionEntity>[]);
    });
    _textEditingControllerCashAmount.text = "";
    updateReceiptMop();
  }

  bool _isSelectedCashAmountSuggestion(
      {required List<MopSelectionEntity> mopsByType,
      required int index,
      required List<int> cashAmountSuggestions}) {
    return _values
        .where((e) =>
            e.tpmt3Id == mopsByType[0].tpmt3Id &&
            e.amount == cashAmountSuggestions[index])
        .isNotEmpty;
  }

  void _onSelectedCashAmountSuggestion(
      {required bool selected,
      required List<MopSelectionEntity> mopsByType,
      required int index,
      required List<int> cashAmountSuggestions}) {
    if (voucherIsExceedPurchase) return;
    setState(() {
      if (selected) {
        _values = widget.isMultiMOPs
            ? _values
                    .where((e) => e.tpmt3Id != mopsByType[0].tpmt3Id)
                    .toList() +
                [
                  mopsByType[0]
                      .copyWith(amount: cashAmountSuggestions[index].toDouble())
                ]
            : <MopSelectionEntity>[] +
                [
                  mopsByType[0]
                      .copyWith(amount: cashAmountSuggestions[index].toDouble())
                ];
        _textEditingControllerCashAmount.text =
            Helpers.parseMoney(cashAmountSuggestions[index]);
      } else {
        _values =
            _values.where((e) => e.tpmt3Id != mopsByType[0].tpmt3Id).toList();
        _textEditingControllerCashAmount.text = "";
      }
      updateReceiptMop();
    });
  }

  bool _isSelectedEDCMOP({
    required MopSelectionEntity mop,
  }) {
    return _values.map((e) => e.tpmt4Id).contains(mop.tpmt4Id);
  }

  Future<void> _onSelectedEDCMOP({
    required bool selected,
    required ReceiptEntity receipt,
    required MopSelectionEntity mop,
    required List<MopSelectionEntity> filteredMops,
  }) async {
    if (voucherIsExceedPurchase) return;

    double? mopAmount = 0;
    if (selected) {
      if (widget.isMultiMOPs) {
        if ((receipt.totalPayment ?? 0).abs() >= receipt.grandTotal.abs()) {
          return;
        }
        mopAmount = await showDialog<double>(
          context: context,
          barrierDismissible: false,
          builder: (context) => EDCDialog(
            onEDCSelected: (mopEDC) {
              setState(() {
                _values = _values + [mopEDC];
              });
            },
            onEDCRemoved: (mopEDC) {
              setState(() {
                _values.removeWhere((item) => item == mopEDC);
              });
            },
            mopSelectionEntity: mop,
            values: filteredMops,
            max: receipt.grandTotal - (receipt.totalPayment ?? 0),
            isMultiMOPs: true,
          ),
        );
      } else {
        mopAmount = await showDialog<double>(
          context: context,
          barrierDismissible: false,
          builder: (context) => EDCDialog(
            onEDCSelected: (mopEDC) {
              setState(() {
                _values = [mopEDC];
                // _values = _values.toList() + [mopEDC];
              });
              // dev.log("values2 - $_values");
              // dev.log("mopEDC not Multi - $mopEDC");
            },
            onEDCRemoved: (mopEDC) {
              setState(() {
                _values.removeWhere((item) => item == mopEDC);
              });
            },
            mopSelectionEntity: mop,
            values: filteredMops,
            max: receipt.grandTotal - (receipt.totalVoucher ?? 0),
            isMultiMOPs: false,
          ),
        );
      }

      if (!widget.isMultiMOPs) {
        _textEditingControllerCashAmount.text = "";
      }
    } else {
      if (widget.isMultiMOPs) {
        if ((receipt.totalPayment ?? 0).abs() >= receipt.grandTotal.abs()) {
          return;
        }
        // dev.log("filteredMops - $filteredMops");
        mopAmount = await showDialog<double>(
          context: context,
          barrierDismissible: false,
          builder: (context) => EDCDialog(
            onEDCSelected: (mopEDC) {
              setState(() {
                _values = _values.toList() + [mopEDC];
                // dev.log("mopEDC Multi - $mopEDC");
                // dev.log("values - $_values");
              });
            },
            onEDCRemoved: (mopEDC) {
              setState(() {
                _values.removeWhere((item) => item == mopEDC);
              });
            },
            mopSelectionEntity: mop,
            values: filteredMops,
            max: receipt.grandTotal - (receipt.totalPayment ?? 0),
            isMultiMOPs: true,
          ),
        );
      } else {
        mopAmount = await showDialog<double>(
          context: context,
          barrierDismissible: false,
          builder: (context) => EDCDialog(
            onEDCSelected: (mopEDC) {
              setState(() {
                _values = [mopEDC];
                // _values = _values.toList() + [mopEDC];
              });
              // dev.log("values2 - $_values");
              // dev.log("mopEDC not Multi - $mopEDC");
            },
            onEDCRemoved: (mopEDC) {
              setState(() {
                _values.removeWhere((item) => item == mopEDC);
              });
            },
            mopSelectionEntity: mop,
            values: filteredMops,
            max: receipt.grandTotal - (receipt.totalVoucher ?? 0),
            isMultiMOPs: false,
          ),
        );
      }
    }

    setState(() {});
    updateReceiptMop();
  }

  bool _isSelectedOtherMOP({
    required PaymentTypeEntity paymentType,
    required ReceiptEntity receipt,
    required MopSelectionEntity mop,
  }) {
    return paymentType.payTypeCode == "6"
        ? receipt.vouchers.map((e) => e.tpmt3Id).contains(mop.tpmt3Id)
        : _values.map((e) => e.tpmt3Id).contains(mop.tpmt3Id);
  }

  Future<void> _onSelectedOtherMOP({
    required bool selected,
    required PaymentTypeEntity paymentType,
    required ReceiptEntity receipt,
    required MopSelectionEntity mop,
  }) async {
    // VOUCHERS DIALOG HERE
    if (paymentType.payTypeCode == "6") {
      if (receipt.customerEntity == null) {
        return SnackBarHelper.presentErrorSnackBar(context, "Null customer");
      }
      if (mop.subType == 3 && receipt.customerEntity!.custCode == "99") {
        return SnackBarHelper.presentErrorSnackBar(context, "Invalid customer");
      }
      await showDialog(
        context: context,
        builder: (BuildContext context) {
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
                'Redeem Voucher',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
            titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            contentPadding: const EdgeInsets.all(0),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.6,
              child: VoucherCheckout(
                onVouchersRedeemed: handleVouchersRedeemed,
                tpmt3Id: mop.tpmt3Id,
                voucherType: mop.subType,
              ),
            ),
          );
        },
      );
      setState(() {
        _textEditingControllerCashAmount.text = "";
        context.read<ReceiptCubit>().resetMop();
        _values = [];
      });
      return;
    }

    if (voucherIsExceedPurchase) return;

    if (selected) {
      if (paymentType.payTypeCode == '5' && isQRISorVA) {
        SnackBarHelper.presentErrorSnackBar(
            context, "Please choose either MOP QRIS or duitku, not both");
        return;
      }
      double? mopAmount = 0;
      if (widget.isMultiMOPs) {
        if ((receipt.totalPayment ?? 0).abs() >= receipt.grandTotal.abs()) {
          return;
        }
        mopAmount = await showDialog<double>(
          context: context,
          barrierDismissible: false,
          builder: (context) => InputMopAmountDialog(
            mopSelectionEntity: mop,
            max: receipt.grandTotal - (receipt.totalPayment ?? 0),
          ),
        );

        if (mopAmount != null && mopAmount != 0) {
          if (paymentType.payTypeCode == '5') {
            setState(() {
              isQRISorVA = true;
            });
          }
        } else {
          if (paymentType.payTypeCode == '5') {
            setState(() {
              isQRISorVA = false;
            });
          }
        }
      } else {
        mopAmount = receipt.grandTotal - (receipt.totalVoucher ?? 0);
      }

      if (mopAmount == null || mopAmount == 0) {
        return;
      }

      _values = (widget.isMultiMOPs
              ? _values.where((e) => e.tpmt3Id != mop.tpmt3Id).toList()
              : <MopSelectionEntity>[]) +
          [mop.copyWith(amount: mopAmount)];

      if (!widget.isMultiMOPs) {
        _textEditingControllerCashAmount.text = "";
      }
    } else {
      _values = _values.where((e) => e.tpmt3Id != mop.tpmt3Id).toList();
      if (paymentType.payTypeCode == '5') {
        setState(() {
          isQRISorVA = false;
        });
      }
    }

    setState(() {});
    updateReceiptMop();
  }

  List<int> generateCashAmountSuggestions(int targetAmount) {
    List<int> cashAmountSuggestions = [targetAmount];
    if (voucherIsExceedPurchase) {
      cashAmountSuggestions = [0];
    } else if (context.read<ReceiptCubit>().state.grandTotal > 0) {
      final List<int> multipliers = [5000, 10000, 50000, 100000];

      for (final multiplier in multipliers) {
        if (cashAmountSuggestions.last % multiplier != 0) {
          cashAmountSuggestions
              .add(targetAmount + multiplier - (targetAmount % multiplier));
        }
      }
    }
    return cashAmountSuggestions;
  }

  List<MopSelectionEntity> getMopByPayTypeCode(String payTypeCode) {
    /**
     * 1 - Tunai
     * 2 - EDC
     * 3 - ONLINE PAYMENT
     * 4 - OTHERS
     * 5 - QRIS
     * 6 - VOUCHER
    */

    List<MopSelectionEntity> mops = [];

    final List<MopSelectionEntity> temp = context
        .read<MopSelectionsCubit>()
        .state
        .where((element) => element.payTypeCode == payTypeCode)
        .toList();
    mops.addAll(temp);

    return mops;
  }

  Future<void> getPaymentTypes() async {
    final List<PaymentTypeEntity> paymentTypeEntities =
        await GetIt.instance<AppDatabase>().paymentTypeDao.readAll();
    setState(() {
      paymentTypes = paymentTypeEntities;
    });
    return;
  }

  void updateReceiptMop() async {
    context.read<ReceiptCubit>().updateMopSelection(
        mopSelectionEntities: _values.map((e) => e.copyWith()).toList());

    try {
      final windows = await DesktopMultiWindow.getAllSubWindowIds();
      if (windows.isEmpty) {
        debugPrint('No display window found');
        return;
      }
      final windowId = windows[0];
      final state = context.read<ReceiptCubit>().state;
      debugPrint('state checkout: ${state.changed}');
      final Map<String, dynamic> data = {
        'totalPayment': state.totalPayment == null
            ? 0
            : Helpers.parseMoney(state.totalPayment!.round()),
        'changed': state.changed == null
            ? 0
            : Helpers.parseMoney(voucherIsExceedPurchase
                ? 0
                : (state.totalPayment ?? 0) - state.grandTotal)
      };

      final jsonData = jsonEncode(data);
      debugPrint("Sending data to display from checkout: $jsonData");
      final sendingData =
          await sendData(windowId, jsonData, 'updateCheckoutData', 'Checkout');

      debugPrint("Send result: $sendingData");
    } catch (e, stackTrace) {
      print('Error send data to client display from checkout: $e');
    }
  }

  void handleVouchersRedeemed(List<VouchersSelectionEntity> vouchers) async {
    int totalVoucherAmount = 0;
    for (var voucher in vouchers) {
      totalVoucherAmount += voucher.voucherAmount;
    }

    setState(() {
      _vouchers.addAll(vouchers);
      _vouchersAmount += totalVoucherAmount;
    });
    context.read<ReceiptCubit>().updateVouchersSelection(
        vouchersSelectionEntity: _vouchers, vouchersAmount: _vouchersAmount);
    final receiptGrandTotal = context.read<ReceiptCubit>().state.grandTotal;
    final receiptTotalVouchers =
        context.read<ReceiptCubit>().state.totalVoucher;
    if (receiptTotalVouchers! >= receiptGrandTotal) {
      // dev.log("receiptTotal - $receiptGrandTotal");
      // dev.log("receiptTotalVouchers - $receiptTotalVouchers");
      setState(() {
        voucherIsExceedPurchase = true;
      });
    }

    await _refreshVouchersChips(context.read<ReceiptCubit>().state.vouchers, 2);
  }

  // void handleEDCSelected(MopSelectionEntity mop, EDCSelectionEntity edc) {}

  void checkAndHandleZeroGrandTotal() async {
    try {
      if (context.read<ReceiptCubit>().state.grandTotal != 0) {
        setState(() {
          isZeroGrandTotal = false;
        });
        return;
      }

      // Set state isZeroGrandTotal
      setState(() {
        isZeroGrandTotal = true;
      });

      // Set default MOP
      final MopSelectionEntity cashMopSelection =
          await GetIt.instance<MopSelectionRepository>().getCashMopSelection();
      setState(() {
        _values = [cashMopSelection.copyWith(amount: 0)];
      });
      updateReceiptMop();
    } catch (e) {
      // dev.log(e.toString());
      context.pop();
      setState(() {
        isZeroGrandTotal = false;
      });
      SnackBarHelper.presentFailSnackBar(context, e.toString());
    }
  }

  @override
  void didUpdateWidget(CheckoutDialogContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.showKeyboard != widget.showKeyboard) {
      setState(() {
        _showKeyboardContent = widget.showKeyboard;
      });
    }
    if (oldWidget.keyboardNumeric != widget.keyboardNumeric) {
      setState(() {
        _keyboardNumeric = widget.keyboardNumeric;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          fontFamily: 'Roboto',
          useMaterial3: true,
          chipTheme: const ChipThemeData(
              showCheckmark: true,
              checkmarkColor: Colors.white,
              backgroundColor: Colors.transparent,
              selectedColor: ProjectColors.primary,
              labelStyle: TextStyle(color: ChipLabelColor(), fontSize: 18))),
      child: BlocBuilder<MopSelectionsCubit, List<MopSelectionEntity>>(
        builder: (context, state) {
          return BlocBuilder<ReceiptCubit, ReceiptEntity>(
            builder: (context, receipt) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      // color: const Color.fromARGB(255, 86, 147, 99),
                      color: const Color.fromARGB(255, 231, 231, 231),

                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 60,
                            ),
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 35,
                                    ),
                                    const Text(
                                      "Grand Total",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "$currencyName${Helpers.parseMoney(context.read<ReceiptCubit>().state.grandTotal.round())}",
                                      style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 2, 0, 2),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          (receipt.rounding
                                                      .roundToDouble()
                                                      .abs() !=
                                                  0.0)
                                              ? _noteChip(
                                                  (receipt.rounding)
                                                      .roundToDouble(),
                                                  1)
                                              : const SizedBox.shrink(),
                                          (receipt.downPayments != null &&
                                                  receipt.downPayments!
                                                      .isNotEmpty &&
                                                  receipt.downPayments!.any(
                                                      (dp) =>
                                                          dp.isReceive ==
                                                              false &&
                                                          dp.isSelected ==
                                                              true))
                                              ? _noteChip(
                                                  (receipt.downPayments ?? [])
                                                      .fold(
                                                    0.0,
                                                    (total, dp) =>
                                                        (dp.isSelected ==
                                                                    true &&
                                                                dp.amount != 0)
                                                            ? total + dp.amount
                                                            : total,
                                                  ),
                                                  2)
                                              : const SizedBox.shrink(),
                                          (receipt.discHeaderManual ?? 0) != 0
                                              ? _noteChip(
                                                  (receipt.discHeaderManual ??
                                                      0),
                                                  3)
                                              : const SizedBox.shrink(),
                                          receipt.receiptItems.any((e1) =>
                                                  e1.promos.any((e2) =>
                                                      e2.promoType == 998))
                                              ? _noteChip(
                                                  receipt.receiptItems.fold(
                                                      0.0,
                                                      (previousValue, e1) =>
                                                          previousValue +
                                                          (((100 + e1.itemEntity.taxRate) /
                                                                  100) *
                                                              e1.promos.where((e2) => e2.promoType == 998).fold(
                                                                  0.0,
                                                                  (previousValue,
                                                                          e3) =>
                                                                      previousValue +
                                                                      (e3.discAmount ??
                                                                          0)))),
                                                  4)
                                              : const SizedBox.shrink(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 35,
                                    ),
                                    const Text(
                                      "Total Payment",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "$currencyName${Helpers.parseMoney(receipt.totalPayment ?? 0)}",
                                      style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Container(
                                      height: 35,
                                      alignment: Alignment.topCenter,
                                      child: receipt.grandTotal >= 0 &&
                                              receipt.grandTotal >
                                                  (receipt.totalVoucher ?? 0) +
                                                      (receipt.totalNonVoucher ??
                                                          0)
                                          ? Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons.warning_rounded,
                                                  size: 20,
                                                  // color: Color.fromARGB(255, 253, 185, 148),
                                                  color: ProjectColors.swatch,
                                                ),
                                                const SizedBox(
                                                  width: 7,
                                                ),
                                                Text(
                                                  "Due  $currencyName${Helpers.parseMoney((receipt.grandTotal.toInt()) - (receipt.totalVoucher ?? 0) - (receipt.totalNonVoucher ?? 0))}",
                                                  style: const TextStyle(
                                                      // color: Color.fromARGB(255, 253, 185, 148),
                                                      color:
                                                          ProjectColors.swatch,
                                                      fontSize: 16,
                                                      height: 1,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            )
                                          : receipt.grandTotal >= 0 &&
                                                  receipt.grandTotal -
                                                          (receipt.totalVoucher ??
                                                              0) -
                                                          (receipt.totalNonVoucher ??
                                                              0) <
                                                      0
                                              ? Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Icon(
                                                      Icons
                                                          .change_circle_rounded,
                                                      size: 20,
                                                      // color: Color.fromARGB(255, 253, 185, 148),
                                                      color:
                                                          ProjectColors.green,
                                                    ),
                                                    const SizedBox(
                                                      width: 7,
                                                    ),
                                                    Text(
                                                      "Change  $currencyName${Helpers.parseMoney(voucherIsExceedPurchase ? 0 : (receipt.totalPayment ?? 0) - receipt.grandTotal)}",
                                                      style: const TextStyle(
                                                          // color: Color.fromARGB(255, 253, 185, 148),
                                                          color: ProjectColors
                                                              .green,
                                                          fontSize: 16,
                                                          height: 1,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox.shrink(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 60,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      // color: const Color.fromARGB(255, 58, 104, 68),
                      color: const Color.fromARGB(255, 223, 223, 223),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Selected MOP",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                          if (receipt.mopSelections.isEmpty &&
                              receipt.vouchers.isEmpty)
                            const Text(
                              "Not set",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          Expanded(
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 5,
                              children: (receipt.mopSelections.isNotEmpty
                                      ? receipt.mopSelections
                                          .asMap()
                                          .entries
                                          .map((entry) => _selectedMopChip(
                                              entry.value, 1, entry.key))
                                          .toList()
                                      : <Widget>[const SizedBox.shrink()]) +
                                  (selectedVoucherChips.isNotEmpty
                                      ? selectedVoucherChips
                                      : <Widget>[const SizedBox.shrink()]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    isZeroGrandTotal
                        ? const SizedBox.shrink()
                        : const SizedBox(
                            height: 20,
                          ),
                    isZeroGrandTotal
                        ? const SizedBox.shrink()
                        : Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    // padding:
                                    //     const EdgeInsets.symmetric(horizontal: 20),
                                    child: FocusTraversalGroup(
                                      policy: WidgetOrderTraversalPolicy(),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: List<Widget>.generate(
                                          paymentTypes.length,
                                          (int index) {
                                            final paymentType =
                                                paymentTypes[index];
                                            final List<MopSelectionEntity>
                                                mopsByType =
                                                getMopByPayTypeCode(
                                                    paymentType.payTypeCode);

                                            if (mopsByType.isEmpty) {
                                              return const SizedBox.shrink();
                                            }

                                            // [START] UI for TUNAI MOP
                                            if (paymentType.payTypeCode[0] ==
                                                "1") {
                                              final MopSelectionEntity?
                                                  cashMopSelection = receipt
                                                      .mopSelections
                                                      .where((element) =>
                                                          element.payTypeCode ==
                                                          "1")
                                                      .firstOrNull;
                                              final double totalCash =
                                                  cashMopSelection == null
                                                      ? 0
                                                      : cashMopSelection
                                                          .amount!;
                                              final List<int>
                                                  cashAmountSuggestions =
                                                  generateCashAmountSuggestions((widget
                                                              .isMultiMOPs
                                                          ? receipt.grandTotal -
                                                              (receipt.totalPayment ??
                                                                  0) +
                                                              totalCash
                                                          : receipt.grandTotal -
                                                              (receipt.totalVoucher ??
                                                                  0))
                                                      .round());

                                              return Column(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 20),
                                                    width: double.infinity,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          paymentType
                                                              .description,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 15),
                                                        SizedBox(
                                                          // height: 50,
                                                          // width: 400,
                                                          child: TextField(
                                                            onSubmitted: (value) =>
                                                                _focusNodeCashAmount
                                                                    .requestFocus(),
                                                            focusNode:
                                                                _focusNodeCashAmount,
                                                            onTapOutside: (event) =>
                                                                _focusNodeCashAmount
                                                                    .unfocus(),
                                                            controller:
                                                                _textEditingControllerCashAmount,
                                                            onChanged: (value) =>
                                                                _onChangedCashAmountTextField(
                                                                    value:
                                                                        value,
                                                                    mopsByType:
                                                                        mopsByType),
                                                            inputFormatters: [
                                                              receipt.grandTotal >=
                                                                      0
                                                                  ? MoneyInputFormatter()
                                                                  : NegativeMoneyInputFormatter()
                                                            ],
                                                            keyboardType:
                                                                TextInputType
                                                                    .none,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        24,
                                                                    height: 1),
                                                            decoration:
                                                                InputDecoration(
                                                                    contentPadding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            5),
                                                                    hintText:
                                                                        "Cash Amount",
                                                                    hintStyle: const TextStyle(
                                                                        fontStyle:
                                                                            FontStyle
                                                                                .italic,
                                                                        fontSize:
                                                                            24,
                                                                        height:
                                                                            1),
                                                                    border:
                                                                        const OutlineInputBorder(),
                                                                    prefixIcon:
                                                                        const Icon(
                                                                      Icons
                                                                          .payments_outlined,
                                                                      size: 24,
                                                                    ),
                                                                    suffixIcon: _textEditingControllerCashAmount.text ==
                                                                            ""
                                                                        ? null
                                                                        : InkWell(
                                                                            onTap: () =>
                                                                                _onTapCashAmountTextFieldSuffix(mopsByType: mopsByType),
                                                                            child:
                                                                                const Icon(
                                                                              Icons.close,
                                                                              size: 24,
                                                                            ),
                                                                          )),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        Wrap(
                                                          spacing: 8,
                                                          runSpacing: 8,
                                                          children: List<
                                                              Widget>.generate(
                                                            cashAmountSuggestions
                                                                .length,
                                                            (int index) {
                                                              if (cashAmountSuggestions[
                                                                      index] ==
                                                                  0) {
                                                                return const SizedBox
                                                                    .shrink();
                                                              }
                                                              return ChoiceChip(
                                                                  side: const BorderSide(
                                                                      color: ProjectColors
                                                                          .primary,
                                                                      width:
                                                                          1.5),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          20),
                                                                  label: Text(Helpers
                                                                      .parseMoney(
                                                                          cashAmountSuggestions[
                                                                              index])),
                                                                  selected: _isSelectedCashAmountSuggestion(
                                                                      mopsByType:
                                                                          mopsByType,
                                                                      index:
                                                                          index,
                                                                      cashAmountSuggestions:
                                                                          cashAmountSuggestions),
                                                                  onSelected: (bool
                                                                          selected) =>
                                                                      _onSelectedCashAmountSuggestion(
                                                                        selected:
                                                                            selected,
                                                                        mopsByType:
                                                                            mopsByType,
                                                                        index:
                                                                            index,
                                                                        cashAmountSuggestions:
                                                                            cashAmountSuggestions,
                                                                      ));
                                                            },
                                                          ).toList(),
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        (_showKeyboardContent)
                                                            ? SizedBox(
                                                                child:
                                                                    KeyboardWidget(
                                                                  controller:
                                                                      _textEditingControllerCashAmount,
                                                                  isNumericMode:
                                                                      _keyboardNumeric,
                                                                  customLayoutKeys:
                                                                      true,
                                                                  isShiftEnabled:
                                                                      _shiftEnabled,
                                                                  height: 200,
                                                                  onKeyPress:
                                                                      (key) async {
                                                                    String
                                                                        text =
                                                                        _textEditingControllerCashAmount
                                                                            .text;
                                                                    TextSelection
                                                                        currentSelection =
                                                                        _textEditingControllerCashAmount
                                                                            .selection;
                                                                    int cursorPosition =
                                                                        currentSelection
                                                                            .start;

                                                                    _focusNodeCashAmount
                                                                        .requestFocus();

                                                                    if (key.keyType ==
                                                                        VirtualKeyboardKeyType
                                                                            .String) {
                                                                      String
                                                                          inputText =
                                                                          (_shiftEnabled ? key.capsText : key.text) ??
                                                                              '';
                                                                      text = text.replaceRange(
                                                                          cursorPosition,
                                                                          cursorPosition,
                                                                          inputText);
                                                                      cursorPosition +=
                                                                          inputText
                                                                              .length;

                                                                      _onChangedCashAmountTextField(
                                                                          value:
                                                                              text,
                                                                          mopsByType:
                                                                              mopsByType);
                                                                    } else if (key
                                                                            .keyType ==
                                                                        VirtualKeyboardKeyType
                                                                            .Action) {
                                                                      switch (key
                                                                          .action) {
                                                                        case VirtualKeyboardKeyAction
                                                                              .Backspace:
                                                                          if (text.isNotEmpty &&
                                                                              cursorPosition > 0) {
                                                                            text = text.replaceRange(
                                                                                cursorPosition - 1,
                                                                                cursorPosition,
                                                                                '');
                                                                            cursorPosition -=
                                                                                1;

                                                                            _onChangedCashAmountTextField(
                                                                                value: text,
                                                                                mopsByType: mopsByType);
                                                                          }
                                                                          break;

                                                                        case VirtualKeyboardKeyAction
                                                                              .Return:
                                                                          text =
                                                                              text.trimRight();
                                                                          break;

                                                                        case VirtualKeyboardKeyAction
                                                                              .Space:
                                                                          text = text.replaceRange(
                                                                              cursorPosition,
                                                                              cursorPosition,
                                                                              ' ');
                                                                          cursorPosition +=
                                                                              1;

                                                                          _onChangedCashAmountTextField(
                                                                              value: text,
                                                                              mopsByType: mopsByType);
                                                                          break;

                                                                        case VirtualKeyboardKeyAction
                                                                              .Shift:
                                                                          _shiftEnabled =
                                                                              !_shiftEnabled;
                                                                          break;

                                                                        default:
                                                                          break;
                                                                      }
                                                                    }

                                                                    TextEditingValue
                                                                        formattedValue =
                                                                        (receipt.grandTotal >= 0
                                                                                ? MoneyInputFormatter()
                                                                                : NegativeMoneyInputFormatter())
                                                                            .formatEditUpdate(
                                                                      TextEditingValue(
                                                                        text:
                                                                            text,
                                                                        selection:
                                                                            TextSelection.collapsed(offset: cursorPosition),
                                                                      ),
                                                                      TextEditingValue(
                                                                        text:
                                                                            text,
                                                                        selection:
                                                                            TextSelection.collapsed(offset: cursorPosition),
                                                                      ),
                                                                    );

                                                                    _textEditingControllerCashAmount
                                                                            .text =
                                                                        formattedValue
                                                                            .text;
                                                                    _textEditingControllerCashAmount
                                                                            .selection =
                                                                        formattedValue
                                                                            .selection;

                                                                    setState(
                                                                        () {});
                                                                  },
                                                                ),
                                                              )
                                                            : const SizedBox
                                                                .shrink(),
                                                        const SizedBox(
                                                            height: 20),
                                                      ],
                                                    ),
                                                  ),
                                                  const Divider(),
                                                ],
                                              );
                                            }
                                            // [END] UI for TUNAI MOP

                                            // [START] UI for EDC MOP
                                            if (paymentType.payTypeCode[0] ==
                                                    "2" ||
                                                paymentType.payTypeCode[0] ==
                                                    "3") {
                                              return Column(
                                                children: [
                                                  const SizedBox(height: 10),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 20),
                                                    width: double.infinity,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          paymentType
                                                              .description,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 15),
                                                        Wrap(
                                                          spacing: 8,
                                                          runSpacing: 8,
                                                          children: List<
                                                              Widget>.generate(
                                                            mopsByType
                                                                .map((mop) =>
                                                                    mop.tpmt4Id)
                                                                .toSet()
                                                                .length,
                                                            (int index) {
                                                              final distinctEdc =
                                                                  mopsByType
                                                                      .map((mop) =>
                                                                          mop.tpmt4Id)
                                                                      .toSet()
                                                                      .toList();
                                                              // dev.log("distinctEdc - $distinctEdc");
                                                              final mop = mopsByType
                                                                  .firstWhere((mop) =>
                                                                      mop.tpmt4Id ==
                                                                      distinctEdc[
                                                                          index]);
                                                              // dev.log("mopppp - $mop");
                                                              List<MopSelectionEntity>
                                                                  filteredMops =
                                                                  _values
                                                                      .where((edc) =>
                                                                          edc.tpmt4Id ==
                                                                          mop.tpmt4Id)
                                                                      .toList();

                                                              return ChoiceChip(
                                                                side: const BorderSide(
                                                                    color: ProjectColors
                                                                        .primary,
                                                                    width: 1.5),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        20),
                                                                label: Text(mop
                                                                        .edcDesc ??
                                                                    mop.mopAlias),
                                                                selected:
                                                                    _isSelectedEDCMOP(
                                                                        mop:
                                                                            mop),
                                                                onSelected: (bool
                                                                        selected) async =>
                                                                    await _onSelectedEDCMOP(
                                                                  selected:
                                                                      selected,
                                                                  receipt:
                                                                      receipt,
                                                                  mop: mop,
                                                                  filteredMops:
                                                                      filteredMops,
                                                                ),
                                                              );
                                                            },
                                                          ).toList(),
                                                        ),
                                                        const SizedBox(
                                                            height: 20),
                                                      ],
                                                    ),
                                                  ),
                                                  const Divider(),
                                                ],
                                              );
                                            }
                                            // [END] UI for EDC MOP

                                            // [START] UI for duitku
                                            if (paymentType.payTypeCode
                                                    .startsWith("7") &&
                                                mopsByType.any((mop) =>
                                                    mop.mopAlias == "duitku")) {
                                              return Column(
                                                children: [
                                                  const SizedBox(height: 10),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 20),
                                                    width: double.infinity,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          paymentType
                                                              .description,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 15),
                                                        Wrap(
                                                          spacing: 8,
                                                          runSpacing: 8,
                                                          children: List<
                                                              Widget>.generate(
                                                            mopsByType.length,
                                                            (int index) {
                                                              final mop =
                                                                  mopsByType[
                                                                      index];
                                                              String? bankVA =
                                                                  "";
                                                              String? bankName =
                                                                  "";
                                                              String?
                                                                  bankImage =
                                                                  "";
                                                              return ChoiceChip(
                                                                side: const BorderSide(
                                                                    color: ProjectColors
                                                                        .primary,
                                                                    width: 1.5),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        20),
                                                                label: Text(
                                                                  mop.mopAlias,
                                                                ),
                                                                selected: _values
                                                                    .map((e) => e
                                                                        .tpmt3Id)
                                                                    .contains(mop
                                                                        .tpmt3Id),
                                                                onSelected: (bool
                                                                    selected) async {
                                                                  await _checkConnection();
                                                                  if (isConnected ==
                                                                      false) {
                                                                    SnackBarHelper.presentErrorSnackBar(
                                                                        context,
                                                                        "No internet connection detected. Please check your network settings and try again");
                                                                  }
                                                                  if (selected) {
                                                                    if (isQRISorVA) {
                                                                      SnackBarHelper.presentErrorSnackBar(
                                                                          context,
                                                                          "Please choose either MOP QRIS or duitku, not both");
                                                                      return;
                                                                    }
                                                                    double?
                                                                        mopAmount =
                                                                        0;
                                                                    if (widget
                                                                        .isMultiMOPs) {
                                                                      if ((receipt.totalPayment ??
                                                                              0) >=
                                                                          receipt
                                                                              .grandTotal) {
                                                                        return;
                                                                      }
                                                                      int maxAmount = (receipt.grandTotal -
                                                                              (receipt.totalVoucher ?? 0) -
                                                                              (receipt.totalNonVoucher ?? 0))
                                                                          .toInt();

                                                                      final List<
                                                                              dynamic>
                                                                          paymentMethods =
                                                                          await GetIt.instance<DuitkuVAListApi>()
                                                                              .getPaymentMethods();
                                                                      dev.log(
                                                                          "paymentMethods - $paymentMethods");
                                                                      mopAmount =
                                                                          await showDialog<
                                                                              double>(
                                                                        context:
                                                                            context,
                                                                        barrierDismissible:
                                                                            false,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return InputDuitkuVADialog(
                                                                              onVASelected: (mopVA) {
                                                                                setState(() {
                                                                                  bankName = mopVA.cardName;
                                                                                  bankVA = mopVA.cardHolder;
                                                                                  bankImage = mopVA.edcDesc;
                                                                                  isQRISorVA = true;
                                                                                });
                                                                              },
                                                                              mopSelectionEntity: mop,
                                                                              paymentMethods: paymentMethods,
                                                                              amount: maxAmount);
                                                                        },
                                                                      );
                                                                    } else {
                                                                      mopAmount = receipt
                                                                              .grandTotal -
                                                                          (receipt.totalVoucher ??
                                                                              0);
                                                                    }

                                                                    if (mopAmount ==
                                                                            null ||
                                                                        mopAmount ==
                                                                            0) {
                                                                      return;
                                                                    }

                                                                    _values = (widget.isMultiMOPs
                                                                            ? _values.where((e) => e.tpmt3Id != mop.tpmt3Id).toList()
                                                                            : <MopSelectionEntity>[]) +
                                                                        [
                                                                          mop.copyWith(
                                                                              cardName: bankName,
                                                                              cardHolder: bankVA,
                                                                              edcDesc: bankImage,
                                                                              amount: mopAmount)
                                                                        ];
                                                                    if (!widget
                                                                        .isMultiMOPs) {
                                                                      _textEditingControllerCashAmount
                                                                          .text = "";
                                                                    }
                                                                  } else {
                                                                    _values = _values
                                                                        .where((e) =>
                                                                            e.tpmt3Id !=
                                                                            mop.tpmt3Id)
                                                                        .toList();
                                                                    setState(
                                                                        () {
                                                                      isQRISorVA =
                                                                          false;
                                                                    });
                                                                  }
                                                                  setState(
                                                                      () {});
                                                                  updateReceiptMop();
                                                                },
                                                              );
                                                            },
                                                          ).toList(),
                                                        ),
                                                        const SizedBox(
                                                            height: 20),
                                                      ],
                                                    ),
                                                  ),
                                                  const Divider(),
                                                ],
                                              );
                                            }
                                            // [END] UI for duitku

                                            // [START] UI for other MOPs
                                            return Column(
                                              children: [
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20),
                                                  width: double.infinity,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        paymentType.description,
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      Wrap(
                                                        spacing: 8,
                                                        runSpacing: 8,
                                                        children: List<
                                                            Widget>.generate(
                                                          mopsByType.length,
                                                          (int index) {
                                                            final mop =
                                                                mopsByType[
                                                                    index];
                                                            return ChoiceChip(
                                                              side: const BorderSide(
                                                                  color: ProjectColors
                                                                      .primary,
                                                                  width: 1.5),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(20),
                                                              label: Text(
                                                                mop.mopAlias,
                                                              ),
                                                              selected:
                                                                  _isSelectedOtherMOP(
                                                                paymentType:
                                                                    paymentType,
                                                                receipt:
                                                                    receipt,
                                                                mop: mop,
                                                              ),
                                                              onSelected: (bool
                                                                      selected) async =>
                                                                  await _onSelectedOtherMOP(
                                                                selected:
                                                                    selected,
                                                                paymentType:
                                                                    paymentType,
                                                                receipt:
                                                                    receipt,
                                                                mop: mop,
                                                              ),
                                                            );
                                                          },
                                                        ).toList(),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Divider(),
                                              ],
                                            );
                                            // [END] UI for other MOPs
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _noteChip(double amount, int type) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: const Color.fromARGB(108, 158, 158, 158),
          ),
          boxShadow: const [
            BoxShadow(
              spreadRadius: 0.5,
              blurRadius: 5,
              color: Color.fromRGBO(0, 0, 0, 0.05),
            ),
          ],
          color: const Color.fromARGB(255, 223, 223, 223),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              type == 1
                  ? "RD ${Helpers.parseMoney(amount)}"
                  : type == 2
                      ? "DP ${Helpers.parseMoney(amount)}"
                      : type == 3
                          ? "HD ${Helpers.parseMoney(amount)}"
                          : type == 4
                              ? "TLD ${Helpers.parseMoney(amount)}"
                              : "",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                // color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChipLabelColor extends Color implements MaterialStateColor {
  const ChipLabelColor() : super(_default);

  static const int _default = 0xFF000000;

  @override
  Color resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
      return Colors.white; // Selected text color
    }
    return ProjectColors.primary; // normal text color
  }
}

class _CheckoutSuccessDialogContent extends StatefulWidget {
  const _CheckoutSuccessDialogContent();

  @override
  State<_CheckoutSuccessDialogContent> createState() =>
      __CheckoutSuccessDialogContentState();
}

class __CheckoutSuccessDialogContentState
    extends State<_CheckoutSuccessDialogContent> {
  String currencyName = "";
  List<TableRow> voucherDetails = [];

  Future<void> _refreshVouchersChips(int color) async {
    final List<VouchersSelectionEntity> vouchers =
        context.read<ReceiptCubit>().state.vouchers;
    final Map<String, num> amountByTpmt3Ids = {};
    final List<TableRow> result = [];

    for (final voucher in vouchers) {
      if (amountByTpmt3Ids[voucher.tpmt3Id] == null) {
        amountByTpmt3Ids[voucher.tpmt3Id!] = voucher.voucherAmount;
      } else {
        amountByTpmt3Ids[voucher.tpmt3Id!] =
            amountByTpmt3Ids[voucher.tpmt3Id!]! + voucher.voucherAmount;
      }
    }

    for (final tpmt3Id in amountByTpmt3Ids.keys) {
      final MopSelectionEntity? mopSelectionEntity =
          await GetIt.instance<MopSelectionRepository>()
              .getMopSelectionByTpmt3Id(tpmt3Id);
      result.add(
        TableRow(
          children: [
            Text(
              mopSelectionEntity?.mopAlias ?? "Unknown Voucher",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              Helpers.parseMoney(amountByTpmt3Ids[tpmt3Id]!),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      );
    }

    setState(() {
      voucherDetails = result;
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrencyName();
    _refreshVouchersChips(2);
  }

  void getCurrencyName() async {
    try {
      final POSParameterEntity? posParameterEntity =
          await GetIt.instance<GetPosParameterUseCase>().call();
      if (posParameterEntity == null) return;
      final StoreMasterEntity? storeMasterEntity =
          await GetIt.instance<GetStoreMasterUseCase>()
              .call(params: posParameterEntity.tostrId);
      if (storeMasterEntity == null) return;
      if (storeMasterEntity.tcurrId == null) return;
      final CurrencyEntity? currencyEntity = await GetIt.instance<AppDatabase>()
          .currencyDao
          .readByDocId(storeMasterEntity.tcurrId!, null);
      if (currencyEntity == null) return;

      setState(() {
        currencyName = "${currencyEntity.curCode} ";
      });
    } catch (e) {
      dev.log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    dev.log("CHECKOUT STATE - ${context.read<ReceiptCubit>().state}");
    return Theme(
        data: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
            fontFamily: 'Roboto',
            useMaterial3: true,
            chipTheme: const ChipThemeData(
                showCheckmark: true,
                checkmarkColor: Colors.white,
                backgroundColor: Colors.transparent,
                selectedColor: ProjectColors.primary,
                labelStyle: TextStyle(color: ChipLabelColor(), fontSize: 18))),
        child: SingleChildScrollView(
          child: SizedBox(
            // width: MediaQuery.of(context).size.width * 0.7,
            // width: 600,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  // width: double.infinity,
                  color: const Color.fromARGB(255, 134, 1, 1),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            boxShadow: const [
                              BoxShadow(
                                spreadRadius: 0.5,
                                blurRadius: 5,
                                color: Color.fromRGBO(0, 0, 0, 0.097),
                              ),
                            ],
                            color: const Color.fromARGB(255, 47, 143, 8),
                          ),
                          child: const Text(
                            "Transaction Success",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/images/icon-success.svg",
                              height: 42,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "$currencyName${Helpers.parseMoney(context.read<ReceiptCubit>().state.grandTotal.toInt())}",
                              style: const TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 52,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          context.read<ReceiptCubit>().state.transDateTime !=
                                  null
                              ? DateFormat("EEE, dd MMM yyyy hh:mm aaa").format(
                                  context
                                      .read<ReceiptCubit>()
                                      .state
                                      .transDateTime!)
                              : "",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    // width: double.infinity,
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Detail",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Divider()
                      ],
                    )),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    // width: double.infinity,
                    child: Table(columnWidths: const {
                      0: FlexColumnWidth(3),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(5),
                    }, children: [
                      TableRow(
                        children: [
                          const Text(
                            "Invoice Number",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            context.read<ReceiptCubit>().state.docNum,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      TableRow(
                        children: [
                          const Text(
                            "Total Bill",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            textAlign: TextAlign.right,
                            Helpers.parseMoney(context
                                .read<ReceiptCubit>()
                                .state
                                .grandTotal
                                .round()),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      const TableRow(children: [
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ]),
                      ...List.generate(
                          context
                              .read<ReceiptCubit>()
                              .state
                              .mopSelections
                              .length, (index) {
                        final MopSelectionEntity mop = context
                            .read<ReceiptCubit>()
                            .state
                            .mopSelections[index];

                        return TableRow(
                          children: [
                            Text(
                              (mop.tpmt2Id != null)
                                  ? mop.cardName!
                                  : mop.mopAlias,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              Helpers.parseMoney(mop.payTypeCode == "1"
                                  ? mop.amount! +
                                      (context
                                              .read<ReceiptCubit>()
                                              .state
                                              .changed ??
                                          0)
                                  : mop.amount!),
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        );
                      }),
                      if (voucherDetails.isNotEmpty) ...voucherDetails,
                      // const TableRow(children: [
                      //   SizedBox(
                      //     height: 10,
                      //   ),
                      //   SizedBox(
                      //     height: 10,
                      //   ),
                      //   SizedBox(
                      //     height: 10,
                      //   )
                      // ]),
                      TableRow(
                        children: [
                          const Text(
                            "Total Payment",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            Helpers.parseMoney(context
                                .read<ReceiptCubit>()
                                .state
                                .totalPayment!
                                .toInt()),
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                      TableRow(
                        children: [
                          const Text(
                            "Change",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            context.read<ReceiptCubit>().state.changed != null
                                ? Helpers.parseMoney(context
                                    .read<ReceiptCubit>()
                                    .state
                                    .changed!
                                    .round())
                                : "",
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ])),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ));
  }
}
