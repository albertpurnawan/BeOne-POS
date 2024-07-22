import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/core/constants/route_constants.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/resources/error_handler.dart';
import 'package:pos_fe/core/utilities/snack_bar_helper.dart';
import 'package:pos_fe/features/home/domain/usecases/logout.dart';
import 'package:pos_fe/features/home/presentation/widgets/confirm_active_shift_dialog.dart';
import 'package:pos_fe/features/sales/data/models/cashier_balance_transaction.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_store_master.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DateTime now;
  late int morningEpoch;
  late int afternoonEpoch;
  late int eveningEpoch;
  late String timeOfDay;
  late String symbol;
  CashierBalanceTransactionModel? activeShift;

  Future<void> fetchActiveShift() async {
    activeShift = await GetIt.instance<AppDatabase>().cashierBalanceTransactionDao.readLastValue();
  }

  Future<StoreMasterEntity?> getStoreMasterEntity() async {
    try {
      final POSParameterEntity? posParameterEntity = await GetIt.instance<GetPosParameterUseCase>().call();
      if (posParameterEntity == null) throw "Failed to retrieve POS Parameter";

      final StoreMasterEntity? storeMasterEntity =
          await GetIt.instance<GetStoreMasterUseCase>().call(params: posParameterEntity.tostrId);
      if (storeMasterEntity == null) throw "Failed to retrieve Store Master";

      return storeMasterEntity;
    } catch (e) {
      SnackBarHelper.presentFailSnackBar(context, e.toString());
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchActiveShift();
    now = DateTime.now();
    morningEpoch = DateTime(now.year, now.month, now.day, 4, 0, 0).millisecondsSinceEpoch;
    afternoonEpoch = DateTime(now.year, now.month, now.day, 11, 0, 0).millisecondsSinceEpoch;
    eveningEpoch = DateTime(now.year, now.month, now.day, 18, 0, 0).millisecondsSinceEpoch;
    final nowEpoch = now.millisecondsSinceEpoch;
    if (nowEpoch < morningEpoch || nowEpoch >= eveningEpoch) {
      timeOfDay = "evening";
      symbol = "🌆";
    } else if (nowEpoch >= morningEpoch && nowEpoch < afternoonEpoch) {
      timeOfDay = "morning";
      symbol = "☕";
    } else if (nowEpoch >= afternoonEpoch && nowEpoch < eveningEpoch) {
      timeOfDay = "afternoon";
      symbol = "☀️";
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: ProjectColors.primary,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light));
    return Scaffold(
      backgroundColor: ProjectColors.primary,
      body: Row(
        children: [
          Expanded(
              child: Image.asset(
            'assets/images/supermarket-illustration.png',
            height: double.infinity,
            fit: BoxFit.cover,
          )),
          Expanded(
              child: Container(
            color: const Color.fromRGBO(128, 0, 0, 1),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.36,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: RichText(
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Good $timeOfDay ",
                                      ),
                                      TextSpan(
                                          text: GetIt.instance<SharedPreferences>().getString("username"),
                                          style: const TextStyle(fontWeight: FontWeight.w700)),
                                      TextSpan(
                                        text: " $symbol",
                                      )
                                    ],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                    ),
                                  )),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: Text(
                                "Have a great day!",
                                textAlign: TextAlign.left,
                                style: TextStyle(color: Colors.white, fontSize: 28),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              width: MediaQuery.of(context).size.width * 0.36,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    elevation: const MaterialStatePropertyAll(2),
                                    padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 20)),
                                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                      side: const BorderSide(color: Colors.white, width: 2),
                                      borderRadius: BorderRadius.circular(5),
                                    )),
                                    backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                                    foregroundColor: MaterialStateColor.resolveWith(
                                        (states) => const Color.fromARGB(255, 255, 255, 255)),
                                    overlayColor:
                                        MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
                                onPressed: () async {
                                  try {
                                    final StoreMasterEntity? storeMasterEntity = await getStoreMasterEntity();
                                    await GetIt.instance<AppDatabase>().refreshItemsTable();
                                    await GetIt.instance<SharedPreferences>()
                                        .setInt("salesViewType", storeMasterEntity?.salesViewType ?? 1);
                                    await context.read<ReceiptCubit>().resetReceipt();
                                    await context.pushNamed(RouteConstants.sales,
                                        extra: storeMasterEntity?.salesViewType ?? 1);
                                  } catch (e) {
                                    ErrorHandler.presentErrorSnackBar(context, e.toString());
                                  }
                                },
                                child: const Text(
                                  "Sales",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              width: MediaQuery.of(context).size.width * 0.36,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 20)),
                                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                      side: const BorderSide(color: Colors.white, width: 2),
                                      borderRadius: BorderRadius.circular(5),
                                    )),
                                    backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                                    foregroundColor: MaterialStateColor.resolveWith(
                                        (states) => const Color.fromARGB(255, 255, 255, 255)),
                                    overlayColor:
                                        MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
                                onPressed: () => context.pushNamed(RouteConstants.shifts),
                                child: const Text(
                                  "Shifts",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              width: MediaQuery.of(context).size.width * 0.36,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 20)),
                                          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                            side: const BorderSide(color: Colors.white, width: 2),
                                            borderRadius: BorderRadius.circular(5),
                                          )),
                                          backgroundColor:
                                              MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                                          foregroundColor: MaterialStateColor.resolveWith(
                                              (states) => const Color.fromARGB(255, 255, 255, 255)),
                                          overlayColor:
                                              MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
                                      onPressed: () {
                                        context.pushNamed(RouteConstants.reports);
                                      },
                                      child: const Text(
                                        "Reports",
                                        textAlign: TextAlign.center,
                                        style:
                                            TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              width: MediaQuery.of(context).size.width * 0.36,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 20)),
                                          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                            side: const BorderSide(color: Colors.white, width: 2),
                                            borderRadius: BorderRadius.circular(5),
                                          )),
                                          backgroundColor:
                                              MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                                          foregroundColor: MaterialStateColor.resolveWith(
                                              (states) => const Color.fromARGB(255, 255, 255, 255)),
                                          overlayColor:
                                              MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
                                      onPressed: () {
                                        context.pushNamed(RouteConstants.checkStocks);
                                      },
                                      child: const Text(
                                        "Stock",
                                        textAlign: TextAlign.center,
                                        style:
                                            TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              width: MediaQuery.of(context).size.width * 0.36,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 20)),
                                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                      side: const BorderSide(color: Colors.white, width: 2),
                                      borderRadius: BorderRadius.circular(5),
                                    )),
                                    backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                                    foregroundColor: MaterialStateColor.resolveWith(
                                        (states) => const Color.fromARGB(255, 255, 255, 255)),
                                    overlayColor:
                                        MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
                                onPressed: () {
                                  context.pushNamed(RouteConstants.mopAdjustment);
                                },
                                child: const Text(
                                  "MOP Adjustment",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              width: MediaQuery.of(context).size.width * 0.36,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 20)),
                                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                      side: const BorderSide(color: Colors.white, width: 2),
                                      borderRadius: BorderRadius.circular(5),
                                    )),
                                    backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                                    foregroundColor: MaterialStateColor.resolveWith(
                                        (states) => const Color.fromARGB(255, 255, 255, 255)),
                                    overlayColor:
                                        MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
                                onPressed: () {
                                  context.pushNamed(RouteConstants.settings).then((value) {
                                    if (!Platform.isWindows) {
                                      Future.delayed(Durations.short1, () {
                                        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
                                            statusBarColor: Color.fromARGB(255, 134, 1, 1),
                                            statusBarBrightness: Brightness.light,
                                            statusBarIconBrightness: Brightness.light));
                                      });
                                    }
                                  });
                                },
                                child: const Text(
                                  "Settings",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              width: MediaQuery.of(context).size.width * 0.36,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 20)),
                                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                      side: const BorderSide(color: Colors.white, width: 2),
                                      borderRadius: BorderRadius.circular(5),
                                    )),
                                    backgroundColor: MaterialStateColor.resolveWith((states) => ProjectColors.primary),
                                    foregroundColor: MaterialStateColor.resolveWith(
                                        (states) => const Color.fromARGB(255, 255, 255, 255)),
                                    overlayColor:
                                        MaterialStateColor.resolveWith((states) => Colors.white.withOpacity(.2))),
                                onPressed: () async {
                                  // log(activeShift.toString());
                                  if (activeShift != null) {
                                    if (activeShift!.approvalStatus == 0) {
                                      await showDialog<bool>(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) => ConfirmActiveShiftDialog(
                                          currentShiftDocId: activeShift!.docId,
                                        ),
                                      );

                                      return;
                                    }
                                  }

                                  GetIt.instance<LogoutUseCase>().call();
                                  context.goNamed(RouteConstants.welcome);
                                },
                                child: const Text(
                                  "Logout",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),

                            // SizedBox.expand(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    // height: double.infinity,

                    // width: double.infinity,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        alignment: Alignment.bottomRight,
                        child: Container(
                            alignment: Alignment.centerRight,
                            height: 50,
                            width: 130,
                            padding: const EdgeInsets.fromLTRB(10, 16, 0, 15),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 85, 0, 0),
                              borderRadius: BorderRadius.only(
                                // topLeft: Radius.circular(5),
                                topLeft: Radius.circular(60),
                              ),
                            ),
                            child: SvgPicture.asset(
                              "assets/logo/white_only_pos.svg",
                              // alignment: Alignment.centerLeft,
                            )),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}
