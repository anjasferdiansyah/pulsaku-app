
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:testing_flutter/domain/entities/customer.dart';
import 'package:testing_flutter/layout/app_layout.dart';
import 'package:testing_flutter/presentation/screen/add_or_update_customer_screen.dart';
import 'package:testing_flutter/presentation/screen/customer_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/list-transaction',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => AppLayout(
        navigationShell: navigationShell
      ),
      branches: [
            StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/list-transaction",
              builder: (context, state) => const Placeholder(),
            )
          ]
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/customer",
              routes: [
                GoRoute(
                  path: "/add-customer",
                  builder: (context, state) => const AddOrUpdateCustomerScreen(),
                ),
                GoRoute(
                  path: "/update-customer/:id",
                  builder: (context, state) => AddOrUpdateCustomerScreen(
                    existingCustomer: state.extra as Customer,
                  ),
                ),
              ],
              builder: (context, state) => const CustomerScreen(),
            )
          ]
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/transaction",
              builder: (context, state) => const Placeholder(),
            )
          ]
        )
    
      ]
    )
  ],
);
