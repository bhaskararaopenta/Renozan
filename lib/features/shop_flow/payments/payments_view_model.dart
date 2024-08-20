import 'package:app/core/base_provider.dart';

enum PaymentType {
  Cash,
  Credit,
}

class PaymentsViewModel extends BaseProvider {
  // PaymentsViewModel(this.productServiceRepository) {
  //   log.d('Creating PaymentsViewModel');

  bool _isChecked = false;

  PaymentType _paymentType = PaymentType.Cash;
  PaymentType get paymentType => _paymentType;
  bool get isChecked => _isChecked;

  void setPaymentType(PaymentType value) {
    _paymentType = value;
    notifyListeners();
  }

  void setDefaultCurrency(bool value) {
    _isChecked = value;
    notifyListeners();
  }
  //}
}
