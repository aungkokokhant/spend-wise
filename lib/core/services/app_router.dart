import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/finance/views/analytics_view.dart';
import '../../features/finance/views/dashboard_view.dart';
import '../../features/finance/views/settings_view.dart';
import '../../features/finance/views/transaction_form_view.dart';
import '../../features/finance/views/transactions_view.dart';
import '../../features/finance/widgets/app_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  CustomTransitionPage<void> buildTransitionPage(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );

        return FadeTransition(
          opacity: curve,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.04),
              end: Offset.zero,
            ).animate(curve),
            child: child,
          ),
        );
      },
    );
  }

  return GoRouter(
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                pageBuilder: (context, state) =>
                    buildTransitionPage(context, state, const DashboardView()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/transactions',
                pageBuilder: (context, state) => buildTransitionPage(
                  context,
                  state,
                  const TransactionsView(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/analytics',
                pageBuilder: (context, state) =>
                    buildTransitionPage(context, state, const AnalyticsView()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                pageBuilder: (context, state) =>
                    buildTransitionPage(context, state, const SettingsView()),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/transaction/new',
        pageBuilder: (context, state) =>
            buildTransitionPage(context, state, const TransactionFormView()),
      ),
      GoRoute(
        path: '/transaction/:id',
        pageBuilder: (context, state) => buildTransitionPage(
          context,
          state,
          TransactionFormView(transactionId: state.pathParameters['id']),
        ),
      ),
    ],
  );
});
