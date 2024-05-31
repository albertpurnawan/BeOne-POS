import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/core/constants/route_constants.dart';
import 'package:pos_fe/features/home/presentation/pages/home.dart';
import 'package:pos_fe/features/login/presentation/pages/login.dart';
import 'package:pos_fe/features/login/presentation/pages/welcome.dart';
import 'package:pos_fe/features/reports/prsentation/filtered_report_screen.dart';
import 'package:pos_fe/features/sales/presentation/pages/home/sales.dart';
import 'package:pos_fe/features/sales/presentation/pages/shift/shift_list.dart';
import 'package:pos_fe/features/settings/presentation/pages/settings.dart';

class AppRouter {
  GoRouter router = GoRouter(
    routes: [
      GoRoute(
        name: RouteConstants.welcome,
        path: "/",
        pageBuilder: (context, state) {
          return MaterialPage(
            child: WelcomeScreen(),
          );
        },
      ),
      GoRoute(
        name: RouteConstants.home,
        path: "/home",
        pageBuilder: (context, state) {
          return MaterialPage(
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
          return MaterialPage(
            child: SalesPage(),
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
        name: RouteConstants.reports,
        path: "/reports",
        pageBuilder: (context, state) {
          return const MaterialPage(
              child: FiltereReportScreen()); // edit to dashboard
        },
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      if (state.extra != null) {
        return '/signin';
      } else {
        return null;
      }
    },
  );
}

class TransactionsList {
  const TransactionsList();
}
