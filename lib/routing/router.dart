import 'package:banking_app/application_shell.dart';
import 'package:banking_app/mock_page.dart';
import 'package:banking_app/features/transaction/transaction_view.dart';
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

/// This router is based on [this tutorial](https://codewithandrea.com/articles/flutter-bottom-navigation-bar-nested-routes-gorouter).
/// The StatefulShellRoute allows us to keep the state of each branch of the
/// application.
final goRouter = GoRouter(
  initialLocation: '/home',
  navigatorKey: _rootNavigatorKey,
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ApplicationShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorHomeKey,
          routes: [
            GoRoute(
              path: '/home',
              pageBuilder: (context, state) => NoTransitionPage(
                child: MockPage(welcomeText: 'Home'),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorTransactionsKey,
          routes: [
            GoRoute(
              path: '/transactions',
              pageBuilder: (context, state) => NoTransitionPage(
                child: TransactionsView(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorStatisticsKey,
          routes: [
            GoRoute(
              path: '/dashboard',
              pageBuilder: (context, state) => NoTransitionPage(
                child: MockPage(
                  welcomeText: 'Dashboard',
                ),
              ),
            )
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) => NoTransitionPage(
        child: MockPage(
          welcomeText: 'Settings',
        ),
      ),
    ),
  ],
);
