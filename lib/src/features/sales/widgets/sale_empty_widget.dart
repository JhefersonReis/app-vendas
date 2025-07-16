import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zello/l10n/app_localizations.dart';

class SaleEmptyWidget extends ConsumerWidget {
  const SaleEmptyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;

    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.shopping_bag_outlined, size: 50, color: Colors.grey),
              const SizedBox(height: 10),
              Text(localization.noSalesRecorded, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(localization.startByRecordingYourFirstSale),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => context.go('/sales/form'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF248f3d),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(localization.registerFirstSale),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
