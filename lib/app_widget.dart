import 'package:app/app_routes.dart';
import 'package:app/app_view_model.dart';
import 'package:app/core/base_provider.dart';
import 'package:app/features/login/enter_pin_screen.dart';
import 'package:app/features/login/main_welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/service_locator.dart';

class RenozanApp extends StatelessWidget {
  const RenozanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<AppViewModel>()..checkUserLoginStatus(),
      child: Consumer<AppViewModel>(
        builder: (context, appViewModel, child) {
          log.d('build: App widget');
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Renozan App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            // Determine the initial home screen based on the authentication state
            home: _getInitialScreen(context, appViewModel),
            routes: AppRoutes.routes,
            onGenerateRoute: AppRoutes.routesWithInput,
          );
        },
      ),
    );
  }

  Widget _getInitialScreen(BuildContext context, AppViewModel appViewModel) {
    switch (appViewModel.getState) {
      case ViewState.loading:
        return const Center(child: CircularProgressIndicator());
      case ViewState.done:
        return const EnterPinScreen();
      case ViewState.init:
      case ViewState.empty:
        return const AppWelcomeScreen();
      default:
        return const AppWelcomeScreen();
    }
  }
}
