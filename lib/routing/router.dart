import 'package:banking_app/features/authentication/auth_selection_screen.dart';
import 'package:banking_app/features/authentication/login_screen.dart';
import 'package:banking_app/features/authentication/profile_screen.dart';
import 'package:banking_app/features/authentication/register_screen.dart';
import 'package:banking_app/features/transaction/view/home_view.dart';
import 'package:banking_app/features/transaction/view/transaction_focus_view.dart';
import 'package:banking_app/features/transaction/view/transaction_view.dart';
import 'package:banking_app/features/transaction/view/add_transaction_view.dart';
import 'package:banking_app/common_widgets/mock_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/routes.dart';
import '../features/transaction/view/category_view.dart';
import '../features/transaction/view/edit_transaction_view.dart';
import './application_shell.dart';

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
              path: Routes.home,
              pageBuilder: (context, state) => NoTransitionPage(
                child: HomeView(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorTransactionsKey,
          routes: [
            GoRoute(
              path: Routes.transactions,
              pageBuilder: (context, state) => NoTransitionPage(
                child: TransactionsView(),
              ),
              routes: [
                GoRoute(
                  path: 'detail/:transactionId',
                  name: 'details',
                  builder: (context, state) => TransactionFocusView(
                      transactionId: state.pathParameters['transactionId']),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorStatisticsKey,
          routes: [
            GoRoute(
              path: Routes.statistics,
              pageBuilder: (context, state) => NoTransitionPage(
                child: MockPage(
                  welcomeText: 'Statistics',
                ),
              ),
            )
          ],
        ),
      ],
    ),
    GoRoute(
      path: Routes.settings,
      pageBuilder: (context, state) => NoTransitionPage(
        child: MockPage(
          welcomeText: 'Settings',
        ),
      ),
    ),
    GoRoute(
      path: '/categories',
      name: 'categories',
      builder: (context, state) => CategoryView(),
    ),
    GoRoute(
      path: '/add',
      name: 'add',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: AddTransactionView(),
        transitionsBuilder: subpageAnimation,
        transitionDuration: const Duration(milliseconds: 200),
      ),
    ),
    GoRoute(
      path: '/edit/:transactionId',
      name: 'edit',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: EditTransactionView(
            transactionId: state.pathParameters['transactionId']),
        transitionsBuilder: subpageAnimation,
        transitionDuration: const Duration(milliseconds: 200),
      ),
    ),
    GoRoute(
      path: Routes.authSelectionScreen,
      pageBuilder: (context, state) => NoTransitionPage(
        child: AuthSelectionScreen(),
      ),
      routes: [
        GoRoute(
          path: 'login',
          pageBuilder: (context, state) => NoTransitionPage(
            child: LoginScreen(),
          ),
        ),
        GoRoute(
          path: 'register',
          pageBuilder: (context, state) => NoTransitionPage(
            child: RegisterScreen(),
          ),
        ),
      ],
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Routes.profile,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: ProfileScreen(),
        transitionsBuilder: subpageAnimation,
        transitionDuration: const Duration(milliseconds: 200),
      ),
    ),
  ],
  redirect: (BuildContext context, GoRouterState state) async {
    final loggedIn = FirebaseAuth.instance.currentUser != null;
    final bool loggingIn =
        state.matchedLocation == Routes.authSelectionScreen ||
            state.matchedLocation == '/auth-selection-screen/login' ||
            state.matchedLocation == '/auth-selection-screen/register';

    // Redirect to the login page if the user is not logged in
    if (!loggedIn) {
      return loggingIn ? null : Routes.authSelectionScreen;
    }

    // If the user is logged in but is on the login page, redirect them to the
    // home page
    if (loggedIn && loggingIn) {
      return Routes.home;
    }

    // No redirection needed
    return null;
  },
);

Widget subpageAnimation(context, animation, secondaryAnimation, child) {
  const begin = Offset(1.0, 0.0);
  const end = Offset.zero;
  const curve = Curves.easeInOut;

  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

  return SlideTransition(
    position: animation.drive(tween),
    child: child,
  );
}
