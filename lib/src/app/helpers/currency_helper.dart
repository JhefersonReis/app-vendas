import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrencyHelper {
  static String formatCurrency(BuildContext context, double value) {
    final locale = Localizations.localeOf(context);
    final currencyLocale = locale.languageCode == 'pt' ? 'pt_BR' : 'en_US';

    return NumberFormat.simpleCurrency(locale: currencyLocale).format(value);
  }

  static String getCurrencySymbol(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final currencyLocale = locale.languageCode == 'pt' ? 'pt_BR' : 'en_US';

    return NumberFormat.simpleCurrency(locale: currencyLocale).currencySymbol;
  }
}
