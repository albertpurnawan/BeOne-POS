import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/config/themes/project_colors.dart';
import 'package:pos_fe/features/sales/domain/usecases/apply_rounding.dart';
import 'package:pos_fe/features/sales/domain/usecases/check_buy_x_get_y_applicability.dart';
import 'package:pos_fe/features/sales/domain/usecases/check_promos.dart';
import 'package:pos_fe/features/sales/domain/usecases/delete_queued_receipt_by_docId.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_cash_register.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_customers.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_employee.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_employees.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_item_by_barcode.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_items.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_mop_selections.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_store_master.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_open_price.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promo_buy_x_get_y.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promo_special_price.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promo_topdg.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promo_topdi.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promos.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_without_promos.dart';
import 'package:pos_fe/features/sales/domain/usecases/open_cash_drawer.dart';
import 'package:pos_fe/features/sales/domain/usecases/print_receipt.dart';
import 'package:pos_fe/features/sales/domain/usecases/queue_receipt.dart';
import 'package:pos_fe/features/sales/domain/usecases/recalculate_receipt_by_new_receipt_items.dart';
import 'package:pos_fe/features/sales/domain/usecases/recalculate_tax.dart';
import 'package:pos_fe/features/sales/domain/usecases/save_receipt.dart';
import 'package:pos_fe/features/sales/presentation/cubit/customers_cubit.dart';
import 'package:pos_fe/features/sales/presentation/cubit/employees_cubit.dart';
import 'package:pos_fe/features/sales/presentation/cubit/items_cubit.dart';
import 'package:pos_fe/features/sales/presentation/cubit/mop_selections_cubit.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';
import 'package:pos_fe/features/syncdata/domain/usecases/scheduler.dart';
import 'package:pos_fe/injection_container.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  await GetIt.instance.allReady();
  await syncWithBOS();
  // await SentryFlutter.init(
  //   (options) {
  //     options.dsn =
  //         'https://51c31424041afb915d53816fc77070dd@o4507457904312320.ingest.de.sentry.io/4507458001502288';
  //     // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
  //     // We recommend adjusting this value in production.
  //     options.tracesSampleRate = 1.0;
  //     // The sampling rate for profiling is relative to tracesSampleRate
  //     // Setting to 1.0 will profile 100% of sampled transactions:
  //     options.profilesSampleRate = 1.0;
  //   },
  //   appRunner: () => runApp(const MyApp()),
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // print((GetIt.instance<AppDatabase>().currencyDao.readAll()).toString());
    // GetIt.instance<AppDatabase>()
    //     .itemCategoryDao
    //     .bulkCreate(tocat.map((e) => ItemCategoryModel.fromMap(e)).toList());

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
                    )),
            BlocProvider<CustomersCubit>(
                create: (context) =>
                    CustomersCubit(GetIt.instance<GetCustomersUseCase>())),
            BlocProvider<MopSelectionsCubit>(
                create: (context) => MopSelectionsCubit(
                    GetIt.instance<GetMopSelectionsUseCase>())),
            BlocProvider<ItemsCubit>(
                create: (context) =>
                    ItemsCubit(GetIt.instance<GetItemsUseCase>())),
            BlocProvider<EmployeesCubit>(
                create: (context) =>
                    EmployeesCubit(GetIt.instance<GetEmployeesUseCase>())),
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
                      child: SvgPicture.asset(
                        "assets/logo/maroon_only_pos.svg",
                        width: 130,
                        color: const Color(0xFFD42627),
                      ),
                    ),
                  );
                }

                final str = snapshot.data!;
                debugPrint(str);
                return MaterialApp.router(
                  title: 'TestPOS',
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    colorScheme:
                        ColorScheme.fromSeed(seedColor: ProjectColors.primary),
                    fontFamily: 'Roboto',
                    useMaterial3: true,
                  ),
                  routerConfig: GetIt.instance<GoRouter>(),
                );
              }),
        ));
  }
}
