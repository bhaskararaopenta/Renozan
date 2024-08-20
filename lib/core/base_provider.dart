import 'package:app/core/exceptions.dart';
import 'package:flutter/material.dart';

enum ViewState {
  init, // State when view is being created first time
  loading, // State when data is being loaded
  done, // State when data is successfully loaded
  empty, // State when data is empty
  error, // State when an error occurs
  reset,
}

class BaseProvider extends ChangeNotifier {
  ViewState state = ViewState.init;
  String errorMessage = '';

  ViewState get getState => state;
  String get getErrorMessage => errorMessage;

  void setState(ViewState newState) {
    state = newState;
    notifyListeners();
  }

  void setStateToErrorWithMessage(String message) {
    errorMessage = message;
    state = ViewState.error;
    notifyListeners();
  }

  void handleException(AppException e) {
    setStateToErrorWithMessage(e.userFriendlyMessage);
  }
}
