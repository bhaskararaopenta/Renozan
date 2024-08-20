
import 'package:app/core/base_provider.dart';

class SimplePageViewModel extends BaseProvider {

  int _counter = 0;
  int get counter => _counter;

  void incrementCounter() {
    _counter++;
    notifyListeners();
  }
}