import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zello/l10n/app_localizations.dart';

class MainPage extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const MainPage({super.key, required this.navigationShell});

  void _goBranch(int index) {
    navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF248f3d),
        unselectedItemColor: Colors.grey,
        currentIndex: navigationShell.currentIndex,
        onTap: _goBranch,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: localization.homeBottomNavigationTitle),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: localization.salesBottomNavigationTitle),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: localization.productsBottomNavigationTitle),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: localization.customersBottomNavigationTitle),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: localization.reportsBottomNavigationTitle),
        ],
      ),
    );
  }
}
