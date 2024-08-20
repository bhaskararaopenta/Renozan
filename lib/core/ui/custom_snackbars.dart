import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String message) {
  return WidgetsBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  });
}

void showCustomSnackBarWithAction(BuildContext context, String message,
    String actionLabel, Function() action) {
  return WidgetsBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: actionLabel,
        onPressed: action,
      ),
    ));
  });
}

void showCustomStickySnackBar(BuildContext context, String message) {
  return WidgetsBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
      duration: const Duration(minutes: 1),
    ));
  });
}
