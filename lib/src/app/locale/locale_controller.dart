import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocaleController extends StateNotifier<Locale> {
  LocaleController() : super(const Locale('pt'));

  void changeLocale(Locale locale) {
    if (state != locale) {
      state = locale;
    }
  }
}
