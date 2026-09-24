import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/providers/firebase_providers.dart';
import '../features/auth/screens/auth_screen.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/goals/screens/goal_detail_screen.dart';
import '../features/goals/screens/goal_form_screen.dart';
import '../features/goals/screens/goals_screen.dart';
import '../features/reports/screens/reports_screen.dart';
import '../features/security/providers/app_lock_provider.dart';
import '../features/security/screens/lock_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import '../features/transactions/screens/import_preview_screen.dart';
import '../features/transactions/screens/transaction_detail_screen.dart';
import '../features/transactions/screens/transaction_form_screen.dart';
import '../features/transactions/screens/transactions_screen.dart';
import '../features/transactions/services/transaction_csv_importer.dart';
import 'main_shell.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// Telas empilhadas por cima da shell (formulários, detalhes, configurações)
/// entram com um leve fade + slide, em vez do corte seco padrão.
CustomTransitionPage<void> _slideFadePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      final slide = Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero).animate(fade);
      return FadeTransition(opacity: fade, child: SlideTransition(position: slide, child: child));
    },
  );
}

/// Transforma um Stream em Listenable para o GoRouter recalcular o
/// `redirect` sempre que o estado de autenticação mudar.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

GoRouter createRouter(WidgetRef ref) {
  final auth = ref.read(firebaseAuthProvider);
  final appLockListenable = ref.read(appLockListenableProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: Listenable.merge([
      GoRouterRefreshStream(auth.authStateChanges()),
      appLockListenable,
    ]),
    redirect: (context, state) {
      final loggedIn = auth.currentUser != null;
      final onLoginPage = state.matchedLocation == '/login';
      if (!loggedIn) return onLoginPage ? null : '/login';
      if (onLoginPage) return '/';

      final locked = ref.read(appLockProvider).isLocked;
      final onLockPage = state.matchedLocation == '/lock';
      if (locked) return onLockPage ? null : '/lock';
      if (onLockPage) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => _slideFadePage(state, const AuthScreen()),
      ),
      GoRoute(
        path: '/lock',
        pageBuilder: (context, state) => _slideFadePage(state, const LockScreen()),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/transactions',
                builder: (context, state) => const TransactionsScreen(),
                routes: [
                  GoRoute(
                    path: 'new',
                    parentNavigatorKey: rootNavigatorKey,
                    pageBuilder: (context, state) => _slideFadePage(state, const TransactionFormScreen()),
                  ),
                  GoRoute(
                    path: ':id',
                    parentNavigatorKey: rootNavigatorKey,
                    pageBuilder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return _slideFadePage(state, TransactionDetailScreen(transactionId: id));
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/goals',
                builder: (context, state) => const GoalsScreen(),
                routes: [
                  GoRoute(
                    path: 'new',
                    parentNavigatorKey: rootNavigatorKey,
                    pageBuilder: (context, state) => _slideFadePage(state, const GoalFormScreen()),
                  ),
                  GoRoute(
                    path: ':id',
                    parentNavigatorKey: rootNavigatorKey,
                    pageBuilder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return _slideFadePage(state, GoalDetailScreen(goalId: id));
                    },
                    routes: [
                      GoRoute(
                        path: 'edit',
                        parentNavigatorKey: rootNavigatorKey,
                        pageBuilder: (context, state) {
                          final id = state.pathParameters['id']!;
                          return _slideFadePage(state, GoalFormScreen(goalId: id));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/reports',
                builder: (context, state) => const ReportsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/settings',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => _slideFadePage(state, const SettingsScreen()),
        routes: [
          GoRoute(
            path: 'import-preview',
            parentNavigatorKey: rootNavigatorKey,
            pageBuilder: (context, state) => _slideFadePage(
              state,
              ImportPreviewScreen(result: state.extra as TransactionImportResult),
            ),
          ),
        ],
      ),
    ],
  );
}
