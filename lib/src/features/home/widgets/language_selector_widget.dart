import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zello/l10n/app_localizations.dart';
import 'package:zello/src/app/providers/providers.dart';

class LanguageSelectorWidget extends ConsumerWidget {
  const LanguageSelectorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeNotifier = ref.read(localeProvider.notifier);
    final selectedLocale = ref.watch(localeProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Locale>(
          value: selectedLocale,
          icon: const Icon(Icons.language, color: Colors.white),
          dropdownColor: Colors.white,
          style: const TextStyle(color: Colors.black),
          onChanged: (locale) {
            if (locale != null) {
              localeNotifier.changeLocale(locale);
            }
          },
          items: AppLocalizations.supportedLocales.map((locale) {
            final label = _getLanguageLabel(locale.languageCode);
            return DropdownMenuItem<Locale>(value: locale, child: Text(label));
          }).toList(),
        ),
      ),
    );
  }

  String _getLanguageLabel(String code) {
    switch (code) {
      case 'pt':
        return '🇧🇷 PT';
      case 'en':
        return '🇺🇸 EN';
      default:
        return code.toUpperCase();
    }
  }
}
