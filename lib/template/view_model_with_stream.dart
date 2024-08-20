import 'package:app/core/exceptions.dart';
import 'package:app/core/base_provider.dart';

class ViewModelWithStream extends BaseProvider {
  final UserRepository _userRepository;

  ViewModelWithStream(this._userRepository) {
    _loadUser();
  }
  void _loadUser() {
    setState(ViewState.loading);

    _userRepository.fetchUser().listen(
      (user) {
        //update user data here

        //then
        setState(ViewState.done);
      },
      onError: (e) {
        if (e is AppException) {
          handleException(e);
        } else {
          //set current screen specific error message or use a generic one
          setStateToErrorWithMessage('An unexpected error occurred.');
        }
      },
    );
  }
}

//just a dummy class to represent a repository
class UserRepository {
  fetchUser() {}
}
