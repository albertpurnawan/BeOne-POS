import 'dart:developer';
import 'dart:io';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/features/dual_screen/presentation/pages/display.dart';
import 'package:pos_fe/features/sales/domain/usecases/apply_manual_rounding.dart';
import 'package:pos_fe/features/sales/domain/usecases/apply_promo_toprn.dart';
import 'package:pos_fe/features/sales/domain/usecases/apply_rounding.dart';
import 'package:pos_fe/features/sales/domain/usecases/check_buy_x_get_y_applicability.dart';
import 'package:pos_fe/features/sales/domain/usecases/check_promos.dart';
import 'package:pos_fe/features/sales/domain/usecases/delete_queued_receipt_by_docId.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_campaigns_usecase.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_cash_register.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_credit_cards.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_customers.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_employee.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_employees.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_item_by_barcode.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_item_with_and_condition.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_items_by_pricelist.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_mop_selections.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_store_master.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_open_price.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promo_buy_x_get_y.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promo_special_price.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promo_topdg.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promo_topdi.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promo_topsm.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promos.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_without_promos.dart';
import 'package:pos_fe/features/sales/domain/usecases/open_cash_drawer.dart';
import 'package:pos_fe/features/sales/domain/usecases/print_receipt.dart';
import 'package:pos_fe/features/sales/domain/usecases/queue_receipt.dart';
import 'package:pos_fe/features/sales/domain/usecases/recalculate_receipt_by_new_receipt_items.dart';
import 'package:pos_fe/features/sales/domain/usecases/recalculate_tax.dart';
import 'package:pos_fe/features/sales/domain/usecases/save_receipt.dart';
import 'package:pos_fe/features/sales/presentation/cubit/campaign_cubit.dart';
import 'package:pos_fe/features/sales/presentation/cubit/credit_card_cubit.dart';
import 'package:pos_fe/features/sales/presentation/cubit/customers_cubit.dart';
import 'package:pos_fe/features/sales/presentation/cubit/employees_cubit.dart';
import 'package:pos_fe/features/sales/presentation/cubit/items_cubit.dart';
import 'package:pos_fe/features/sales/presentation/cubit/mop_selections_cubit.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';
import 'package:pos_fe/features/sales/presentation/cubit/return_receipt_cubit.dart';
import 'package:pos_fe/features/settings/domain/usecases/scheduler.dart';
import 'package:pos_fe/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    // await hotKeyManager.unregister(
    //     HotKey(key: LogicalKeyboardKey.f10, scope: HotKeyScope.system));
  }

  // Set options for the main window

  if (args.isNotEmpty) {
    try {
      final windowArgs = args.first;

      if (windowArgs == 'multi_window') {
        final windowId = int.parse(args[1]);
        final argument = args[2].isEmpty;

        // Create a separate router for the second window
        final secondWindowRouter = GoRouter(
          initialLocation: '/dualScreen',
          routes: [
            GoRoute(
              path: '/dualScreen',
              builder: (context, state) => DisplayPage(
                windowController: WindowController.fromWindowId(windowId),
                args: {
                  'data': args[2].toString(),
                },
              ),
            ),
          ],
        );

        runApp(
          MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: secondWindowRouter,
          ),
        );
        return;
      }
    } catch (e) {
      print('Error parsing window arguments: $e');
    }
  }

  await initializeDependencies();
  await GetIt.instance.allReady();
  // await FirstRunManager.checkFirstRun();
  await GetIt.instance<SharedPreferences>().setBool("isSyncing", false);
  await configureBackgroundTasks();
  // await SentryFlutter.init(
  //   (options) {
  //     options.dsn =
  //         'https://7306b39b56b79ca6f462f271e019822d@o4507461908824064.ingest.us.sentry.io/4507461910724608';
  //     // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
  //     // We recommend adjusting this value in production.
  //     options.tracesSampleRate = 1.0;
  //     // The sampling rate for profiling is relative to tracesSampleRate
  //     // Setting to 1.0 will profile 100% of sampled transactions:
  //     options.profilesSampleRate = 1.0;
  //   },
  //   appRunner: () => runApp(const MyApp()),
  // );
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    log(details.toString());
    // if (kReleaseMode) exit(1);
  };
  runApp(const MyApp());

  _configureMainWindow();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  onWindowClose() {
    _showCloseConfirmationDialog();
  }

  Future<void> _showCloseConfirmationDialog() async {
    try {
      final windows = await DesktopMultiWindow.getAllSubWindowIds();
      SharedPreferences? prefs = await SharedPreferences.getInstance();

      await Future.forEach(windows, (windowId) async {
        final controller = WindowController.fromWindowId(windowId);
        await controller.close();
        await prefs.setBool("isCustomerDisplayActive", false);
      });
    } catch (e) {
      debugPrint('Error Closing Window: $e');
    } finally {
      windowManager.destroy();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(255, 169, 0, 0),
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light));

    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: MultiBlocProvider(
          providers: [
            BlocProvider<ReceiptCubit>(
                create: (context) => ReceiptCubit(
                      GetIt.instance<GetItemByBarcodeUseCase>(),
                      GetIt.instance<SaveReceiptUseCase>(),
                      GetIt.instance<GetEmployeeUseCase>(),
                      GetIt.instance<PrintReceiptUseCase>(),
                      GetIt.instance<OpenCashDrawerUseCase>(),
                      GetIt.instance<QueueReceiptUseCase>(),
                      GetIt.instance<DeleteQueuedReceiptUseCase>(),
                      GetIt.instance<HandleOpenPriceUseCase>(),
                      GetIt.instance<CheckPromoUseCase>(),
                      GetIt.instance<HandlePromosUseCase>(),
                      GetIt.instance<HandleWithoutPromosUseCase>(),
                      GetIt.instance<RecalculateReceiptUseCase>(),
                      GetIt.instance<CheckBuyXGetYApplicabilityUseCase>(),
                      GetIt.instance<HandlePromoBuyXGetYUseCase>(),
                      GetIt.instance<HandlePromoSpecialPriceUseCase>(),
                      GetIt.instance<RecalculateTaxUseCase>(),
                      GetIt.instance<HandlePromoTopdgUseCase>(),
                      GetIt.instance<HandlePromoTopdiUseCase>(),
                      GetIt.instance<GetPosParameterUseCase>(),
                      GetIt.instance<GetStoreMasterUseCase>(),
                      GetIt.instance<GetCashRegisterUseCase>(),
                      GetIt.instance<ApplyRoundingUseCase>(),
                      GetIt.instance<GetItemWithAndConditionUseCase>(),
                      GetIt.instance<ApplyPromoToprnUseCase>(),
                      GetIt.instance<ApplyManualRoundingUseCase>(instanceName: 'roundingDown'),
                      GetIt.instance<ApplyManualRoundingUseCase>(instanceName: 'roundingUp'),
                      GetIt.instance<HandlePromoSpesialMultiItemUseCase>(),
                    )),
            BlocProvider<CustomersCubit>(create: (context) => CustomersCubit(GetIt.instance<GetCustomersUseCase>())),
            BlocProvider<MopSelectionsCubit>(
                create: (context) => MopSelectionsCubit(GetIt.instance<GetMopSelectionsUseCase>())),
            BlocProvider<ItemsCubit>(create: (context) => ItemsCubit(GetIt.instance<GetItemsByPricelistUseCase>())),
            BlocProvider<EmployeesCubit>(create: (context) => EmployeesCubit(GetIt.instance<GetEmployeesUseCase>())),
            BlocProvider<CreditCardCubit>(create: (context) => CreditCardCubit(GetIt.instance<GetCreditCardUseCase>())),
            BlocProvider<CampaignCubit>(create: (context) => CampaignCubit(GetIt.instance<GetCampaignUseCase>())),
            BlocProvider<ReturnReceiptCubit>(create: (context) => ReturnReceiptCubit()),
          ],
          child: FutureBuilder<String>(
              future: Future.delayed(const Duration(seconds: 5), () {
                return "ABC";
              }),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    color: Colors.white,
                    child: Center(
                      child: Image.asset(
                        "assets/images/ruby_pos.png",
                        width: MediaQuery.of(context).size.width * 0.4,
                      ),
                    ),
                  );
                }

                return MaterialApp.router(
                  title: 'RubyPOS',
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(seedColor: ProjectColors.primary),
                    fontFamily: 'Roboto',
                    useMaterial3: true,
                  ),
                  routerConfig: GetIt.instance<GoRouter>(),
                );
              }),
        ));
  }
}

Future<void> _configureMainWindow() async {
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    center: true,
    backgroundColor: Colors.transparent,
    fullScreen: false,
    skipTaskbar: false,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.maximize();
    await windowManager.setPreventClose(true);
  });
}
