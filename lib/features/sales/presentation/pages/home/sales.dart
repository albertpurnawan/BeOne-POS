// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/constants/route_constants.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/core/widgets/empty_list.dart';
import 'package:pos_fe/core/widgets/scroll_widget.dart';
import 'package:pos_fe/features/dual_screen/services/send_data_window_service.dart';
import 'package:pos_fe/features/sales/data/data_sources/remote/invoice_service.dart';
import 'package:pos_fe/features/sales/data/models/user.dart';
import 'package:pos_fe/features/sales/domain/entities/down_payment_entity.dart';
import 'package:pos_fe/features/sales/domain/entities/employee.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/promotions.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_down_payment.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_pos_parameter.dart';
import 'package:pos_fe/features/sales/presentation/cubit/customers_cubit.dart';
import 'package:pos_fe/features/sales/presentation/cubit/items_cubit.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';
import 'package:pos_fe/features/sales/presentation/pages/home/down_payment_dialog.dart';
import 'package:pos_fe/features/sales/presentation/pages/home/invoice_details_dialog.dart';
import 'package:pos_fe/features/sales/presentation/pages/home/item_details_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/checkout_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/input_coupons_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/item_search_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/promotion_summary_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/queue_list_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/return_dialog.dart';
import 'package:pos_fe/features/sales/presentation/widgets/select_customer_dialog.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({
    Key? key,
    required this.salesViewType,
    this.onFirstBuild,
  }) : super(key: key);
  final int salesViewType;
  final Function(BuildContext)? onFirstBuild;

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  // =================================================
  //             [START] Variables
  // =================================================

  // States for handling focus
  ReceiptItemEntity? activeReceiptItem;
  bool isEditingNewReceiptItemCode = true;
  bool isEditingNewReceiptItemQty = false;
  List<int> indexIsSelect = [-1, 0];
  bool isUpdatingReceiptItemQty = false;
  bool isEditingReceiptItemQty = false;
  bool isNewItemAdded = false;
  late int salesViewType;

  // States for handling current time
  late Timer _timer;
  ValueNotifier<String> currentTime =
      ValueNotifier<String>(DateFormat.Hms().format(DateTime.now()));

  // Scroll Controllers
  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener =
      ScrollOffsetListener.create();
  final ScrollController _scrollControllerMain = ScrollController();
  final ScrollController _scrollControllerReceiptItems = ScrollController();
  final ScrollController _scrollControllerReceiptSummary = ScrollController();

  // Focus Nodes
  late final FocusNode _newReceiptItemQuantityFocusNode = FocusNode(
    skipTraversal: true,
    descendantsAreFocusable: false,
    descendantsAreTraversable: false,
    onKeyEvent: (node, event) {
      final ReceiptEntity state = context.read<ReceiptCubit>().state;

      if (event.runtimeType == KeyUpEvent) {
        return KeyEventResult.skipRemainingHandlers;
      }

      if (event.physicalKey == PhysicalKeyboardKey.arrowUp &&
          (indexIsSelect[0] > 0 ||
              (indexIsSelect[1] == 0 && state.receiptItems.length - 1 > 0))) {
        setState(() {
          indexIsSelect = [
            indexIsSelect[1] == 1
                ? indexIsSelect[0] - 1
                : state.receiptItems.length - 1,
            1
          ];
          _textEditingControllerNewReceiptItemQuantity.text = "";
          // Helpers.cleanDecimal(e.quantity, 3);
          _textEditingControllerNewReceiptItemCode.text =
              state.receiptItems[indexIsSelect[0]].itemEntity.barcode;
          _newReceiptItemCodeFocusNode.unfocus();
          isUpdatingReceiptItemQty = true;
          isEditingNewReceiptItemCode = false;
          _newReceiptItemQuantityFocusNode.requestFocus();
        });
        scrollToReceiptItemByIndex(indexIsSelect[0]);

        return KeyEventResult.skipRemainingHandlers;
      } else if (event.physicalKey == PhysicalKeyboardKey.arrowDown &&
          indexIsSelect[0] < state.receiptItems.length - 1) {
        if (indexIsSelect[1] == 0) return KeyEventResult.skipRemainingHandlers;
        setState(() {
          indexIsSelect = [indexIsSelect[0] + 1, 1];
          _textEditingControllerNewReceiptItemQuantity.text = "";
          // Helpers.cleanDecimal(e.quantity, 3);
          _textEditingControllerNewReceiptItemCode.text =
              state.receiptItems[indexIsSelect[0]].itemEntity.barcode;
          _newReceiptItemCodeFocusNode.unfocus();
          isUpdatingReceiptItemQty = true;
          isEditingNewReceiptItemCode = false;
          _newReceiptItemQuantityFocusNode.requestFocus();
        });

        scrollToReceiptItemByIndex(indexIsSelect[0]);

        return KeyEventResult.skipRemainingHandlers;
      } else if (event.physicalKey == PhysicalKeyboardKey.arrowLeft ||
          event.physicalKey == PhysicalKeyboardKey.arrowRight) {
        return KeyEventResult.skipRemainingHandlers;
      } else if ( // F1 is Item Attr.
          event.physicalKey == PhysicalKeyboardKey.f2 ||
              event.physicalKey == PhysicalKeyboardKey.f3 ||
              event.physicalKey == PhysicalKeyboardKey.f4 ||
              event.physicalKey == PhysicalKeyboardKey.f5 ||
              event.physicalKey == PhysicalKeyboardKey.f6 ||
              // F7 is Remove item
              event.physicalKey == PhysicalKeyboardKey.f8 ||
              event.physicalKey == PhysicalKeyboardKey.f9 ||
              // event.physicalKey == PhysicalKeyboardKey.f10 ||
              event.physicalKey == PhysicalKeyboardKey.f11 ||
              event.physicalKey == PhysicalKeyboardKey.f12) {
        if (isUpdatingReceiptItemQty) {
          setState(() {
            indexIsSelect = [-1, 0];
            _textEditingControllerNewReceiptItemQuantity.text = "1";
            _textEditingControllerNewReceiptItemCode.text = "";
            _newReceiptItemQuantityFocusNode.unfocus();
            isUpdatingReceiptItemQty = false;
            isEditingNewReceiptItemCode = true;
            _newReceiptItemCodeFocusNode.requestFocus();
          });
        }

        if (isEditingNewReceiptItemQty &&
            event.physicalKey != PhysicalKeyboardKey.f6) {
          setState(() {
            isEditingNewReceiptItemQty = false;
            isEditingNewReceiptItemCode = true;
            final double? qtyToDouble = double.tryParse(
                _textEditingControllerNewReceiptItemQuantity.text);
            _textEditingControllerNewReceiptItemQuantity.text =
                qtyToDouble == null || qtyToDouble == 0
                    ? "1"
                    : Helpers.cleanDecimal(
                        double.parse(
                            _textEditingControllerNewReceiptItemQuantity.text),
                        3);

            _newReceiptItemCodeFocusNode.requestFocus();
          });
        }
        return KeyEventResult.ignored;
      } else if (event.physicalKey == PhysicalKeyboardKey.escape) {
        if (isUpdatingReceiptItemQty) {
          setState(() {
            indexIsSelect = [-1, 0];
            _textEditingControllerNewReceiptItemQuantity.text = "1";
            _textEditingControllerNewReceiptItemCode.text = "";
            _newReceiptItemQuantityFocusNode.unfocus();
            isUpdatingReceiptItemQty = false;
            isEditingNewReceiptItemCode = true;
            _newReceiptItemCodeFocusNode.requestFocus();
          });
        }

        if (isEditingNewReceiptItemQty &&
            event.physicalKey != PhysicalKeyboardKey.f6) {
          setState(() {
            isEditingNewReceiptItemQty = false;
            isEditingNewReceiptItemCode = true;
            final double? qtyToDouble = double.tryParse(
                _textEditingControllerNewReceiptItemQuantity.text);
            _textEditingControllerNewReceiptItemQuantity.text =
                qtyToDouble == null || qtyToDouble == 0
                    ? "1"
                    : Helpers.cleanDecimal(
                        double.parse(
                            _textEditingControllerNewReceiptItemQuantity.text),
                        3);

            _newReceiptItemCodeFocusNode.requestFocus();
          });
        }
        return KeyEventResult.skipRemainingHandlers;
      } else if (event.physicalKey == PhysicalKeyboardKey.f10) {
        return KeyEventResult.handled;
      } else {
        return KeyEventResult.ignored;
      }
    },
  );
  late final FocusNode _newReceiptItemCodeFocusNode = FocusNode(
    skipTraversal: true,
    descendantsAreFocusable: false,
    descendantsAreTraversable: false,
    onKeyEvent: (node, event) {
      final ReceiptEntity state = context.read<ReceiptCubit>().state;
      if (event.runtimeType == KeyUpEvent) {
        return KeyEventResult.skipRemainingHandlers;
      }

      if (event.physicalKey == PhysicalKeyboardKey.arrowUp &&
          (indexIsSelect[0] > 0 ||
              (indexIsSelect[1] == 0 && state.receiptItems.isNotEmpty))) {
        setState(() {
          indexIsSelect = [
            indexIsSelect[1] == 1
                ? indexIsSelect[0] - 1
                : state.receiptItems.length - 1,
            1
          ];
          _textEditingControllerNewReceiptItemQuantity.text = "";
          _textEditingControllerNewReceiptItemCode.text =
              state.receiptItems[indexIsSelect[0]].itemEntity.barcode;
          _newReceiptItemCodeFocusNode.unfocus();
          isUpdatingReceiptItemQty = true;
          isEditingNewReceiptItemCode = false;
          _newReceiptItemQuantityFocusNode.requestFocus();
        });

        scrollToReceiptItemByIndex(indexIsSelect[0]);

        return KeyEventResult.skipRemainingHandlers;
      } else if (event.physicalKey == PhysicalKeyboardKey.arrowDown &&
          indexIsSelect[0] < state.receiptItems.length) {
        if (indexIsSelect[1] == 0) return KeyEventResult.skipRemainingHandlers;
        setState(() {
          indexIsSelect = [indexIsSelect[0] + 1, 1];
          _textEditingControllerNewReceiptItemQuantity.text = "";
          // Helpers.cleanDecimal(e.quantity, 3);
          _textEditingControllerNewReceiptItemCode.text =
              state.receiptItems[indexIsSelect[0]].itemEntity.barcode;
          _newReceiptItemCodeFocusNode.unfocus();
          isUpdatingReceiptItemQty = true;
          isEditingNewReceiptItemCode = false;
          _newReceiptItemQuantityFocusNode.requestFocus();
        });

        scrollToReceiptItemByIndex(indexIsSelect[0]);

        return KeyEventResult.skipRemainingHandlers;
      } else if (event.physicalKey == PhysicalKeyboardKey.arrowLeft ||
          event.physicalKey == PhysicalKeyboardKey.arrowRight) {
        return KeyEventResult.skipRemainingHandlers;
      } else if (event.physicalKey == PhysicalKeyboardKey.f10) {
        Future.delayed(Durations.medium1,
            () => _newReceiptItemCodeFocusNode.requestFocus());
        return KeyEventResult.handled;
      } else {
        return KeyEventResult.ignored;
      }
    },
  );

  // Text Editing Controllers
  late final TextEditingController
      _textEditingControllerNewReceiptItemQuantity = TextEditingController()
        ..text = "1";
  late final TextEditingController _textEditingControllerNewReceiptItemCode =
      TextEditingController();

  // Check Synced
  int totalToinvs = 0;
  int totalTcsr1s = 0;
  int totalToinvSynced = 0;
  int totalTcsr1Synced = 0;
  String? lastSync;
  bool changeColor = false;

  // Check Customer
  bool isMember = false;

  // Check Item "DP" on Store
  bool itemDPAvailable = true;

  // =================================================
  //             [END] Variables
  // =================================================

  @override
  void initState() {
    super.initState();
    // Initialize timer for time UI
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      currentTime.value = DateFormat.Hms().format(DateTime.now());
    });

    // Set Sales View Type
    salesViewType = widget.salesViewType;

    // Reset receipt if no items listed on state
    final ReceiptCubit receiptCubit = context.read<ReceiptCubit>();
    if (receiptCubit.state.receiptItems.isEmpty)
      context.read<ReceiptCubit>().resetReceipt();

    // Run a function (if any) on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.onFirstBuild != null) widget.onFirstBuild!(context);
    });

    // Start Check Synced
    countTotalInvoice();
    countTotalShifts();
    getLastSync();
    checkIsSyncing();

    // Start Check Member
    checkReceiptWithMember(context.read<ReceiptCubit>().state);
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollControllerMain.dispose();
    _scrollControllerReceiptItems.dispose();
    _scrollControllerReceiptSummary.dispose();
    _newReceiptItemCodeFocusNode.dispose();
    _newReceiptItemQuantityFocusNode.dispose();
    _textEditingControllerNewReceiptItemCode.dispose();
    _textEditingControllerNewReceiptItemQuantity.dispose();
    super.dispose();
  }

  Future<void> checkIsSyncing() async {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await countTotalInvoice();
      await countTotalShifts();
      await getLastSync();
    });
  }

  Future<void> countTotalInvoice() async {
    final invoices =
        await GetIt.instance<AppDatabase>().invoiceHeaderDao.readAll();
    final toinvSyncedCount = invoices
        .where(
            (invoice) => invoice.syncToBos != null && invoice.syncToBos != "")
        .length;
    setState(() {
      totalToinvSynced = toinvSyncedCount;
      totalToinvs = invoices.length;
    });
  }

  Future<void> countTotalShifts() async {
    final shifts = await GetIt.instance<AppDatabase>()
        .cashierBalanceTransactionDao
        .readAll();
    final shiftsClosed =
        shifts.where((shift) => shift.approvalStatus == 1).length;
    final tcsr1SyncedCount =
        shifts.where((shift) => shift.syncToBos != null).length;
    setState(() {
      totalTcsr1Synced = tcsr1SyncedCount;
      totalTcsr1s = shiftsClosed;
    });
  }

  Future<void> getLastSync() async {
    final POSParameterEntity? topos =
        await GetIt.instance<GetPosParameterUseCase>().call();
    if (topos == null) throw "Failed to retrieve POS Parameter";
    final dateTime = DateTime.parse(topos.lastSync!);

    await updateColorBasedOnSyncTime(dateTime);

    setState(() {
      lastSync = Helpers.dateddMMMyyyyHHmmss(dateTime.toLocal());
    });
  }

  Future<void> updateColorBasedOnSyncTime(DateTime lastSync) async {
    if (DateTime.now().difference(lastSync).inMinutes >= 60) {
      setState(() {
        changeColor = true;
      });
    } else {
      setState(() {
        changeColor = false;
      });
    }
  }

  Future<void> checkReceiptWithMember(ReceiptEntity receipt) async {
    setState(() {
      isMember = ((receipt.customerEntity != null) &&
          (receipt.customerEntity!.custCode != '99'));
      log("isMember = $isMember");
    });
  }

  Future<void> checkItemDPAvailability() async {
    final dp = await GetIt.instance<GetDownPaymentUseCase>().call();
    setState(() {
      itemDPAvailable = (dp != null) ? true : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    isUpdatingReceiptItemQty = indexIsSelect[1] == 1;
    isEditingReceiptItemQty =
        isEditingNewReceiptItemQty || isUpdatingReceiptItemQty;

    if (!Platform.isWindows) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor: ProjectColors.primary,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light));
    }
    return PopScope(
      canPop: false,
      child: Scaffold(
        // backgroundColor: Color.fromRGBO(175, 47, 47, 1),
        backgroundColor: const Color.fromARGB(255, 234, 234, 234),
        // backgroundColor: Colors.white,
        // resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: ScrollWidget(
            controller: _scrollControllerMain,
            child: SizedBox(
              height: MediaQuery.of(context).size.height *
                  (Platform.isWindows ? 0.98 : 0.96),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 1, 10, 5),
                        decoration: BoxDecoration(
                          // border: Border.all(
                          //     color: Color.fromRGBO(195, 53, 53, 1),
                          //     width: 4.0),
                          borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(10)),

                          color: changeColor
                              ? const Color.fromRGBO(243, 0, 0, 1)
                              : ProjectColors.green,
                          boxShadow: const [
                            BoxShadow(
                              spreadRadius: 0.5,
                              blurRadius: 5,
                              color: Color.fromRGBO(0, 0, 0, 0.248),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Text("Last Sync on ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                )),
                            lastSync == null
                                ? Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 1, 0, 0),
                                    width: 12,
                                    height: 12,
                                    child: const CircularProgressIndicator(
                                      color: Colors.green,
                                    ))
                                : Text("$lastSync",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    )),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 1, 10, 5),
                        decoration: const BoxDecoration(
                          // border: Border.all(
                          //     color: Color.fromRGBO(195, 53, 53, 1),
                          //     width: 4.0),
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(10)),

                          color: ProjectColors.green,
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 0.5,
                              blurRadius: 5,
                              color: Color.fromRGBO(0, 0, 0, 0.248),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Text("Invoices  $totalToinvSynced/$totalToinvs",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                            // const Icon(Icons.upload, color: Colors.white, size: 14),
                            totalToinvSynced == totalToinvs
                                ? const Icon(
                                    Icons.check_circle_outline_outlined,
                                    color: Colors.green,
                                    size: 14)
                                : Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 1, 0, 0),
                                    width: 12,
                                    height: 12,
                                    child: const CircularProgressIndicator(
                                      color: Colors.green,
                                    )),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 1, 10, 5),
                        decoration: const BoxDecoration(
                          border: Border(),
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(10)),
                          color: ProjectColors.green,
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 0.5,
                              blurRadius: 5,
                              color: Color.fromRGBO(0, 0, 0, 0.248),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Text("Shifts  $totalTcsr1Synced/$totalTcsr1s",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                            // const Icon(Icons.upload, color: Colors.white, size: 14),

                            totalTcsr1Synced == totalTcsr1s
                                ? const Icon(
                                    Icons.check_circle_outline_outlined,
                                    color: Colors.green,
                                    size: 14)
                                : Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 1, 0, 0),
                                    width: 12,
                                    height: 12,
                                    child: const CircularProgressIndicator(
                                      color: Colors.green,
                                    )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          38, Platform.isWindows ? 8 : 10, 38, 10),
                      child: Row(
                        children: [
                          // Start - Column 1
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                _receiptItemsList(),
                                SizedBox(height: salesViewType == 1 ? 20 : 0),
                                salesViewType == 1
                                    ? Expanded(
                                        flex: salesViewType == 1 ? 2 : 1,
                                        child: Row(
                                          children: [
                                            _buttonGroup1V1(),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Expanded(
                                                flex: 4,
                                                child: _receiptItemForm())
                                          ],
                                        ))
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ),
                          // End - Column 1

                          const SizedBox(
                            width: 20,
                          ),

                          // Start - Column 2
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 12,
                                  child: salesViewType == 1
                                      ? Column(
                                          children: [
                                            _transactionSummaryV1(),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        )
                                      : Column(
                                          children: [
                                            _transactionSummaryV2(),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: _buttonGroup1V3(),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Expanded(
                                                flex: 2,
                                                child: _receiptItemForm()),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),

                                // Start - Numpad & ButtonGroup 2
                                Expanded(
                                  flex: 8,
                                  child: Row(
                                    children: [
                                      _numpad(),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      _buttonGroup3()
                                    ],
                                  ),
                                )
                                // End - Numeric Keypad & ButtonGroup 2
                              ],
                            ),
                          ),
                          // End - Column 2
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =================================================
  //             [START] Widgets
  // =================================================

  Widget _receiptItemsList() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendToDisplay();
    });
    return BlocBuilder<ReceiptCubit, ReceiptEntity>(
      builder: (context, state) {
        return Expanded(
          flex: 16,
          child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                // border: Border.all(
                //     color: Color.fromRGBO(195, 53, 53, 1),
                //     width: 4.0),
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    spreadRadius: 0.5,
                    blurRadius: 5,
                    color: Color.fromRGBO(197, 197, 197, 1),
                  ),
                ],
              ),
              child: Stack(children: [
                Positioned.fill(
                  child: Column(
                    children: [
                      Container(
                        // padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                        height: 50,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          // border: Border.all(
                          //     color: Color.fromRGBO(195, 53, 53, 1),
                          //     width: 4.0),
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(5)),
                          color: Color.fromRGBO(128, 0, 0, 1),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                    height: 50,
                                    width: 120,
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 4, 8, 6),
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 234, 234, 234),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(4),
                                        bottomRight: Radius.circular(45),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          spreadRadius: 0.5,
                                          blurRadius: 10,
                                          color: Color.fromRGBO(
                                              212, 212, 212, 0.211),
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                      "assets/logo/ruby_pos.png",
                                      alignment: Alignment.centerLeft,
                                    )),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Center(
                                child: FittedBox(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.receipt_outlined,
                                          color: Colors.white),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        context
                                            .read<ReceiptCubit>()
                                            .state
                                            .docNum,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                width: double.infinity,
                                alignment: Alignment.centerRight,
                                child: FittedBox(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Icon(Icons.stars,
                                          color: Colors.white),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        context
                                                    .read<ReceiptCubit>()
                                                    .state
                                                    .customerEntity !=
                                                null
                                            ? Helpers.clipStringAndAddEllipsis(
                                                context
                                                    .read<ReceiptCubit>()
                                                    .state
                                                    .customerEntity!
                                                    .custName,
                                                25)
                                            : " - ",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          // height: 1,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            if (state.receiptItems.isEmpty)
                              const Expanded(
                                child: EmptyList(
                                  imagePath: "assets/images/empty-item.svg",
                                  sentence:
                                      "Tadaa.. There is nothing here!\nInput item barcode to start adding item.",
                                ),
                              )
                            else
                              Expanded(
                                child: ScrollablePositionedList.builder(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 0),
                                  itemScrollController: itemScrollController,
                                  scrollOffsetController:
                                      scrollOffsetController,
                                  itemPositionsListener: itemPositionsListener,
                                  scrollOffsetListener: scrollOffsetListener,
                                  itemCount: state.receiptItems.length,
                                  itemBuilder: (context, index) {
                                    // log("stateReceiveItems - ${state.receiptItems}");
                                    final e = state.receiptItems[index];
                                    // final hasPromos = e.promos.isNotEmpty;
                                    final test = e.promos.map(
                                      (promo) => Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              child: Text(
                                            promo.promoDescription,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )),
                                          Expanded(
                                              // DiscountUI
                                              child: promo.discAmount == null ||
                                                      promo.discAmount == 0
                                                  ? const SizedBox.shrink()
                                                  : Text(
                                                      (e.itemEntity
                                                                  .includeTax ==
                                                              1)
                                                          ? Helpers.parseMoney(((-1 *
                                                                  (promo
                                                                      .discAmount!) *
                                                                  ((100 +
                                                                          e.itemEntity
                                                                              .taxRate) /
                                                                      100))
                                                              .round()))
                                                          : Helpers.parseMoney(
                                                              ((promo.discAmount! *
                                                                      -1)
                                                                  .round())),
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      textAlign:
                                                          TextAlign.right,
                                                    )),
                                          const SizedBox(
                                            width: 20,
                                          )
                                        ],
                                      ),
                                    );

                                    return TapRegion(
                                      groupId: 1,
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () => setState(() {
                                          if (indexIsSelect[0] == index) {
                                            indexIsSelect = [-1, 0];
                                            _textEditingControllerNewReceiptItemQuantity
                                                .text = "1";
                                            _textEditingControllerNewReceiptItemCode
                                                .text = "";
                                            _newReceiptItemQuantityFocusNode
                                                .unfocus();
                                            isUpdatingReceiptItemQty = false;
                                            isEditingNewReceiptItemCode = true;
                                            _newReceiptItemCodeFocusNode
                                                .requestFocus();
                                          } else {
                                            indexIsSelect = [index, 1];
                                            _textEditingControllerNewReceiptItemQuantity
                                                .text = "";
                                            // Helpers.cleanDecimal(e.quantity, 3);
                                            _textEditingControllerNewReceiptItemCode
                                                .text = e.itemEntity.barcode;
                                            _newReceiptItemCodeFocusNode
                                                .unfocus();
                                            isUpdatingReceiptItemQty = true;
                                            isEditingNewReceiptItemCode = false;
                                            _newReceiptItemQuantityFocusNode
                                                .requestFocus();
                                          }
                                        }),
                                        child: Column(
                                          children: [
                                            if (index == 0)
                                              const Column(
                                                children: [
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Divider(
                                                    height: 1,
                                                    thickness: 0.5,
                                                    color: Color.fromARGB(
                                                        100, 118, 118, 117),
                                                  ),
                                                ],
                                              ),
                                            AnimatedContainer(
                                              duration:
                                                  index == indexIsSelect[0] &&
                                                          indexIsSelect[1] == 1
                                                      ? Duration.zero
                                                      : const Duration(
                                                          milliseconds: 200),
                                              padding: const EdgeInsets.all(0),
                                              color: index ==
                                                          indexIsSelect[0] &&
                                                      indexIsSelect[1] == 1
                                                  ? const Color.fromARGB(
                                                      255, 255, 222, 222)
                                                  : isNewItemAdded &&
                                                          (index ==
                                                              state.receiptItems
                                                                      .length -
                                                                  1)
                                                      ? const Color.fromARGB(
                                                          95, 100, 202, 122)
                                                      : Colors.white,
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    20,
                                                    10,
                                                    0,
                                                    e.quantity < 0 ? 0 : 10),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 40,
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        (index + 1).toString(),
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 6,
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            // mainAxisAlignment:
                                                            //     MainAxisAlignment
                                                            //         .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Expanded(
                                                                flex: 3,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    FittedBox(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          SvgPicture
                                                                              .asset(
                                                                            "assets/images/inventory.svg",
                                                                            height:
                                                                                16,
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                5,
                                                                          ),
                                                                          Text(
                                                                            e.itemEntity.itemCode,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                15,
                                                                          ),
                                                                          SvgPicture
                                                                              .asset(
                                                                            "assets/images/barcode.svg",
                                                                            height:
                                                                                20,
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                5,
                                                                          ),
                                                                          Text(
                                                                            e.itemEntity.barcode,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      ((e.itemEntity.shortName !=
                                                                              "")
                                                                          ? e.itemEntity.shortName ??
                                                                              e.itemEntity.itemName
                                                                          : e.itemEntity.itemName),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 1,
                                                                child: Column(
                                                                  // QuantityUI
                                                                  children: [
                                                                    Text(
                                                                      "${Helpers.cleanDecimal(e.quantity, 3)} x",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .right,
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 1,
                                                                child: Column(
                                                                  // PriceUI
                                                                  children: [
                                                                    Text(
                                                                      "@ ${Helpers.parseMoney((e.sellingPrice).round())}",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .right,
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 1,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  // TotalPriceUI
                                                                  children: [
                                                                    Text(
                                                                      Helpers.parseMoney((e.sellingPrice *
                                                                              e.quantity)
                                                                          .round()),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 6,
                                                                    ),
                                                                    e.tohemId !=
                                                                                null ||
                                                                            state.salesTohemId !=
                                                                                null
                                                                        ? FutureBuilder(
                                                                            future:
                                                                                getSalesPerson(e.tohemId, state.salesTohemId),
                                                                            builder: (context, snapshot) {
                                                                              if (snapshot.hasData) {
                                                                                return Text(
                                                                                  snapshot.data?.empName ?? "",
                                                                                  textAlign: TextAlign.right,
                                                                                  style: const TextStyle(height: 1, fontSize: 12, fontWeight: FontWeight.w500),
                                                                                );
                                                                              } else {
                                                                                return const SizedBox.shrink();
                                                                              }
                                                                            })
                                                                        : const SizedBox.shrink(),
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 20,
                                                              )
                                                            ],
                                                          ),
                                                          // SHOW PROMO HERE
                                                          ...test,
                                                          if (e.quantity < 0 &&
                                                              (test.isNotEmpty ||
                                                                  e.tohemId !=
                                                                      null ||
                                                                  e.tohemId !=
                                                                      ""))
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                          if (e.quantity < 0 &&
                                                              e.refpos3 != null)
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerRight,
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .fromLTRB(
                                                                          10,
                                                                          2,
                                                                          10,
                                                                          2),
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    // border: Border.all(
                                                                    //     color: Color.fromRGBO(195, 53, 53, 1),
                                                                    //     width: 4.0),
                                                                    borderRadius:
                                                                        BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(5)),

                                                                    color: Colors
                                                                        .orange,
                                                                    // boxShadow: [
                                                                    //   BoxShadow(
                                                                    //     spreadRadius: 0.5,
                                                                    //     blurRadius: 5,
                                                                    //     color: Color.fromRGBO(0, 0, 0, 0.111),
                                                                    //   ),
                                                                    // ],
                                                                  ),
                                                                  child:
                                                                      const Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Text(
                                                                          "Return",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                          )),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const Divider(
                                              height: 1,
                                              thickness: 0.5,
                                              color: Color.fromARGB(
                                                  100, 118, 118, 118),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                    child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 40,
                      ),
                      const Spacer(
                        flex: 3,
                      ),
                      Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Container(
                              height: 25,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
                              decoration: const BoxDecoration(
                                // border: Border.all(
                                //     color: Color.fromRGBO(195, 53, 53, 1),
                                //     width: 4.0),
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(10)),

                                color: ProjectColors.primary,
                                boxShadow: [
                                  BoxShadow(
                                    spreadRadius: 0.5,
                                    blurRadius: 5,
                                    color: Color.fromRGBO(0, 0, 0, 0.248),
                                  ),
                                ],
                              ),
                              child: FittedBox(
                                child: Text(
                                  "Total Qty.  ${Helpers.cleanDecimal(state.receiptItems.isEmpty ? 0 : state.receiptItems.map((e) => e.quantity).reduce((value, element) => value + element), 3)}",
                                  style: const TextStyle(
                                    height: 1,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )),
                      const Spacer(
                        flex: 2,
                      ),
                    ],
                  ),
                ))
              ])),
        );
      },
    );
    // End - Item List
  }

  Widget _receiptItemForm() {
    return FocusScope(
      autofocus: true,
      child: Container(
          decoration: BoxDecoration(
            color: indexIsSelect[1] == 1
                ? const Color.fromARGB(20, 169, 0, 0)
                : Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                spreadRadius: 0.5,
                blurRadius: 5,
                color: Color.fromRGBO(220, 220, 220, 1),
              )
            ],
          ),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 25,
                width: double.infinity,
                decoration: const BoxDecoration(
                  // border: Border.all(
                  //     color: Color.fromRGBO(195, 53, 53, 1),
                  //     width: 4.0),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
                  color: ProjectColors.primary,
                ),
                child: const Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                          "Qty",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Center(
                        child: Text(
                          "Item Code",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(
                              20,
                              0,
                              20,
                              (isEditingNewReceiptItemQty ||
                                      isUpdatingReceiptItemQty)
                                  ? 10
                                  : 0),
                          child: Center(
                            child: (isEditingNewReceiptItemQty ||
                                    isUpdatingReceiptItemQty)
                                ? SizedBox(
                                    height: 40,
                                    child: KeyboardListener(
                                      onKeyEvent: (event) => handlePhysicalKeyboard(
                                          event,
                                          _textEditingControllerNewReceiptItemQuantity,
                                          _newReceiptItemQuantityFocusNode,
                                          true,
                                          context),
                                      focusNode: FocusNode(
                                        canRequestFocus: false,
                                      ),
                                      child: TextField(
                                        // readOnly: !isEditingReceiptItemQty,
                                        focusNode:
                                            _newReceiptItemQuantityFocusNode,
                                        controller:
                                            _textEditingControllerNewReceiptItemQuantity,
                                        enableInteractiveSelection: false,
                                        // showCursor: false,
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.none,
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500),
                                        decoration: const InputDecoration(
                                            isCollapsed: true,
                                            contentPadding: EdgeInsets.fromLTRB(
                                                0, 0, 0, 10)),
                                      ),
                                    ),
                                  )
                                : SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      _textEditingControllerNewReceiptItemQuantity
                                          .text,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                  ),
                          ),
                        )),
                    Expanded(
                      flex: 5,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                          child: isEditingNewReceiptItemCode
                              ? KeyboardListener(
                                  onKeyEvent: (event) {
                                    handlePhysicalKeyboard(
                                      event,
                                      _textEditingControllerNewReceiptItemCode,
                                      _newReceiptItemCodeFocusNode,
                                      false,
                                      context,
                                    );
                                  },
                                  focusNode: FocusNode(
                                    canRequestFocus: false,
                                  ),
                                  child: SizedBox(
                                    height: 40,
                                    child: TextField(
                                      // "00000001283",
                                      // enabled: !isEditingReceiptItemQty,
                                      // readOnly: isEditingReceiptItemQty,

                                      autofocus: true,
                                      focusNode: _newReceiptItemCodeFocusNode,
                                      controller:
                                          _textEditingControllerNewReceiptItemCode,
                                      enableInteractiveSelection: false,
                                      // showCursor: false,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.none,
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w500),
                                      decoration: const InputDecoration(
                                          hintText:
                                              "Scan or Type an Item Barcode",
                                          hintStyle: TextStyle(
                                            fontSize: 18,
                                            fontStyle: FontStyle.italic,
                                          ),
                                          isCollapsed: true,
                                          contentPadding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 10)),
                                    ),
                                  ),
                                )
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: _textEditingControllerNewReceiptItemCode
                                          .text.isEmpty
                                      ? const Text(
                                          "Scan or Type an Item Barcode",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontStyle: FontStyle.italic))
                                      : Text(
                                          _textEditingControllerNewReceiptItemCode
                                              .text,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 24)),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }

  Widget _buttonGroup1V1() {
    return Expanded(
      flex: 3,
      child: ExcludeFocus(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(
                    child: SizedBox.expand(
                      child: OutlinedButton(
                          onPressed: () async {
                            // await context.read<ReceiptCubit>().resetReceipt();
                            setState(() {});
                            // Navigator.pop(context);
                            context.goNamed(RouteConstants.home);
                          },
                          style: OutlinedButton.styleFrom(
                            elevation: 5,
                            shadowColor: Colors.black87,
                            backgroundColor: ProjectColors.primary,
                            padding: const EdgeInsets.all(3),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            side: BorderSide.none,
                          ),
                          child: const Icon(Icons.home_outlined)),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: SizedBox.expand(
                      child: OutlinedButton(
                        onPressed: () {
                          context.read<ReceiptCubit>().resetReceipt();
                          setState(() {
                            isEditingNewReceiptItemQty = false;
                            isUpdatingReceiptItemQty = false;
                            isEditingNewReceiptItemCode = true;
                            _newReceiptItemCodeFocusNode.requestFocus();
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          elevation: 5,
                          shadowColor: Colors.black87,
                          backgroundColor: ProjectColors.primary,
                          padding: const EdgeInsets.all(3),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          side: BorderSide.none,
                        ),
                        child: const Icon(Icons.remove_shopping_cart_outlined),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                              onPressed: () async {
                                bool receiveDP = await checkItemDP();
                                if (mounted) {
                                  await showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        InvoiceDetailsDialog(
                                            receiveDP: receiveDP),
                                  );
                                }
                                setState(() {
                                  isEditingNewReceiptItemCode = true;
                                  Future.delayed(
                                      const Duration(milliseconds: 50),
                                      () => _newReceiptItemCodeFocusNode
                                          .requestFocus());
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                elevation: 5,
                                shadowColor: Colors.black87,
                                padding:
                                    const EdgeInsets.fromLTRB(10, 3, 10, 3),
                                foregroundColor: Colors.white,
                                backgroundColor: ProjectColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                side: BorderSide.none,
                              ),
                              child: const SizedBox(
                                height: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Header Attr.",
                                      softWrap: true,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Text(
                                          "F2",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: TapRegion(
                            groupId: 1,
                            child: OutlinedButton(
                                onPressed: indexIsSelect[1] == 0
                                    ? null
                                    : () {
                                        final ReceiptItemEntity
                                            receiptItemTarget = context
                                                .read<ReceiptCubit>()
                                                .state
                                                .receiptItems[indexIsSelect[0]];
                                        log("receiptTarget - $receiptItemTarget");
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              ItemDetailsDialog(
                                                  indexSelected:
                                                      indexIsSelect[0]),
                                        ).then((value) {
                                          setState(() {
                                            indexIsSelect = [-1, 0];
                                            _textEditingControllerNewReceiptItemQuantity
                                                .text = "1";
                                            _textEditingControllerNewReceiptItemCode
                                                .text = "";
                                            _newReceiptItemQuantityFocusNode
                                                .unfocus();
                                            isUpdatingReceiptItemQty = false;
                                            isEditingNewReceiptItemCode = true;
                                            _newReceiptItemCodeFocusNode
                                                .requestFocus();
                                          });
                                        });
                                      },
                                style: OutlinedButton.styleFrom(
                                  elevation: 5,
                                  shadowColor: Colors.black87,
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 3, 10, 3),
                                  foregroundColor: Colors.white,
                                  backgroundColor: indexIsSelect[0] == -1
                                      ? ProjectColors.lightBlack
                                      : ProjectColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  side: BorderSide.none,
                                ),
                                child: const SizedBox(
                                  height: double.infinity,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Item Attr.",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "F1",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Expanded(
                    child: SizedBox.expand(
                      child: OutlinedButton(
                          onPressed: null,
                          // onPressed: () async {
                          //   setState(() {
                          //     isEditingNewReceiptItemCode = false;
                          //     isEditingNewReceiptItemQty = false;
                          //     isUpdatingReceiptItemQty = false;
                          //   });

                          //   await showDialog(
                          //       context: context,
                          //       barrierDismissible: false,
                          //       builder: (context) => const InputCouponsDialog());

                          //   setState(() {
                          //     isEditingNewReceiptItemCode = true;
                          //     Future.delayed(
                          //         const Duration(milliseconds: 50), () => _newReceiptItemCodeFocusNode.requestFocus());
                          //   });
                          // },
                          style: OutlinedButton.styleFrom(
                            elevation: 5,
                            shadowColor: Colors.black87,
                            padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                            foregroundColor: Colors.grey,
                            backgroundColor: ProjectColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            side: BorderSide.none,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Coupon",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey),
                              ),
                              Text(
                                "F5",
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.grey),
                              ),
                            ],
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: SizedBox.expand(
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              isEditingNewReceiptItemCode = false;
                              isEditingNewReceiptItemQty = false;
                              isUpdatingReceiptItemQty = false;
                            });

                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) =>
                                    const QueueListDialog()).then((value) {
                              setState(() {
                                context.read<ItemsCubit>().clearItems();
                                isEditingNewReceiptItemCode = true;
                                _newReceiptItemCodeFocusNode.requestFocus();
                              });
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            elevation: 5,
                            shadowColor: Colors.black87,
                            backgroundColor: ProjectColors.primary,
                            padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            side: BorderSide.none,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Pending Orders",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "F4",
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            // Expanded(
            //   flex: 2,
            //   child: SizedBox(
            //     height: double.infinity,
            //     child: OutlinedButton(
            //       onPressed: () {
            //         context.read<ReceiptCubit>().resetReceipt();
            //         setState(() {});
            //       },
            //       style: OutlinedButton.styleFrom(
            //         elevation: 5,
            //         shadowColor: Colors.black87,
            //         backgroundColor: ProjectColors.primary,
            //         padding: const EdgeInsets.all(25),
            //         foregroundColor: Colors.white,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(5),
            //         ),
            //         side: BorderSide.none,
            //       ),
            //       child: SizedBox.expand(
            //         child: FittedBox(
            //           fit: BoxFit.cover,
            //           child: Icon(
            //             Icons.search,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buttonGroup1V2() {
    return Expanded(
      flex: 3,
      child: ExcludeFocus(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox.expand(
                      child: OutlinedButton(
                          onPressed: () {
                            // context.read<ReceiptCubit>().resetReceipt();
                            setState(() {});
                            context.goNamed(RouteConstants.home);
                          },
                          style: OutlinedButton.styleFrom(
                            elevation: 5,
                            shadowColor: Colors.black87,
                            backgroundColor: ProjectColors.primary,
                            padding: const EdgeInsets.all(3),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            side: BorderSide.none,
                          ),
                          child: const Icon(Icons.home_outlined)),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: SizedBox.expand(
                      child: OutlinedButton(
                        onPressed: () {
                          context.read<ReceiptCubit>().resetReceipt();
                          setState(() {
                            isEditingNewReceiptItemQty = false;
                            isUpdatingReceiptItemQty = false;
                            isEditingNewReceiptItemCode = true;
                            _newReceiptItemCodeFocusNode.requestFocus();
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          elevation: 5,
                          shadowColor: Colors.black87,
                          backgroundColor: ProjectColors.primary,
                          padding: const EdgeInsets.all(3),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          side: BorderSide.none,
                        ),
                        child: const Icon(Icons.remove_shopping_cart_outlined),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                              onPressed: () async {
                                bool receiveDP = await checkItemDP();
                                if (mounted) {
                                  await showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        InvoiceDetailsDialog(
                                            receiveDP: receiveDP),
                                  );
                                }
                                setState(() {
                                  isEditingNewReceiptItemCode = true;
                                  Future.delayed(
                                      const Duration(milliseconds: 50),
                                      () => _newReceiptItemCodeFocusNode
                                          .requestFocus());
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                elevation: 5,
                                shadowColor: Colors.black87,
                                padding:
                                    const EdgeInsets.fromLTRB(10, 3, 10, 3),
                                foregroundColor: Colors.white,
                                backgroundColor: ProjectColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                side: BorderSide.none,
                              ),
                              child: const SizedBox(
                                height: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Header Attr.",
                                      softWrap: true,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Text(
                                          "F2",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: TapRegion(
                            groupId: 1,
                            child: OutlinedButton(
                                onPressed: indexIsSelect[1] == 0
                                    ? null
                                    : () {
                                        final ReceiptItemEntity
                                            receiptItemTarget = context
                                                .read<ReceiptCubit>()
                                                .state
                                                .receiptItems[indexIsSelect[0]];
                                        log("receiptTarget - $receiptItemTarget");
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              ItemDetailsDialog(
                                                  indexSelected:
                                                      indexIsSelect[0]),
                                        ).then((value) {
                                          setState(() {
                                            indexIsSelect = [-1, 0];
                                            _textEditingControllerNewReceiptItemQuantity
                                                .text = "1";
                                            _textEditingControllerNewReceiptItemCode
                                                .text = "";
                                            _newReceiptItemQuantityFocusNode
                                                .unfocus();
                                            isUpdatingReceiptItemQty = false;
                                            isEditingNewReceiptItemCode = true;
                                            _newReceiptItemCodeFocusNode
                                                .requestFocus();
                                          });
                                        });
                                      },
                                style: OutlinedButton.styleFrom(
                                  elevation: 5,
                                  shadowColor: Colors.black87,
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 3, 10, 3),
                                  foregroundColor: Colors.white,
                                  backgroundColor: indexIsSelect[0] == -1
                                      ? ProjectColors.lightBlack
                                      : ProjectColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  side: BorderSide.none,
                                ),
                                child: const SizedBox(
                                  height: double.infinity,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Item Attr.",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "F1",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox.expand(
                      child: OutlinedButton(
                          onPressed: null,

                          // onPressed: () async {
                          //   setState(() {
                          //     isEditingNewReceiptItemCode = false;
                          //     isEditingNewReceiptItemQty = false;
                          //     isUpdatingReceiptItemQty = false;
                          //   });

                          //   await showDialog(
                          //       context: context,
                          //       barrierDismissible: false,
                          //       builder: (context) => const InputCouponsDialog());

                          //   setState(() {
                          //     isEditingNewReceiptItemCode = true;
                          //     Future.delayed(
                          //         const Duration(milliseconds: 50), () => _newReceiptItemCodeFocusNode.requestFocus());
                          //   });
                          // },
                          style: OutlinedButton.styleFrom(
                            elevation: 5,
                            shadowColor: Colors.black87,
                            padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                            foregroundColor: Colors.grey,
                            backgroundColor: ProjectColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            side: BorderSide.none,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Coupon",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey),
                              ),
                              Text(
                                "F5",
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.grey),
                              ),
                            ],
                          )),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: SizedBox.expand(
                      child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              isEditingNewReceiptItemCode = false;
                              isEditingNewReceiptItemQty = false;
                              isUpdatingReceiptItemQty = false;
                            });

                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) =>
                                    const QueueListDialog()).then((value) {
                              setState(() {
                                context.read<ItemsCubit>().clearItems();
                                isEditingNewReceiptItemCode = true;
                                _newReceiptItemCodeFocusNode.requestFocus();
                              });
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            elevation: 5,
                            shadowColor: Colors.black87,
                            backgroundColor: ProjectColors.primary,
                            padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            side: BorderSide.none,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Pending Orders",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "F4",
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonGroup1V3() {
    return ExcludeFocus(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 5,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            bool receiveDP = await checkItemDP();
                            if (mounted) {
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    InvoiceDetailsDialog(receiveDP: receiveDP),
                              );
                            }
                            setState(() {
                              isEditingNewReceiptItemCode = true;
                              Future.delayed(
                                  const Duration(milliseconds: 50),
                                  () => _newReceiptItemCodeFocusNode
                                      .requestFocus());
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            elevation: 5,
                            shadowColor: Colors.black87,
                            padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                            foregroundColor: Colors.white,
                            backgroundColor: ProjectColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            side: BorderSide.none,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(2, 8, 2, 8),
                            child: Stack(
                              children: [
                                const Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "F2",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: RichText(
                                      textAlign: TextAlign.left,
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Header\nAttributes",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            await checkItemDPAvailability();
                            if (!isMember) {
                              SnackBarHelper.presentErrorSnackBar(context,
                                  "Please select the customer first, only customer with membership can use Down Payment");
                              return;
                            }
                            if (!itemDPAvailable) {
                              SnackBarHelper.presentErrorSnackBar(context,
                                  "Item Down Payment not found for this store");
                              return;
                            }

                            if (mounted) {
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    const DownPaymentDialog(),
                              );
                            }
                            setState(() {
                              isEditingNewReceiptItemCode = true;
                              Future.delayed(
                                  const Duration(milliseconds: 50),
                                  () => _newReceiptItemCodeFocusNode
                                      .requestFocus());
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            elevation: 5,
                            shadowColor: Colors.black87,
                            padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                            foregroundColor: Colors.white,
                            backgroundColor: isMember
                                ? ProjectColors.primary
                                : ProjectColors.lightBlack,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            side: BorderSide.none,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(2, 8, 2, 8),
                            child: Stack(
                              children: [
                                const Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: RichText(
                                      textAlign: TextAlign.left,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Down\nPayment",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: isMember
                                                    ? Colors.white
                                                    : Colors.grey),
                                          ),
                                        ],
                                      ),
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: TapRegion(
                          groupId: 1,
                          child: OutlinedButton(
                            onPressed: (indexIsSelect[1] == 0 ||
                                    context
                                            .read<ReceiptCubit>()
                                            .state
                                            .receiptItems[indexIsSelect[0]]
                                            .itemEntity
                                            .itemCode ==
                                        '99' ||
                                    context
                                            .read<ReceiptCubit>()
                                            .state
                                            .receiptItems[indexIsSelect[0]]
                                            .itemEntity
                                            .itemCode ==
                                        '08700000002')
                                ? null
                                : () {
                                    context
                                        .read<ReceiptCubit>()
                                        .state
                                        .receiptItems[indexIsSelect[0]];
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          ItemDetailsDialog(
                                              indexSelected: indexIsSelect[0]),
                                    ).then((value) {
                                      setState(() {
                                        indexIsSelect = [-1, 0];
                                        _textEditingControllerNewReceiptItemQuantity
                                            .text = "1";
                                        _textEditingControllerNewReceiptItemCode
                                            .text = "";
                                        _newReceiptItemQuantityFocusNode
                                            .unfocus();
                                        isUpdatingReceiptItemQty = false;
                                        isEditingNewReceiptItemCode = true;
                                        _newReceiptItemCodeFocusNode
                                            .requestFocus();
                                      });
                                    });
                                  },
                            style: OutlinedButton.styleFrom(
                              elevation: 5,
                              shadowColor: Colors.black87,
                              padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                              foregroundColor: Colors.white,
                              backgroundColor: (indexIsSelect[1] == 0 ||
                                      context
                                              .read<ReceiptCubit>()
                                              .state
                                              .receiptItems[indexIsSelect[0]]
                                              .itemEntity
                                              .itemCode ==
                                          '99' ||
                                      context
                                              .read<ReceiptCubit>()
                                              .state
                                              .receiptItems[indexIsSelect[0]]
                                              .itemEntity
                                              .itemCode ==
                                          '08700000002')
                                  ? ProjectColors.lightBlack
                                  : ProjectColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              side: BorderSide.none,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(2, 8, 2, 8),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "F1",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 14,
                                                color: (indexIsSelect[1] == 0 ||
                                                        context
                                                                .read<
                                                                    ReceiptCubit>()
                                                                .state
                                                                .receiptItems[
                                                                    indexIsSelect[
                                                                        0]]
                                                                .itemEntity
                                                                .itemCode ==
                                                            '99' ||
                                                        context
                                                                .read<
                                                                    ReceiptCubit>()
                                                                .state
                                                                .receiptItems[
                                                                    indexIsSelect[
                                                                        0]]
                                                                .itemEntity
                                                                .itemCode ==
                                                            '08700000002')
                                                    ? Colors.grey
                                                    : Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: RichText(
                                        textAlign: TextAlign.left,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Item\nAttributes",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                  color: (indexIsSelect[1] ==
                                                              0 ||
                                                          context
                                                                  .read<
                                                                      ReceiptCubit>()
                                                                  .state
                                                                  .receiptItems[
                                                                      indexIsSelect[
                                                                          0]]
                                                                  .itemEntity
                                                                  .itemCode ==
                                                              '99' ||
                                                          context
                                                                  .read<
                                                                      ReceiptCubit>()
                                                                  .state
                                                                  .receiptItems[
                                                                      indexIsSelect[
                                                                          0]]
                                                                  .itemEntity
                                                                  .itemCode ==
                                                              '08700000002')
                                                      ? Colors.grey
                                                      : Colors.white),
                                            ),
                                          ],
                                        ),
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              isEditingNewReceiptItemCode = false;
                              isEditingNewReceiptItemQty = false;
                              isUpdatingReceiptItemQty = false;
                            });

                            final bool? isSaved = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) =>
                                  ScaffoldMessenger(
                                child: Builder(builder: (context) {
                                  return const Scaffold(
                                      backgroundColor: Colors.transparent,
                                      body: ReturnDialog());
                                }),
                              ),
                            );

                            if (isSaved != null && isSaved) {
                              SnackBarHelper.presentSuccessSnackBar(
                                  context, "Save return items success", null);
                            }

                            setState(() {
                              isEditingNewReceiptItemCode = true;
                              Future.delayed(
                                  const Duration(milliseconds: 50),
                                  () => _newReceiptItemCodeFocusNode
                                      .requestFocus());
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            elevation: 5,
                            shadowColor: Colors.black87,
                            padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                            foregroundColor: Colors.white,
                            backgroundColor: ProjectColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            side: BorderSide.none,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(2, 8, 2, 8),
                            child: Stack(
                              children: [
                                const Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: RichText(
                                      textAlign: TextAlign.left,
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Return",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                children: [
                  BlocBuilder<ReceiptCubit, ReceiptEntity>(
                    builder: (context, state) {
                      return Expanded(
                        child: SizedBox.expand(
                          child: OutlinedButton(
                            // onPressed: null,
                            onPressed: () async {
                              bool checkDP = await checkItemDP();

                              if (checkDP) {
                                if (context.mounted) {
                                  SnackBarHelper.presentErrorSnackBar(context,
                                      "Coupons are not applicable to Down Payment");
                                }
                                return;
                              }

                              setState(() {
                                isEditingNewReceiptItemCode = false;
                                isEditingNewReceiptItemQty = false;
                                isUpdatingReceiptItemQty = false;
                              });

                              await showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) =>
                                      const InputCouponsDialog());

                              setState(() {
                                isEditingNewReceiptItemCode = true;
                                Future.delayed(
                                    const Duration(milliseconds: 50),
                                    () => _newReceiptItemCodeFocusNode
                                        .requestFocus());
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              elevation: 5,
                              shadowColor: Colors.black87,
                              padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                              foregroundColor: Colors.white,
                              // foregroundColor: Colors.grey,

                              backgroundColor: ProjectColors.primary,
                              // backgroundColor: ProjectColors.lightBlack,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              side: BorderSide.none,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(2, 8, 2, 8),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              width: 20.0,
                                              height: 20.0,
                                              alignment: Alignment.center,
                                              decoration: const BoxDecoration(
                                                color: ProjectColors.green,
                                                // color: Colors.black54,

                                                shape: BoxShape.circle,
                                              ),
                                              child: Text(
                                                context
                                                    .read<ReceiptCubit>()
                                                    .state
                                                    .coupons
                                                    .length
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 12,
                                                ),
                                              )),
                                          const Text(
                                            "F5",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: RichText(
                                        textAlign: TextAlign.left,
                                        text: const TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Coupon",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: SizedBox.expand(
                      child: OutlinedButton(
                        onPressed: () async {
                          setState(() {
                            isEditingNewReceiptItemCode = false;
                            isEditingNewReceiptItemQty = false;
                            isUpdatingReceiptItemQty = false;
                          });
                          await showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const QueueListDialog())
                              .then((value) {
                            setState(() {
                              context.read<ItemsCubit>().clearItems();
                              isEditingNewReceiptItemCode = true;
                              _newReceiptItemCodeFocusNode.requestFocus();
                            });
                          });
                          await checkReceiptWithMember(
                              context.read<ReceiptCubit>().state);
                        },
                        style: OutlinedButton.styleFrom(
                          elevation: 5,
                          shadowColor: Colors.black87,
                          backgroundColor: ProjectColors.primary,
                          padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          side: BorderSide.none,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(2, 8, 2, 8),
                          child: Stack(
                            children: [
                              const Positioned.fill(
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "F4",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: RichText(
                                    textAlign: TextAlign.left,
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Order\nList",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // const SizedBox(
          //   width: 5,
          // ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Expanded(
                  child: SizedBox.expand(
                    child: OutlinedButton(
                        onPressed: () async {
                          log("${context.read<ReceiptCubit>().state.customerEntity}");
                          // await context.read<ReceiptCubit>().resetReceipt();
                          setState(() {});
                          // Navigator.pop(context);
                          context.goNamed(RouteConstants.home);
                        },
                        style: OutlinedButton.styleFrom(
                          elevation: 5,
                          shadowColor: Colors.black87,
                          backgroundColor: ProjectColors.primary,
                          padding: const EdgeInsets.all(3),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          side: BorderSide.none,
                        ),
                        child: const Icon(Icons.home_outlined)),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: SizedBox.expand(
                    child: OutlinedButton(
                      onPressed: () async {
                        await context.read<ReceiptCubit>().resetReceipt();
                        setState(() {
                          isEditingNewReceiptItemQty = false;
                          isUpdatingReceiptItemQty = false;
                          isEditingNewReceiptItemCode = true;
                          // isMember = false;
                          _newReceiptItemCodeFocusNode.requestFocus();
                        });
                        await checkReceiptWithMember(
                            context.read<ReceiptCubit>().state);
                      },
                      style: OutlinedButton.styleFrom(
                        elevation: 5,
                        shadowColor: Colors.black87,
                        backgroundColor: ProjectColors.primary,
                        padding: const EdgeInsets.all(3),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        side: BorderSide.none,
                      ),
                      child: const Icon(Icons.remove_shopping_cart_outlined),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _transactionSummaryV1() {
    return BlocBuilder<ReceiptCubit, ReceiptEntity>(
      builder: (context, state) {
        return Expanded(
          flex: 6,
          child: Container(
              decoration: BoxDecoration(
                // border: Border.all(
                //     color: Color.fromRGBO(195, 53, 53, 1),
                //     width: 4.0),
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    spreadRadius: 0.5,
                    blurRadius: 5,
                    color: Color.fromRGBO(220, 220, 220, 1),
                  )
                ],
              ),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(5)),
                      color: ProjectColors.primary,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.assignment_ind_outlined,
                                      color: Colors.white),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    GetIt.instance<SharedPreferences>()
                                            .getString("username") ??
                                        "-",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              decoration: BoxDecoration(
                                  // color: Color.fromRGBO(
                                  //     71, 168, 0, 1),
                                  borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(Icons.schedule,
                                      color: Colors.white),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  ValueListenableBuilder<String>(
                                    valueListenable: currentTime,
                                    builder: (context, value, child) {
                                      return Text(
                                        value,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Expanded(
                    child: Scrollbar(
                      controller: _scrollControllerReceiptSummary,
                      thumbVisibility: true,
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        controller: _scrollControllerReceiptSummary,
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Subtotal",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                Helpers.parseMoney(
                                    (state.subtotal - (state.discAmount ?? 0))
                                        .round()),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Header Discount",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "(${Helpers.parseMoney((state.discHeaderManual ?? 0).round())})",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Total Tax",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                Helpers.parseMoney(state.taxAmount.round()),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Rounding",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                Helpers.parseMoney(state.rounding.round()),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(
                      thickness: 1,
                      color: Color.fromARGB(100, 118, 118, 118),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Grand Total",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          Helpers.parseMoney(state.grandTotal.round()),
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buttonGroup2()
                ],
              )),
        );
      },
    );
  }

  Widget _transactionSummaryV2() {
    return BlocBuilder<ReceiptCubit, ReceiptEntity>(
      builder: (context, state) {
        return Expanded(
          flex: 4,
          child: Container(
              decoration: BoxDecoration(
                // border: Border.all(
                //     color: Color.fromRGBO(195, 53, 53, 1),
                //     width: 4.0),
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    spreadRadius: 0.5,
                    blurRadius: 5,
                    color: Color.fromRGBO(220, 220, 220, 1),
                  )
                ],
              ),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(5)),
                      color: ProjectColors.primary,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.assignment_ind_outlined,
                                      color: Colors.white),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    GetIt.instance<SharedPreferences>()
                                            .getString("username") ??
                                        "-",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              decoration: BoxDecoration(
                                  // color: Color.fromRGBO(
                                  //     71, 168, 0, 1),
                                  borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(Icons.schedule,
                                      color: Colors.white),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  ValueListenableBuilder<String>(
                                    valueListenable: currentTime,
                                    builder: (context, value, child) {
                                      return Text(
                                        value,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Grand Total",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          Helpers.parseMoney(state.grandTotal.round()),
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 2, 10, 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        (state.rounding.roundToDouble().abs() != 0)
                            ? _noteChip((state.rounding).roundToDouble(), 1)
                            : const SizedBox.shrink(),
                        (state.downPayments != null &&
                                state.downPayments!.isNotEmpty &&
                                state.downPayments!.any((dp) =>
                                    dp.isReceive == false &&
                                    dp.isSelected == true))
                            ? _noteChip(
                                (state.downPayments ?? []).fold(
                                  0.0,
                                  (total, dp) =>
                                      (dp.isSelected == true && dp.amount != 0)
                                          ? total + dp.amount
                                          : total,
                                ),
                                2)
                            : const SizedBox.shrink(),
                        (state.discHeaderManual ?? 0) != 0
                            ? _noteChip((state.discHeaderManual ?? 0), 3)
                            : const SizedBox.shrink(),
                        state.receiptItems.any((e1) =>
                                e1.promos.any((e2) => e2.promoType == 998))
                            ? _noteChip(
                                state.receiptItems.fold(
                                    0.0,
                                    (previousValue, e1) =>
                                        previousValue +
                                        (((100 + e1.itemEntity.taxRate) / 100) *
                                            e1.promos
                                                .where(
                                                    (e2) => e2.promoType == 998)
                                                .fold(
                                                    0.0,
                                                    (previousValue, e3) =>
                                                        previousValue +
                                                        (e3.discAmount ?? 0)))),
                                4)
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // const SizedBox(height: 15),
                  _buttonGroup2()
                ],
              )),
        );
      },
    );
  }

  Widget _buttonGroup2() {
    return SizedBox(
        // flex: 1,
        height: 50,
        child: ExcludeFocus(
          child: Row(
            children: [
              Expanded(
                child: SizedBox.expand(
                  child: OutlinedButton(
                    onPressed: () {
                      if (context
                          .read<ReceiptCubit>()
                          .state
                          .receiptItems
                          .isEmpty) {
                        return SnackBarHelper.presentErrorSnackBar(
                            context, "Receipt cannot be empty");
                      }
                      context.read<ReceiptCubit>().queueReceipt();
                      SnackBarHelper.presentSuccessSnackBar(
                          context, "Pending order added", 3);

                      setState(() {
                        isEditingNewReceiptItemQty = false;
                        isUpdatingReceiptItemQty = false;
                        isEditingNewReceiptItemCode = true;
                        _newReceiptItemCodeFocusNode.requestFocus();
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
                      // elevation: 5,
                      backgroundColor: ProjectColors.primary,
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                          // bottomRight: Radius.circular(5),
                        ),
                      ),
                      side: BorderSide.none,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.queue_outlined),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Pending Order",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "F11",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: SizedBox.expand(
                  child: OutlinedButton(
                    onPressed: () async {
                      await checkout();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
                      // elevation: 5,
                      backgroundColor: ProjectColors.green,
                      // 48, 107, 52
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(5),
                          topLeft: Radius.circular(5),
                          // bottomLeft: Radius.circular(5),
                        ),
                      ),
                      side: BorderSide.none,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.receipt_long_rounded),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Checkout",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                          ],
                        ),
                        Text(
                          "F12",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buttonGroup3() {
    return Expanded(
      flex: 2,
      child: ExcludeFocus(
        child: Column(
          children: [
            Expanded(
              child: SizedBox.expand(
                child: OutlinedButton(
                  onPressed: () async {
                    setState(() {
                      isEditingNewReceiptItemCode = false;
                      isEditingNewReceiptItemQty = false;
                      isUpdatingReceiptItemQty = false;
                    });

                    final ItemEntity? itemEntitySearch =
                        await showDialog<ItemEntity>(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const ItemSearchDialog());

                    if (itemEntitySearch != null) {
                      await addUpdateReceiptItems(AddUpdateReceiptItemsParams(
                          barcode: null,
                          itemEntity: itemEntitySearch,
                          quantity: double.parse(
                              _textEditingControllerNewReceiptItemQuantity
                                  .text),
                          context: context,
                          onOpenPriceInputted: () => setState(() {
                                isEditingNewReceiptItemCode = true;
                                _newReceiptItemCodeFocusNode.requestFocus();
                              })));
                    }

                    setState(() {
                      context.read<ItemsCubit>().clearItems();
                      isEditingNewReceiptItemCode = true;
                      _newReceiptItemCodeFocusNode.requestFocus();
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    elevation: 5,
                    shadowColor: Colors.black87,
                    backgroundColor: salesViewType == 1
                        ? ProjectColors.primary
                        : ProjectColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: BorderSide.none,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        const Positioned.fill(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "F9",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: RichText(
                              textAlign: TextAlign.left,
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Item\nSearch",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SizedBox.expand(
                child: OutlinedButton(
                  onPressed: () async {
                    setState(() {
                      isEditingNewReceiptItemCode = false;
                      isEditingNewReceiptItemQty = false;
                      isUpdatingReceiptItemQty = false;
                    });
                    return showDialog<void>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const SelectCustomerDialog();
                      },
                    ).then((value) => setState(() {
                          context.read<CustomersCubit>().clearCustomers();
                          isEditingNewReceiptItemCode = true;
                          _newReceiptItemCodeFocusNode.requestFocus();
                          checkReceiptWithMember(
                              context.read<ReceiptCubit>().state);
                        }));
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    elevation: 5,
                    shadowColor: Colors.black87,
                    backgroundColor: salesViewType == 1
                        ? ProjectColors.primary
                        : ProjectColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: BorderSide.none,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        const Positioned.fill(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "F8",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: RichText(
                              textAlign: TextAlign.left,
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Select\nCust.",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SizedBox.expand(
                child: TapRegion(
                  groupId: 1,
                  child: OutlinedButton(
                    onPressed: () async => await removeItem(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      elevation: 5,
                      shadowColor: Colors.black87,
                      backgroundColor: salesViewType == 1
                          ? ProjectColors.primary
                          : ProjectColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      side: BorderSide.none,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          const Positioned.fill(
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "F7",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: RichText(
                                textAlign: TextAlign.left,
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Remove\nItem",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SizedBox.expand(
                child: OutlinedButton(
                  onPressed: () => setState(() {
                    if (isEditingNewReceiptItemQty == false) {
                      isEditingNewReceiptItemQty = true;
                      isEditingNewReceiptItemCode = false;
                      _textEditingControllerNewReceiptItemQuantity.text = "";
                      // _newReceiptItemCodeFocusNode.unfocus();
                      _newReceiptItemQuantityFocusNode.requestFocus();
                    } else {
                      isEditingNewReceiptItemQty = false;
                      isEditingNewReceiptItemCode = true;
                      final double? qtyToDouble = double.tryParse(
                          _textEditingControllerNewReceiptItemQuantity.text);
                      _textEditingControllerNewReceiptItemQuantity
                          .text = qtyToDouble ==
                              null
                          ? "1"
                          : Helpers.cleanDecimal(
                              double.parse(
                                  _textEditingControllerNewReceiptItemQuantity
                                      .text),
                              3);

                      _newReceiptItemCodeFocusNode.requestFocus();
                    }
                  }),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    elevation: isEditingNewReceiptItemQty ? 0 : 5,
                    shadowColor: Colors.black87,
                    backgroundColor: isEditingNewReceiptItemQty
                        ? const Color.fromARGB(255, 113, 0, 0)
                        : salesViewType == 1
                            ? ProjectColors.primary
                            : ProjectColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: BorderSide.none,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        const Positioned.fill(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "F6",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: RichText(
                              textAlign: TextAlign.left,
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Order\nQuantity",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    // End - Menu 2
  }

  Widget _numpad() {
    return // Start - Num Only Keypad
        Expanded(
      flex: 8,
      child: ExcludeFocus(
        child: TapRegion(
          groupId: isUpdatingReceiptItemQty ? 1 : null,
          onTapOutside: (event) {
            // log("ontapoutside");
            if (ModalRoute.of(context)?.isCurrent != true) return;

            if (isUpdatingReceiptItemQty) {
              setState(() {
                indexIsSelect = [-1, 0];
                _textEditingControllerNewReceiptItemQuantity.text = "1";
                _textEditingControllerNewReceiptItemCode.text = "";
                _newReceiptItemQuantityFocusNode.unfocus();
                isUpdatingReceiptItemQty = false;
                isEditingNewReceiptItemCode = true;
                _newReceiptItemCodeFocusNode.requestFocus();
              });
            } else if (isEditingNewReceiptItemQty) {
              setState(() {
                isEditingNewReceiptItemQty = false;
                isEditingNewReceiptItemCode = true;
                final double? qtyToDouble = double.tryParse(
                    _textEditingControllerNewReceiptItemQuantity.text);
                _textEditingControllerNewReceiptItemQuantity
                    .text = qtyToDouble == null ||
                        qtyToDouble == 0
                    ? "1"
                    : Helpers.cleanDecimal(
                        double.parse(
                            _textEditingControllerNewReceiptItemQuantity.text),
                        3);

                _newReceiptItemCodeFocusNode.requestFocus();
              });
            } else {
              setState(() {
                // indexIsSelect = [-1, 0];
                // _textEditingControllerNewReceiptItemQuantity.text = "1";
                // _textEditingControllerNewReceiptItemCode.text = "";
                _newReceiptItemQuantityFocusNode.unfocus();
                isUpdatingReceiptItemQty = false;
                isEditingNewReceiptItemCode = true;

                Future.delayed(const Duration(milliseconds: 20),
                    () => _newReceiptItemCodeFocusNode.requestFocus());
              });
            }
          },
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          _numpadNumButton("7"),
                          const SizedBox(
                            width: 5,
                          ),
                          _numpadNumButton("8"),
                          const SizedBox(
                            width: 5,
                          ),
                          _numpadNumButton("9"),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _numpadNumButton("4"),
                          const SizedBox(
                            width: 5,
                          ),
                          _numpadNumButton("5"),
                          const SizedBox(
                            width: 5,
                          ),
                          _numpadNumButton("6")
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _numpadNumButton("1"),
                          const SizedBox(
                            width: 5,
                          ),
                          _numpadNumButton("2"),
                          const SizedBox(
                            width: 5,
                          ),
                          _numpadNumButton("3")
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _numpadNumButton("0"),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            flex: 2,
                            child: SizedBox.expand(
                              child: FilledButton(
                                onPressed: () {
                                  setState(() {
                                    if (!_newReceiptItemCodeFocusNode
                                        .hasPrimaryFocus) {
                                      _newReceiptItemCodeFocusNode
                                          .requestFocus();
                                      _textEditingControllerNewReceiptItemCode
                                          .text = "00";
                                    } else if (_newReceiptItemCodeFocusNode
                                        .hasPrimaryFocus) {
                                      _textEditingControllerNewReceiptItemCode
                                          .text += "00";
                                    }
                                  });
                                },
                                style: FilledButton.styleFrom(
                                    elevation: 5,
                                    backgroundColor:
                                        const Color.fromRGBO(48, 48, 48, 1),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                child: const Text(
                                  "00",
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: SizedBox.expand(
                              child: FilledButton(
                                onPressed: () {
                                  if (_newReceiptItemCodeFocusNode
                                      .hasPrimaryFocus) {
                                    final currentLength =
                                        _textEditingControllerNewReceiptItemCode
                                            .text.length;
                                    if (currentLength == 0) return;
                                    _textEditingControllerNewReceiptItemCode
                                            .text =
                                        _textEditingControllerNewReceiptItemCode
                                            .text
                                            .substring(0, currentLength - 1);
                                  } else if (_newReceiptItemQuantityFocusNode
                                      .hasPrimaryFocus) {
                                    final currentLength =
                                        _textEditingControllerNewReceiptItemQuantity
                                            .text.length;
                                    if (currentLength == 0) return;
                                    _textEditingControllerNewReceiptItemQuantity
                                            .text =
                                        _textEditingControllerNewReceiptItemQuantity
                                            .text
                                            .substring(0, currentLength - 1);
                                  }
                                },
                                style: FilledButton.styleFrom(
                                    padding:
                                        const EdgeInsets.fromLTRB(3, 3, 6, 3),
                                    elevation: 5,
                                    backgroundColor:
                                        const Color.fromRGBO(243, 0, 0, 1),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                child: const Icon(
                                  Icons.backspace_outlined,
                                  size: 36,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: SizedBox.expand(
                              child: FilledButton(
                                onPressed: () {
                                  if (_newReceiptItemCodeFocusNode
                                      .hasPrimaryFocus) {
                                    _textEditingControllerNewReceiptItemCode
                                        .text = "";
                                  } else if (_newReceiptItemQuantityFocusNode
                                      .hasPrimaryFocus) {
                                    _textEditingControllerNewReceiptItemQuantity
                                        .text = "";
                                  }
                                },
                                style: FilledButton.styleFrom(
                                    elevation: 5,
                                    backgroundColor:
                                        const Color.fromRGBO(255, 113, 5, 1),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                child: const Text(
                                  "C",
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox.expand(
                        child: FilledButton(
                          onPressed: () async {
                            if (isEditingNewReceiptItemCode) {
                              final double? qtyToDouble = double.tryParse(
                                  _textEditingControllerNewReceiptItemQuantity
                                      .text);
                              if (qtyToDouble == null) {
                                _textEditingControllerNewReceiptItemQuantity
                                    .text = "0";
                              }

                              await addUpdateReceiptItems(
                                  AddUpdateReceiptItemsParams(
                                      barcode:
                                          _textEditingControllerNewReceiptItemCode
                                              .text,
                                      itemEntity: null,
                                      quantity: double.parse(
                                          _textEditingControllerNewReceiptItemQuantity
                                              .text),
                                      context: context,
                                      onOpenPriceInputted: () => setState(() {
                                            isEditingNewReceiptItemCode = true;
                                            _newReceiptItemCodeFocusNode
                                                .requestFocus();
                                          })));
                            } else if (isUpdatingReceiptItemQty) {
                              final double? qtyToDouble = double.tryParse(
                                  _textEditingControllerNewReceiptItemQuantity
                                      .text);
                              if (qtyToDouble == null) {
                                _textEditingControllerNewReceiptItemQuantity
                                    .text = "0";
                              }
                              await addUpdateReceiptItems(
                                  AddUpdateReceiptItemsParams(
                                      barcode:
                                          _textEditingControllerNewReceiptItemCode
                                              .text,
                                      itemEntity: null,
                                      quantity: double.parse(
                                          _textEditingControllerNewReceiptItemQuantity
                                              .text),
                                      context: context,
                                      onOpenPriceInputted: () => setState(() {
                                            isEditingNewReceiptItemCode = true;
                                            _newReceiptItemCodeFocusNode
                                                .requestFocus();
                                          })));
                            } else if (isEditingNewReceiptItemQty) {
                              setState(() {
                                final double? qtyToDouble = double.tryParse(
                                    _textEditingControllerNewReceiptItemQuantity
                                        .text);
                                _textEditingControllerNewReceiptItemQuantity
                                    .text = qtyToDouble == null ||
                                        qtyToDouble == 0
                                    ? "1"
                                    : Helpers.cleanDecimal(
                                        double.parse(
                                            _textEditingControllerNewReceiptItemQuantity
                                                .text),
                                        3);

                                _newReceiptItemQuantityFocusNode.unfocus();
                                isEditingNewReceiptItemQty = false;
                                isEditingNewReceiptItemCode = true;
                                Future.delayed(
                                    const Duration(milliseconds: 20),
                                    () => _newReceiptItemCodeFocusNode
                                        .requestFocus());
                              });
                            }
                          },
                          style: FilledButton.styleFrom(
                              padding: const EdgeInsets.all(3),
                              elevation: 5,
                              backgroundColor:
                                  const Color.fromRGBO(14, 68, 193, 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: const Text(
                            "OK",
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
    // End - Num Only Keypad 60 80 40 40
  }

  Widget _numpadNumButton(String buttonNumber) {
    return Expanded(
      child: SizedBox.expand(
        child: FilledButton(
          onPressed: () {
            setState(() {
              if (!isEditingNewReceiptItemCode &&
                  !isEditingNewReceiptItemQty &&
                  !isUpdatingReceiptItemQty) {
                // log("numpadnumbutton 1");

                _textEditingControllerNewReceiptItemCode.text = buttonNumber;
                Future.delayed(const Duration(milliseconds: 20),
                    () => _newReceiptItemCodeFocusNode.requestFocus());
              } else if (isEditingNewReceiptItemCode) {
                // log("numpadnumbutton 2");

                _textEditingControllerNewReceiptItemCode.text += buttonNumber;
                Future.delayed(const Duration(milliseconds: 20),
                    () => _newReceiptItemCodeFocusNode.requestFocus());
              } else if (isEditingNewReceiptItemQty ||
                  isUpdatingReceiptItemQty) {
                // log("numpadnumbutton 3");

                _textEditingControllerNewReceiptItemQuantity.text +=
                    buttonNumber;
                Future.delayed(const Duration(milliseconds: 20),
                    () => _newReceiptItemQuantityFocusNode.requestFocus());
              }
            });
          },
          style: FilledButton.styleFrom(
              backgroundColor: const Color.fromRGBO(48, 48, 48, 1),
              elevation: 5,
              shadowColor: Colors.black87,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          child: FittedBox(
            child: Text(
              buttonNumber,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }

  // =================================================
  //              [END] Widgets
  // =================================================

  // =================================================
  //             [START] Other Functions
  // =================================================

  void handlePhysicalKeyboard(
    KeyEvent event,
    TextEditingController textEditingController,
    FocusNode textFieldFocusNode,
    bool isNumOnly,
    BuildContext context,
  ) async {
    // log("Handle physical keyboard ${event.physicalKey}");
    if (event.runtimeType == KeyUpEvent) return;
    if (textFieldFocusNode.hasPrimaryFocus) {
      if (event.character != null &&
          RegExp(isNumOnly ? r'^[0-9.]+$' : r'^[A-Za-z0-9_.]+$')
              .hasMatch(event.character!)) {
        if (Platform.isWindows) return;
        textEditingController.text += event.character!;
      } else if (event.physicalKey == PhysicalKeyboardKey.enter ||
          event.physicalKey == (PhysicalKeyboardKey.numpadEnter)) {
        if (_newReceiptItemCodeFocusNode.hasPrimaryFocus) {
          final double? qtyToDouble = double.tryParse(
              _textEditingControllerNewReceiptItemQuantity.text);
          if (qtyToDouble == null) {
            _textEditingControllerNewReceiptItemQuantity.text = "0";
          }
          await addUpdateReceiptItems(AddUpdateReceiptItemsParams(
              barcode: _textEditingControllerNewReceiptItemCode.text,
              itemEntity: null,
              quantity: double.parse(
                  _textEditingControllerNewReceiptItemQuantity.text),
              context: context,
              onOpenPriceInputted: () => setState(() {
                    isEditingNewReceiptItemCode = true;
                    _newReceiptItemCodeFocusNode.requestFocus();
                  })));
        } else if (isUpdatingReceiptItemQty) {
          final double? qtyToDouble = double.tryParse(
              _textEditingControllerNewReceiptItemQuantity.text);
          if (qtyToDouble == null) {
            _textEditingControllerNewReceiptItemQuantity.text = "0";
          }
          await addUpdateReceiptItems(AddUpdateReceiptItemsParams(
              barcode: _textEditingControllerNewReceiptItemCode.text,
              itemEntity: null,
              quantity: double.parse(
                  _textEditingControllerNewReceiptItemQuantity.text),
              context: context,
              onOpenPriceInputted: () => setState(() {
                    isEditingNewReceiptItemCode = true;
                    _newReceiptItemCodeFocusNode.requestFocus();
                  })));
        } else if (_newReceiptItemQuantityFocusNode.hasPrimaryFocus) {
          setState(() {
            final double? qtyToDouble = double.tryParse(
                _textEditingControllerNewReceiptItemQuantity.text);
            _textEditingControllerNewReceiptItemQuantity.text =
                qtyToDouble == null || qtyToDouble == 0
                    ? "1"
                    : Helpers.cleanDecimal(
                        double.parse(
                            _textEditingControllerNewReceiptItemQuantity.text),
                        3);
            // _newReceiptItemQuantityFocusNode.unfocus();
            isEditingNewReceiptItemQty = false;
            isEditingNewReceiptItemCode = true;

            _newReceiptItemCodeFocusNode.requestFocus();
          });
        }
      } else if (event.physicalKey == (PhysicalKeyboardKey.f12)) {
        await checkout();
      } else if (event.physicalKey == (PhysicalKeyboardKey.f11)) {
        if (context.read<ReceiptCubit>().state.receiptItems.isEmpty) {
          return SnackBarHelper.presentErrorSnackBar(
              context, "Receipt cannot be empty");
        }
        context.read<ReceiptCubit>().queueReceipt();
        SnackBarHelper.presentSuccessSnackBar(
            context, "Pending order added", 3);
      } else if (event.physicalKey == (PhysicalKeyboardKey.f9)) {
        setState(() {
          isEditingNewReceiptItemCode = false;
          isEditingNewReceiptItemQty = false;
          isUpdatingReceiptItemQty = false;
        });

        final ItemEntity? itemEntitySearch = await showDialog<ItemEntity>(
            context: context,
            barrierDismissible: false,
            builder: (context) => const ItemSearchDialog());

        if (itemEntitySearch != null) {
          await addUpdateReceiptItems(AddUpdateReceiptItemsParams(
              barcode: null,
              itemEntity: itemEntitySearch,
              quantity: double.parse(
                  _textEditingControllerNewReceiptItemQuantity.text),
              context: context,
              onOpenPriceInputted: () => setState(() {
                    isEditingNewReceiptItemCode = true;
                    _newReceiptItemCodeFocusNode.requestFocus();
                  })));
        }

        setState(() {
          context.read<ItemsCubit>().clearItems();
          isEditingNewReceiptItemCode = true;
          _newReceiptItemCodeFocusNode.requestFocus();
        });
      } else if (event.physicalKey == (PhysicalKeyboardKey.f8)) {
        setState(() {
          isEditingNewReceiptItemCode = false;
          isEditingNewReceiptItemQty = false;
          isUpdatingReceiptItemQty = false;
        });
        return await showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return const SelectCustomerDialog();
          },
        ).then((value) => setState(() {
              context.read<CustomersCubit>().clearCustomers();
              isEditingNewReceiptItemCode = true;
              _newReceiptItemCodeFocusNode.requestFocus();
              checkReceiptWithMember(context.read<ReceiptCubit>().state);
            }));
      } else if (event.physicalKey == (PhysicalKeyboardKey.f7)) {
        await removeItem();
      } else if (event.physicalKey == (PhysicalKeyboardKey.f6)) {
        if (isEditingNewReceiptItemQty == false) {
          isEditingNewReceiptItemQty = true;
          isEditingNewReceiptItemCode = false;
          _textEditingControllerNewReceiptItemQuantity.text = "";
          // _newReceiptItemCodeFocusNode.unfocus();
          _newReceiptItemQuantityFocusNode.requestFocus();
        } else {
          isEditingNewReceiptItemQty = false;
          isEditingNewReceiptItemCode = true;
          final double? qtyToDouble = double.tryParse(
              _textEditingControllerNewReceiptItemQuantity.text);
          _textEditingControllerNewReceiptItemQuantity.text =
              qtyToDouble == null || qtyToDouble == 0
                  ? "1"
                  : Helpers.cleanDecimal(
                      double.parse(
                          _textEditingControllerNewReceiptItemQuantity.text),
                      3);

          // _newReceiptItemQuantityFocusNode.unfocus();
          _newReceiptItemCodeFocusNode.requestFocus();
        }
        setState(() {});
      } else if (event.physicalKey == (PhysicalKeyboardKey.f5)) {
        setState(() {
          isEditingNewReceiptItemCode = false;
          isEditingNewReceiptItemQty = false;
          isUpdatingReceiptItemQty = false;
        });
        await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const InputCouponsDialog());

        setState(() {
          isEditingNewReceiptItemCode = true;
          _newReceiptItemCodeFocusNode.requestFocus();
        });
      } else if (event.physicalKey == (PhysicalKeyboardKey.f4)) {
        setState(() {
          isEditingNewReceiptItemCode = false;
          isEditingNewReceiptItemQty = false;
          isUpdatingReceiptItemQty = false;
        });

        await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const QueueListDialog()).then((value) {
          setState(() {
            context.read<ItemsCubit>().clearItems();
            isEditingNewReceiptItemCode = true;
            _newReceiptItemCodeFocusNode.requestFocus();
          });
        });
        if (context.mounted) {
          await checkReceiptWithMember(context.read<ReceiptCubit>().state);
        }
      } else if (event.physicalKey == (PhysicalKeyboardKey.f2)) {
        bool receiveDP = await checkItemDP();
        if (context.mounted) {
          await showDialog(
            context: context,
            builder: (BuildContext context) =>
                InvoiceDetailsDialog(receiveDP: receiveDP),
          );
        }
        setState(() {
          isEditingNewReceiptItemCode = true;
          Future.delayed(const Duration(milliseconds: 50),
              () => _newReceiptItemCodeFocusNode.requestFocus());
        });
      } else if (event.physicalKey == (PhysicalKeyboardKey.f1)) {
        if (indexIsSelect[1] != 0) {
          // final ReceiptItemEntity receiptItemTarget = context.read<ReceiptCubit>().state.receiptItems[indexIsSelect[0]];
          await showDialog(
            context: context,
            builder: (BuildContext context) =>
                ItemDetailsDialog(indexSelected: indexIsSelect[0]),
          );
          setState(() {
            indexIsSelect = [-1, 0];
            _textEditingControllerNewReceiptItemQuantity.text = "1";
            _textEditingControllerNewReceiptItemCode.text = "";
            _newReceiptItemQuantityFocusNode.unfocus();
            isUpdatingReceiptItemQty = false;
            isEditingNewReceiptItemCode = true;
            _newReceiptItemCodeFocusNode.requestFocus();
          });
        }
      } else {
        textFieldFocusNode.requestFocus();
        setState(() {});
      }
    } else {
      textFieldFocusNode.requestFocus();
      if (event.character != null &&
          RegExp(isNumOnly ? r'^[0-9.]+$' : r'^[A-Za-z0-9_.]+$')
              .hasMatch(event.character!)) {
        textEditingController.text += event.character!;
      }
    }
  }

  Future<void> scrollToReceiptItemByIndex(int index) async {
    if (itemScrollController.isAttached) {
      await itemScrollController.scrollTo(
          index: index,
          duration: const Duration(milliseconds: 10),
          curve: Curves.easeInOutCubic);
    }
  }

  void checkIsEditingNewReceiptItemQty() {
    if (isEditingNewReceiptItemQty) {
      setState(() {
        isEditingNewReceiptItemQty = false;
        isEditingNewReceiptItemCode = true;
        final double? qtyToDouble =
            double.tryParse(_textEditingControllerNewReceiptItemQuantity.text);
        _textEditingControllerNewReceiptItemQuantity.text = qtyToDouble ==
                    null ||
                qtyToDouble == 0
            ? "1"
            : Helpers.cleanDecimal(
                double.parse(_textEditingControllerNewReceiptItemQuantity.text),
                3);

        _newReceiptItemCodeFocusNode.requestFocus();
      });
    }
  }

  Future<void> addUpdateReceiptItems(AddUpdateReceiptItemsParams params) async {
    try {
      if (params.barcode == "99")
        throw "Warning: Modifying the Down Payment quantity is not allowed";

      bool checkDP = await checkItemDP();
      if (checkDP && mounted) {
        SnackBarHelper.presentErrorSnackBar(
            context, "Down payment has to be excluded from other transactions");
        return;
      }

      if (mounted) {
        await context.read<ReceiptCubit>().addUpdateReceiptItems(params);
      }

      indexIsSelect = [-1, 0];
      _textEditingControllerNewReceiptItemCode.text = "";
      _textEditingControllerNewReceiptItemQuantity.text = "1";
      isEditingNewReceiptItemQty = false;
      isUpdatingReceiptItemQty = false;
      isEditingNewReceiptItemCode = true;

      _newReceiptItemQuantityFocusNode.unfocus();
      _newReceiptItemCodeFocusNode.requestFocus();
      isNewItemAdded = true;
      setState(() {});

      Future.delayed(
          const Duration(milliseconds: 400),
          () => setState(() {
                isNewItemAdded = false;
              }));

      if (itemScrollController.isAttached && mounted) {
        await scrollToReceiptItemByIndex(
            context.read<ReceiptCubit>().state.receiptItems.length - 1);
      }
    } catch (e) {
      SnackBarHelper.presentFailSnackBar(params.context, e.toString());

      indexIsSelect = [-1, 0];
      _textEditingControllerNewReceiptItemCode.text = "";
      _textEditingControllerNewReceiptItemQuantity.text = "1";
      isEditingNewReceiptItemQty = false;
      isUpdatingReceiptItemQty = false;
      isEditingNewReceiptItemCode = true;

      _newReceiptItemQuantityFocusNode.unfocus();
      _newReceiptItemCodeFocusNode.requestFocus();
      setState(() {});
    }
  }

  Future<void> checkout() async {
    try {
      if (context.read<ReceiptCubit>().state.receiptItems.isEmpty) {
        return SnackBarHelper.presentErrorSnackBar(
            context, "Receipt cannot be empty");
      }

      // if (context.read<ReceiptCubit>().state.grandTotal < 0) {
      //   return SnackBarHelper.presentErrorSnackBar(context, "Grand total cannot be negative");
      // }

      final ReceiptItemEntity? dpItem = context
          .read<ReceiptCubit>()
          .state
          .receiptItems
          .where((e) => e.itemEntity.barcode == "99")
          .firstOrNull;
      if (dpItem != null &&
          dpItem.quantity > 0 &&
          context.read<ReceiptCubit>().state.receiptItems.length > 1) {
        return SnackBarHelper.presentErrorSnackBar(
            context, "Down payment has to be excluded from other transactions");
      }

      setState(() {
        isEditingNewReceiptItemCode = false;
        isEditingNewReceiptItemQty = false;
        isUpdatingReceiptItemQty = false;
      });

      await _showDialogReturn();

      try {
        final String cashierName =
            GetIt.instance<SharedPreferences>().getString("username") ?? "";
        final UserModel? user = await GetIt.instance<AppDatabase>()
            .userDao
            .readByUsername(cashierName, null);
        List<DownPaymentEntity> dpList =
            context.read<ReceiptCubit>().state.downPayments ?? [];
        List<String> docnumList = [];
        if (dpList.isNotEmpty) {
          for (DownPaymentEntity dp in dpList) {
            if (dp.isSelected == true && dp.isReceive == false) {
              docnumList.add(dp.refpos2 ?? "");
            }
          }

          if (user != null) {
            String checkLock = await GetIt.instance<InvoiceApi>()
                .lockInvoice(user.docId, docnumList);
            if (checkLock.contains("Connection failed") ||
                checkLock.contains("The connection errored")) {
              SnackBarHelper.presentErrorSnackBar(context,
                  "Failed to process DP Transaction. Please check your connection and try again");
              return;
            } else if (checkLock.contains("Can't init lock")) {
              SnackBarHelper.presentErrorSnackBar(context,
                  "Can't process transaction because one of the down payments is locked");
              return;
            }
          }
        }
      } catch (e) {
        return;
      }

      if (context.read<ReceiptCubit>().state.previousReceiptEntity == null) {
        await context
            .read<ReceiptCubit>()
            .processReceiptBeforeCheckout(context);
      }

      await Future.delayed(const Duration(milliseconds: 300), null);

      final ReceiptEntity receiptEntity = context.read<ReceiptCubit>().state;

      log("currentLength ${receiptEntity.promos.length} previousLength ${receiptEntity.previousReceiptEntity?.promos.length}");

      if (receiptEntity.promos !=
          (receiptEntity.previousReceiptEntity?.promos ??
              <PromotionsEntity>[])) {
        await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => PromotionSummaryDialog(
                  receiptEntity: context.read<ReceiptCubit>().state,
                ));
      }

      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const CheckoutDialog()).then((value) {
        setState(() {
          isEditingNewReceiptItemCode = true;
          _newReceiptItemCodeFocusNode.requestFocus();
        });
      });
      Future.delayed(const Duration(milliseconds: 100)).then((_) {
        checkReceiptWithMember(context.read<ReceiptCubit>().state);
      });
    } catch (e) {
      SnackBarHelper.presentErrorSnackBar(context, e.toString());
    }
  }

  Future<EmployeeEntity?> getSalesPerson(
      String? itemSalesTohemId, String? headerSalesTohemId) async {
    try {
      EmployeeEntity? employeeEntity;
      if (headerSalesTohemId != null && headerSalesTohemId != "") {
        employeeEntity = await GetIt.instance<AppDatabase>()
            .employeeDao
            .readByDocId(headerSalesTohemId, null);
      }
      if (itemSalesTohemId != null && itemSalesTohemId != "") {
        employeeEntity = await GetIt.instance<AppDatabase>()
            .employeeDao
            .readByDocId(itemSalesTohemId, null);
      }
      return employeeEntity;
    } catch (e) {
      return null;
    }
  }

  Future<void> removeItem() async {
    try {
      final ReceiptItemEntity receiptItemTarget =
          context.read<ReceiptCubit>().state.receiptItems[indexIsSelect[0]];
      if (receiptItemTarget.refpos3 != null)
        throw "Please modify returned items on Return feature";

      setState(() {
        indexIsSelect = [-1, 0];
        _textEditingControllerNewReceiptItemQuantity.text = "1";
        _textEditingControllerNewReceiptItemCode.text = "";
        _newReceiptItemQuantityFocusNode.unfocus();
        isUpdatingReceiptItemQty = false;
        isEditingNewReceiptItemCode = true;
        _newReceiptItemCodeFocusNode.requestFocus();
      });

      context
          .read<ReceiptCubit>()
          .removeReceiptItem(receiptItemTarget, context);
    } catch (e) {
      SnackBarHelper.presentErrorSnackBar(context, e.toString());
    }
  }

  void _sendToDisplay() async {
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
      final List<Map<String, dynamic>> items = state.receiptItems.map((item) {
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
      }).toList();

      final double calculatedTotalDiscount = items.fold(
          0.0,
          (sum, item) =>
              sum +
              double.parse(item['discount']
                  .toString()
                  .replaceAll(RegExp(r'[^0-9.]'), '')));

      final double calculatedGrandTotal =
          items.fold(0.0, (sum, item) => sum + item['total']);

      final Map<String, dynamic> data = {
        'docNum': state.docNum,
        'customerName': state.customerEntity?.custName ?? 'NON MEMBER',
        'items': items,
        'totalDiscount': Helpers.parseMoney(calculatedTotalDiscount.round()),
        'grandTotal': Helpers.parseMoney(calculatedGrandTotal.round()),
      };

      final jsonData = jsonEncode(data);
      debugPrint("Sending data to display from sales: $jsonData");
      final sendingData =
          await sendData(windowId, jsonData, 'updateSalesData', 'Sales');

      debugPrint("Send result: $sendingData");
    } catch (e, stackTrace) {
      print('Error send data to client display from sales: $e');
    }
  }

  // Future<void> applyHeaderDiscount(BuildContext childContext) async {
  //   try {
  //     final ReceiptItemEntity? dpItem =
  //         context.read<ReceiptCubit>().state.receiptItems.where((e) => e.itemEntity.barcode == "99").firstOrNull;
  //     if (dpItem != null && dpItem.quantity > 0) {
  //       throw "Header discount cannot be applied on down payment deposit";
  //     }

  //     await showDialog(
  //         context: context,
  //         barrierDismissible: false,
  //         builder: (context) => InputDiscountManual(docnum: context.read<ReceiptCubit>().state.docNum)).then((value) {
  //       if (value != null) {
  //         SnackBarHelper.presentSuccessSnackBar(
  //             childContext, "Header discount applied: ${Helpers.parseMoney(value)}", 3);
  //       }
  //     });
  //   } catch (e) {
  //     SnackBarHelper.presentErrorSnackBar(context, e.toString());
  //   }
  // }
  // =================================================
  //             [END] Other Functions
  // =================================================

  Widget _noteChip(double amount, int type) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
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

  Future<bool> checkItemDP() async {
    final receiptItems = context.read<ReceiptCubit>().state.receiptItems;

    final hasPositiveQuantity = receiptItems.any((item) => item.quantity > 0);

    final hasItemDP = receiptItems.any((item) =>
        item.itemEntity.itemCode == "99" ||
        item.itemEntity.itemCode == "08700000002");

    return hasPositiveQuantity && hasItemDP;
  }

  Future<void> _showDialogReturn() async {
    final receiptItems = context.read<ReceiptCubit>().state.receiptItems;
    print('receiptItems: $receiptItems');
    final hasItemReturn =
        receiptItems.any((item) => item.refpos3 != null && item.refpos3 != "");
    print('hasItemReturn: $hasItemReturn');
  }
}
