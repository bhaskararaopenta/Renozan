import 'package:app/app_widget.dart';
import 'package:app/services/service_locator.dart';
import 'package:flutter/material.dart';

void main() {
  // Setup service locator
  setupLocator();
  runApp(const RenozanApp());
}
