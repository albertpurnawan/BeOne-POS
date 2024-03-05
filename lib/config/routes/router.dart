import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_fe/core/constants/route_constants.dart';
import 'package:pos_fe/features/login/presentation/pages/login.dart';
import 'package:pos_fe/features/login/presentation/pages/welcome.dart';
import 'package:pos_fe/features/sales/presentation/pages/home/sales.dart';

class AppRouter {
  GoRouter router = GoRouter(
    routes: [
      GoRoute(
        name: RouteConstants.home,
        path: "/",
        pageBuilder: (context, state) {
          return MaterialPage(
            child: Scaffold(
              body: WelcomeScreen(),
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
          return const MaterialPage(
            child: Scaffold(
              body: Center(child: Text("/settings")),
            ),
          );
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
