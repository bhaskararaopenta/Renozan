import 'package:app/features/dashboard/dashboard_page.dart';
import 'package:app/features/dashboard/navbar_pages/scan_page.dart';
import 'package:app/features/login/enter_pin_screen.dart';
import 'package:app/features/login/login_screen.dart';
import 'package:app/features/login/main_welcome_screen.dart';
import 'package:app/features/manage_money/add_bank_account/add_bank_account_screen.dart';
import 'package:app/features/manage_money/cash_in_out/cash_in_out_screen.dart';
import 'package:app/features/manage_money/choose_a_bank/choosing_a_bank_screen.dart';
import 'package:app/features/shop_flow/distributors/distributor_screen.dart';
import 'package:app/features/shop_flow/products/products_screen.dart';
import 'package:app/features/signup/create_password/create_password_screen.dart';
import 'package:app/features/signup/select_phone_number/phone_number_screen.dart';
import 'package:app/features/signup/select_role/select_role_screen.dart';
import 'package:app/features/signup/user_info/user_info_screen.dart';
import 'package:app/features/signup/verification/verification_screen.dart';
import 'package:app/features/signup/welcome/signup_account_welcome_screen.dart';
import 'package:app/services/service_locator.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  //1.add new app pages here
  static const String appWelcome = '/appWelcome';
  static const String signupAccount = '/signupAccount';
  static const String logIn = '/logIn';
  static const String enterPin = '/enterPin';
  static const String selectRole = '/selectRole';
  static const String selectPhoneNumber = '/selectPhoneNumber';
  static const String verification = '/verification';
  static const String userInformation = '/userInformation';
  static const String createPassword = '/createPassword';
  static const String dashboard = '/dashboard';
  static const String cashInOut = '/cashInOut';
  static const String chooseBank = '/chooseBank';
  static const String addBankAccount = '/addBankAccount';
  static const String distributor = '/distributor';
  static const String products = '/products';
  //add scan page
  static const String scanCode = '/scanCode';

  //2.add new page to the routes map
  static Map<String, WidgetBuilder> get routes {
    return {
      appWelcome: (context) => const AppWelcomeScreen(),
      signupAccount: (context) => const SignupAccountScreen(),
      logIn: (context) => const LogInScreen(),
      enterPin: (context) => const EnterPinScreen(),
      selectRole: (context) => SelectRoleScreen(),
      selectPhoneNumber: (context) => const SelectPhoneNumberScreen(),
      verification: (context) => const VerificationScreen(),
      userInformation: (context) => UserInformationScreen(),
      createPassword: (context) => const CreatePasswordScreen(),
      dashboard: (context) => const DashboardPage(),
      cashInOut: (context) => const CashInOutPage(),
      scanCode: (context) => const ScanPage(),
      chooseBank: (context) => const ChoosingBank(),
      addBankAccount: (context) => const AddBankAccountScreen(),
      distributor: (context) => const DistributorScreen(),
    };
    //usage: navigate to a page by calling
    //Navigator.pushNamed(context, AppRoutes.dashboard);
  }

  //2.add new page which takes input arguments to the routes map
  static Route<dynamic>? routesWithInput(settings) {
    log.d('generateRoutes: ${settings.name}');
    switch (settings.name) {
      // add the page with input argument here like below
      // case AppRoutes.dashboard:
      //   final args = settings.arguments as Map<String, dynamic>?;
      //   final selectedIndex = args?['selectedIndex'];
      //   return MaterialPageRoute(
      //     builder: (context) => DashboardPage(selectedIndex: selectedIndex),
      //   );
      case AppRoutes.products:
        final args = settings.arguments as Map<String, dynamic>?;
        final brandId = args?['brandId'] as int;
        final brandName = args?['brandName'] as String;
        return MaterialPageRoute(
          builder: (context) => ProductsScreen(
            brandId: brandId,
            brandName: brandName,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const AppWelcomeScreen(),
        );
    }
  }
  // Example usage: on button press, navigate to a page with input argument. simply call
  // Navigator.pushNamed( context, AppRoutes.dashboard, arguments: {'selectedIndex': 1});

  //Example usage: delete all previous screens and navigate to new screen
  // WidgetsBinding.instance.addPostFrameCallback((_) { //postFrameCallback needed only if navigating from view state
  //                       //pop out all other screens and navigate to dashboard
  //                       Navigator.pushNamedAndRemoveUntil(
  //                         context,
  //                         AppRoutes.dashboard,
  //                         (route) => false,
  //                       );
  // });
}
