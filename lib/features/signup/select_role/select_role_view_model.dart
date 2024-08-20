import 'package:app/core/base_provider.dart';
import 'package:app/core/exceptions.dart';
import 'package:app/features/user_account/retailer_role.dart';
import 'package:app/features/user_account/user_auth_repository.dart';
import 'package:app/services/service_locator.dart';

class SelectRolePageViewModel extends BaseProvider {
  final UserAuthRepository userAuthRepository;

  RetailerRole _selectedRole = RetailerRole.owner;
  RetailerRole get selectedRole => _selectedRole;

  void setSelectedRole(RetailerRole value) {
    _selectedRole = value;
    notifyListeners();
  }

  bool _showBottomSheet = false;

  bool get showBottomSheet => _showBottomSheet;

  set showBottomSheet(bool value) {
    _showBottomSheet = value;
    notifyListeners(); // Notify listeners when the flag changes
  }

  String? _imageUrl;
  String? get imageUrl => _imageUrl;

  String? _name;
  String? get name => _name;

  SelectRolePageViewModel(this.userAuthRepository) {
    log.d('Creating SelectPositionPageViewModel');
  }

  Future<void> uploadPosNumber(String posNumber) async {
    setState(ViewState.loading);

    try {
      final result =
          await userAuthRepository.verifyBusiness(posNumber, selectedRole);
      _imageUrl = result.businessLogo;
      _name = result.businessName;

      setState(ViewState.done);
    } on AppException catch (e) {
      handleException(e);
    } catch (e, s) {
      log.e('Error: $e \n StackTrace: $s');
      setStateToErrorWithMessage('An unexpected error occurred.');
    }
  }
}
