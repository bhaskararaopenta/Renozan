import 'package:app/app_routes.dart';
import 'package:app/core/widgets/renozan_welcome_widget.dart';
import 'package:flutter/material.dart';

class AppWelcomeScreen extends StatelessWidget {
  const AppWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const RenozanWelcomeWidget(
      buttonText1: 'Log In',
      buttonText2: 'Sign Up',
      route1: AppRoutes.logIn,
      route2: AppRoutes.signupAccount,
    );
  }
}
