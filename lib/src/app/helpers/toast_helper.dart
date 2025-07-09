import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastHelper {
  static void showError(BuildContext context, String message) {
    toastification.show(
      context: context,
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 5),
      style: ToastificationStyle.fillColored,
      dismissDirection: DismissDirection.vertical,
      alignment: Alignment.topCenter,
      type: ToastificationType.error,
      showProgressBar: false,
    );
  }

  static void showSuccess(BuildContext context, String message) {
    toastification.show(
      context: context,
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 5),
      style: ToastificationStyle.fillColored,
      dismissDirection: DismissDirection.vertical,
      alignment: Alignment.topCenter,
      type: ToastificationType.success,
      showProgressBar: false,
    );
  }
}
