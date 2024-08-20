import 'package:app/app_view_model.dart';
import 'package:app/features/home/distributors_repo_implementation.dart';
import 'package:app/features/home/distributors_repository_interface.dart';
import 'package:app/features/home/home_screen_view_model.dart';
import 'package:app/features/home/recentActivity_repo_implementation.dart';
import 'package:app/features/home/recentActivity_repository_interface.dart';
import 'package:app/features/inventory/data/inventory_repo.dart';
import 'package:app/features/inventory/inventory_view_model.dart';
import 'package:app/features/login/enter_pin_view_model.dart';
import 'package:app/features/login/login_view_model.dart';
import 'package:app/features/manage_money/add_bank_account/add_bank_account_view_model.dart';
import 'package:app/features/manage_money/add_bank_account/add_bankaccount_repository.dart';
import 'package:app/features/manage_money/add_bank_account/user_bank_account_model.dart';
import 'package:app/features/manage_money/cash_in_out/bank_account_repo_implementation.dart';
import 'package:app/features/manage_money/cash_in_out/bank_account_repository.dart';
import 'package:app/features/manage_money/cash_in_out/cash_in_out_view_model.dart';
import 'package:app/features/manage_money/choose_a_bank/choose_a_bank_repo_implementation.dart';
import 'package:app/features/manage_money/choose_a_bank/choose_a_bank_repository.dart';
import 'package:app/features/manage_money/choose_a_bank/choose_a_bank_view_model.dart';
import 'package:app/features/product_service/product_service_repository.dart';
import 'package:app/features/shop_flow/distributors/distributor_view_model.dart';
import 'package:app/features/shop_flow/payments/payments_view_model.dart';
import 'package:app/features/shop_flow/products/products_view_model.dart';
import 'package:app/features/signup/create_password/create_password_repository_impl.dart';
import 'package:app/features/signup/create_password/create_password_repository_interface.dart';
import 'package:app/features/signup/create_password/create_password_view_model.dart';
import 'package:app/features/signup/select_phone_number/phone_number_view_model.dart';
import 'package:app/features/signup/select_phone_number/phone_repository_impl.dart';
import 'package:app/features/signup/select_phone_number/phone_repository_interface.dart';
import 'package:app/features/signup/select_role/pos_repository_impl.dart';
import 'package:app/features/signup/select_role/pos_repository_interface.dart';
import 'package:app/features/signup/select_role/select_role_view_model.dart';
import 'package:app/features/signup/user_info/use_info_view_model.dart';
import 'package:app/features/signup/user_info/user_info_repo_impl.dart';
import 'package:app/features/signup/user_info/user_info_repository_interface.dart';
import 'package:app/features/signup/verification/verification_repository_impl.dart';
import 'package:app/features/signup/verification/verification_view_model.dart';
import 'package:app/features/user_account/user_auth_repository.dart';
import 'package:app/features/wallet/wallet_repository.dart';
import 'package:app/mocks/card_repo_implementation.dart';
import 'package:app/mocks/card_repository_interface.dart';
import 'package:app/services/api_service.dart';
import 'package:app/services/secure_storage_service.dart';
import 'package:app/template/page_with_api_data/page_view_model.dart';
import 'package:app/template/page_with_api_data/repository_implementation.dart';
import 'package:app/template/page_with_api_data/repository_interface.dart';
import 'package:app/template/simple_page/simple_page_view_model.dart';
import 'package:app/template/view_model_with_stream.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:logger/logger.dart';

import '../features/signup/verification/verification_repository_interface.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  //Common App dependencies
  getIt.registerLazySingleton(() => initLogger());
  getIt.registerLazySingleton(() => InternetConnection());
  getIt.registerLazySingleton<http.Client>(() => http.Client());
  getIt.registerLazySingleton<SecureStorageService>(
      () => SecureStorageService());
  getIt.registerLazySingleton(
    () => ApiService(
      client: getIt<http.Client>(),
      baseUrl: 'https://renozandev.digipaysol.com/',
      secureStorageService: getIt<SecureStorageService>(),
    ),
  );

  // Template code dependencies
  getIt.registerLazySingleton<UserRepository>(() => UserRepository());
  getIt.registerFactory(() => SimplePageViewModel());
  getIt.registerLazySingleton<ProductsRepository>(
      () => ProductsRepositoryImpl(getIt<http.Client>()));
  getIt.registerFactory(() => ProductsViewModel(getIt<ProductsRepository>()));

  // Wallet -> common for all features
  getIt.registerLazySingleton(() => AppViewModel(getIt<UserAuthRepository>()));
  getIt.registerLazySingleton<WalletRepository>(() => WalletRepositoryImpl(
      apiService: getIt<ApiService>(),
      secureStorageService: getIt<SecureStorageService>()));

  // Feature -> home
  getIt.registerLazySingleton<CardRepository>(
      () => MockCardRepository(getIt<http.Client>()));
  getIt.registerLazySingleton<DistributorsRepository>(
      () => MockDistributorsRepository(getIt<http.Client>()));
  getIt.registerLazySingleton<RecentActivityRepository>(
      () => MockRecentActivityRepository(getIt<http.Client>()));
  getIt.registerLazySingleton<BankDetailsRepository>(
      () => ImplementationBankDetailsRepository(getIt<http.Client>()));
  getIt.registerLazySingleton<GetBanksListRepository>(
      () => ImplementationChooseBankRepository(getIt<http.Client>()));
  getIt.registerFactory(() => UserBankAccountModel());
  getIt.registerLazySingleton<AddBankAccountRepository>(() =>
      AddBankAccountRepository(userBankAccount: getIt<UserBankAccountModel>()));
  //tbd: register distributors repository and recent activity repository
  getIt.registerFactory(() => HomeScreenViewModel(
      getIt<UserAuthRepository>(),
      getIt<WalletRepository>(),
      getIt<RecentActivityRepository>(),
      getIt<ProductServiceRepository>()));
  getIt.registerFactory(() => CashInOutViewModel(
      getIt<CardRepository>(), getIt<BankDetailsRepository>()));
  getIt.registerFactory(() => ChooseBankViewModel(
      getIt<GetBanksListRepository>(), getIt<AddBankAccountRepository>()));
  // getIt.registerFactory(
  //     () => AddBankAccountViewModel(getIt<AddBankAccountRepository>()));
  // Register the ViewModel, assuming it needs the repository

  getIt.registerFactory<AddBankAccountViewModel>(
      () => AddBankAccountViewModel(getIt<AddBankAccountRepository>()));

  // Feature -> shop
  getIt.registerFactory(() => DistributorViewModel(
      getIt<ProductServiceRepository>(), getIt<DistributorsRepository>()));
  getIt.registerFactory(
      () => BrandProductsViewModel(getIt<ProductServiceRepository>()));
  getIt.registerFactory(() => PaymentsViewModel());

  //Feature  -> inventory
  getIt.registerFactory(
      () => InventoryViewModel(getIt<RetailerInventoryRepository>()));

  // Feature -> signup
  getIt.registerLazySingleton<UserAuthRepository>(() => UserAuthRepositoryImpl(
      apiService: getIt<ApiService>(),
      secureStorageService: getIt<SecureStorageService>(),
      isMockDataOn: true));
  getIt.registerLazySingleton<PosRepository>(
      () => PosRepositoryImpl(getIt<http.Client>()));

  getIt.registerFactory(
      () => SelectRolePageViewModel(getIt<UserAuthRepository>()));

  getIt.registerLazySingleton<PhoneRepository>(
      () => PhoneRepositoryImpl(getIt<http.Client>()));
  getIt.registerLazySingleton<UserInfoRepository>(
      () => UserInfoRepositoryImpl(getIt<http.Client>()));
  getIt.registerFactory(() => UserInfoViewmodel(getIt<UserAuthRepository>()));
  getIt.registerFactory(
      () => SelectPhoneNumberViewModel(getIt<UserAuthRepository>()));
  getIt.registerLazySingleton<VerificationRepository>(
      () => VerificationRepositoryImpl(getIt<http.Client>()));
  getIt.registerFactory(() => VerifyOtpViewModel(getIt<UserAuthRepository>()));

  getIt.registerLazySingleton<CreatePasswordRepository>(
      () => CreatePasswordRepositoryImpl(getIt<http.Client>()));
  getIt.registerFactory(
      () => CreatePasswordViewModel(getIt<UserAuthRepository>()));

  //TBD:: move product service to right place
  getIt.registerLazySingleton<ProductServiceRepository>(() =>
      ProductServiceRepositoryImpl(
          apiService: getIt<ApiService>(),
          secureStorageService: getIt<SecureStorageService>()));
  getIt.registerLazySingleton(
      () => RetailerInventoryRepository(apiService: getIt<ApiService>()));

  // Feature -> login
  getIt.registerFactory(() => EnterPinViewModel(getIt<UserAuthRepository>()));
  getIt.registerFactory(() => LoginViewModel(getIt<UserAuthRepository>()));
}

Logger initLogger() {
  Logger logger;

  if (kDebugMode) {
    logger = Logger(
      level: Level.all,
      printer: PrettyPrinter(
          methodCount: 0, // Number of method calls to be displayed
          errorMethodCount:
              8, // Number of method calls if stacktrace is provided
          lineLength: 120, // Width of the output
          colors: true, // Colorful log messages
          printEmojis: true, // Print an emoji for each log message
          printTime: false // Should each log print contain a timestamp
          ),
    );
  } else {
    logger = Logger(
      level: Level.off,
    );
  }
  return logger;
}

//global singleton objects
Logger get log => getIt<Logger>();
InternetConnection get networkStatus => getIt<InternetConnection>();
