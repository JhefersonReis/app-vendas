import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zello/src/features/customers/view/customers_form_page.dart';
import 'package:zello/src/features/customers/view/customers_page.dart';
import 'package:zello/src/features/home/view/home_page.dart';
import 'package:zello/src/features/main/view/main_page.dart';
import 'package:zello/src/features/products/view/product_form_page.dart';
import 'package:zello/src/features/products/view/products_page.dart';
import 'package:zello/src/features/reports/view/reports_page.dart';
import 'package:zello/src/features/sales/view/sale_form_page.dart';
import 'package:zello/src/features/sales/view/sales_page.dart';

class Routes {
  Routes._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final _shellHomeNavigatorKey = GlobalKey<NavigatorState>();

  static final _shellSalesNavigatorKey = GlobalKey<NavigatorState>();

  static final _shellProductsNavigatorKey = GlobalKey<NavigatorState>();

  static final _shellCustomersNavigatorKey = GlobalKey<NavigatorState>();

  static final _shellReportsNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainPage(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellHomeNavigatorKey,
            routes: [
              GoRoute(
                path: '/',
                name: "Home",
                builder: (context, state) {
                  return const HomePage();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellSalesNavigatorKey,
            routes: [
              GoRoute(
                path: '/sales',
                name: "Sales",
                builder: (context, state) {
                  return const SalesPage();
                },
                routes: [
                  GoRoute(
                    path: '/form',
                    name: "SalesForm",
                    builder: (context, state) {
                      final String? saleId = state.uri.queryParameters['id'];
                      return SaleFormPage(id: saleId);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellProductsNavigatorKey,
            routes: [
              GoRoute(
                path: '/products',
                name: "Products",
                builder: (context, state) {
                  return const ProductsPage();
                },
                routes: [
                  GoRoute(
                    path: '/form',
                    name: "ProductForm",
                    builder: (context, state) {
                      final String? productId = state.uri.queryParameters['id'];
                      return ProductFormPage(id: productId);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellCustomersNavigatorKey,
            routes: [
              GoRoute(
                path: '/customers',
                name: "Customers",
                builder: (context, state) {
                  return const CustomersPage();
                },
                routes: [
                  GoRoute(
                    path: '/form',
                    name: "CustomerForm",
                    builder: (context, state) {
                      final String? customerId = state.uri.queryParameters['id'];
                      return CustomersFormPage(id: customerId);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellReportsNavigatorKey,
            routes: [
              GoRoute(
                path: '/reports',
                name: "Reports",
                builder: (context, state) {
                  return const ReportsPage();
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
