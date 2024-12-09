// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/core/constants/route_constants.dart';
import 'package:pos_fe/features/dual_screen/presentation/pages/display.dart';
import 'package:pos_fe/features/home/presentation/pages/home.dart';
import 'package:pos_fe/features/login/presentation/pages/login.dart';
import 'package:pos_fe/features/login/presentation/pages/welcome.dart';
import 'package:pos_fe/features/mop_adjustment/presentation/pages/mop_adjustment_screen.dart';
import 'package:pos_fe/features/reports/presentation/pages/check_stocks_screen.dart';
import 'package:pos_fe/features/reports/presentation/pages/filtered_report_screen.dart';
import 'package:pos_fe/features/sales/presentation/pages/home/sales.dart';
import 'package:pos_fe/features/sales/presentation/pages/shift/close_shift.dart';
import 'package:pos_fe/features/sales/presentation/pages/shift/shift_list.dart';
import 'package:pos_fe/features/settings/presentation/pages/settings.dart';

class AppRouter {
  GoRouter router = GoRouter(
    routes: [
      GoRoute(
        name: RouteConstants.welcome,
        path: "/",
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: WelcomeScreen(),
          );
        },
      ),
      GoRoute(
        name: RouteConstants.home,
        path: "/home",
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: Scaffold(
              body: HomeScreen(),
            ),
          );
        },
      ),
      GoRoute(
        name: RouteConstants.login,
        path: "/login",
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: Scaffold(
              body: LoginScreen(),
            ),
          );
        },
      ),
      GoRoute(
        name: RouteConstants.sales,
        path: "/sales",
        pageBuilder: (context, state) {
          final SalesRouterExtra salesRouterExtra = state.extra as SalesRouterExtra;
          return MaterialPage(
            child: SalesPage(
              salesViewType: salesRouterExtra.salesViewType,
              onFirstBuild: salesRouterExtra.onFirstBuild,
            ),
          );
        },
      ),
      GoRoute(
        name: RouteConstants.masters,
        path: "/masters",
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: Scaffold(
              body: Center(child: Text("/masters")),
            ),
          );
        },
      ),
      GoRoute(
        name: RouteConstants.settings,
        path: "/settings",
        pageBuilder: (context, state) {
          return const MaterialPage(child: SettingsScreen());
        },
      ),
      GoRoute(
        name: RouteConstants.shifts,
        path: "/shifts",
        pageBuilder: (context, state) {
          return const MaterialPage(child: ShiftsList());
        },
      ),
      GoRoute(
        name: RouteConstants.closeShift,
        path: "/shifts/close",
        pageBuilder: (context, state) {
          final Map<String, String> data = state.extra as Map<String, String>;
          return MaterialPage(
              child: CloseShiftScreen(
            shiftId: data["shiftId"] as String,
            username: data["username"],
          ));
        },
      ),
      GoRoute(
        name: RouteConstants.reports,
        path: "/reports",
        pageBuilder: (context, state) {
          return const MaterialPage(child: FiltereReportScreen());
        },
      ),
      GoRoute(
        name: RouteConstants.mopAdjustment,
        path: "/mopAdjustment",
        pageBuilder: (context, state) {
          return const MaterialPage(child: MOPAdjustmentScreen());
        },
      ),
      GoRoute(
        name: RouteConstants.checkStocks,
        path: "/checkStocks",
        pageBuilder: (context, state) {
          return const MaterialPage(child: CheckStockScreen());
        },
      ),
      //Dual screen route
      GoRoute(
        name: RouteConstants.dualScreen,
        path: "/dualScreen",
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          final windowController = args['windowController'] as WindowController;

          return MaterialPage(
            child: DisplayPage(
              windowController: windowController,
              args: args,
            ),
          );
        },
      ),
    ],
    // redirect: (BuildContext context, GoRouterState state) {
    //   if (state.extra != null) {
    //     return '/signin';
    //   } else {
    //     return null;
    //   }
    // },
  );
}

class SalesRouterExtra {
  int salesViewType;
  Function(BuildContext)? onFirstBuild;

  SalesRouterExtra({
    this.salesViewType = 1,
    this.onFirstBuild,
  });
}
