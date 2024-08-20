import 'package:app/app_routes.dart';
import 'package:app/core/widgets/renozan_welcome_widget.dart';
import 'package:flutter/material.dart';

class SignupAccountScreen extends StatelessWidget {
  const SignupAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const RenozanWelcomeWidget(
      buttonText1: 'Personal',
      buttonText2: 'Business',
      route1: AppRoutes.selectPhoneNumber,
      route2: AppRoutes.selectRole,
    );
  }
}
