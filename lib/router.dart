import 'package:banking_app/application_shell.dart';
import 'package:banking_app/mock_page.dart';
import 'package:banking_app/views/dashboard_view.dart';
import 'package:banking_app/views/transactions_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// I don't really understand the purpose of the keys
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _shellNavigatorTransactionsKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellTransactions');
final _shellNavigatorStatisticsKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellStatistics');

/// This router is based on [this tutorial](https://codewithandrea.com/articles/flutter-bottom-navigation-bar-nested-routes-gorouter)
final goRouter = GoRouter(
  initialLocation: '/home',
  navigatorKey: _rootNavigatorKey,
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state, navigationShell) {
        return ApplicationShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(navigatorKey: _shellNavigatorHomeKey, routes: [
          GoRoute(
            path: '/home',
            parentNavigatorKey: _shellNavigatorHomeKey,
            pageBuilder: (context, state) =>
                // MaterialPage(child: DashboardView()),
                CustomTransitionPage(
              child: DashboardView(),
              transitionsBuilder: transitionBuilder,
            ),
          )
        ]),
        StatefulShellBranch(
            navigatorKey: _shellNavigatorTransactionsKey,
            routes: [
              GoRoute(
                  path: '/transactions',
                  pageBuilder: (context, state) =>
                      // MaterialPage(child: TransactionsView()),
                      CustomTransitionPage(
                        child: TransactionsView(),
                        transitionsBuilder: transitionBuilder,
                      ))
            ]),
        StatefulShellBranch(
            navigatorKey: _shellNavigatorStatisticsKey,
            routes: [
              GoRoute(
                path: '/dashboard',
                pageBuilder: (context, state) =>
                    MaterialPage(child: MockPage('Statistics')),
              )
            ]),
      ],
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) =>
          MaterialPage(child: MockPage('Settings')),
    ),
  ],
);

final transitionBuilder = (BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  return FadeTransition(
    opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
    child: child,
  );
};
