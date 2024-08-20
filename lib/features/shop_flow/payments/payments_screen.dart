import 'package:app/core/constants/asset_constants.dart';
import 'package:app/core/widgets/bottom_sheet_reusable_widget.dart';
import 'package:app/features/shop_flow/payments/payments_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PaymentsBottomSheets {
  showBottomSheetPaymentOptions(BuildContext context, PaymentsViewModel model) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      context: context,
      builder: (context) => ChangeNotifierProvider.value(
        value: model,
        child: Consumer<PaymentsViewModel>(
          builder: (context, value, child) => Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(AssetsConstants.bottomSheetNotch, height: 5),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Payment options",
                      style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF18202F),
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Default payment method for cash payments only.",
                        style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xFF9B9DA3),
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      )),
                  const SizedBox(height: 20),
                  _buildSelectType(model, AssetsConstants.dollarIcon, "Cash",
                      "Pay with your wallet", PaymentType.Cash),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildSelectType(model, AssetsConstants.creditsIcon, "Credit",
                      "Request goods on Credit", PaymentType.Credit),
                  const SizedBox(
                    height: 16,
                  ),
                  _buildCheckboxRow(model),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA365ED),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(65)),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(
                            context); // Close the current bottom sheet
                        // Retrieve the payment type from the ViewModel
                        final paymentType = model.paymentType;

                        // Perform actions based on the payment type
                        if (paymentType == PaymentType.Cash) {
                          showBottomSheetForPaymentSuccess(context);
                        } else if (paymentType == PaymentType.Credit) {
                          showBottomSheetForCreditsItems(context);
                        }
                      },
                      child: Text(
                        "Confirm",
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildSelectType(PaymentsViewModel viewModel, String imgAsset, String title,
      String subtitle, PaymentType paymentType) {
    return InkWell(
      customBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      onTap: () {
        viewModel.setPaymentType(paymentType);
        print("Role selected: $paymentType");
      },
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            contentPadding: const EdgeInsets.only(left: 1.0),
            leading: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color(0xFFFAFAFB),
              ),
              height: double.infinity,
              width: 50,
              child: SvgPicture.asset(
                imgAsset,
                fit: BoxFit.none,
              ),
            ),
            title: Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF18202F),
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
            subtitle: Text(
              subtitle,
              style: GoogleFonts.plusJakartaSans(
                  color: Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
            trailing: Container(
              margin: const EdgeInsets.all(10),
              child: _buildcustomCheckBox(viewModel.paymentType == paymentType),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildcustomCheckBox(bool selected) {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? Colors.transparent : Colors.grey,
          width: 2,
        ),
        color: selected ? const Color(0xFFA365ED) : Colors.transparent,
      ),
      child: selected
          ? const Icon(
              Icons.check,
              size: 16,
              color: Colors.white,
            )
          : null,
    );
  }

  Widget _buildCheckboxRow(PaymentsViewModel viewModel) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 10),
        Checkbox(
          focusColor: const Color(0xFF9B9DA3),
          shape: const CircleBorder(
              side: BorderSide(width: 16, color: Color(0xFF9B9DA3))),
          value: viewModel.isChecked,
          onChanged: (bool? newValue) {
            viewModel.setDefaultCurrency(newValue ?? false);
          },
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            'Set as default currency',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  showBottomSheetForCreditsItems(BuildContext context) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.white,
      builder: (
        BuildContext context,
      ) {
        return ReUsableBottomSheet(
            svgAssetPath:
                AssetsConstants.bottomSheetNotch, // Use the correct asset path
            imageAssetPath: AssetsConstants.alarm, // Use the correct asset path
            title: 'Autopay will be activated for\n credited items.',
            subtitle: "Please await Lasco to approve\n your credits",
            buttonText: "Credits",
            buttonColor: Colors.purple,
            onConfirm: () {
              Navigator.of(context).pop();
            }
            // Add any additional actions you want to perform on confirm
            );
      },
    );
  }

  showBottomSheetForPaymentSuccess(BuildContext context) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.white,
      builder: (
        BuildContext context,
      ) {
        return ReUsableBottomSheet(
            svgAssetPath:
                AssetsConstants.bottomSheetNotch, // Use the correct asset path
            imageAssetPath:
                AssetsConstants.paymentSucess, // Use the correct asset path
            title: 'Payment Successful',
            subtitle:
                "Your order was successful. Please keep track\n of orders via \"payments\"",
            buttonText: "Payments",
            buttonColor: Colors.purple,
            onConfirm: () {
              Navigator.of(context).pop();
            }
            // Add any additional actions you want to perform on confirm
            );
      },
    );
  }

  Future<void> showBottomSheetForPaymentFailed(BuildContext context) async {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.white,
      builder: (
        BuildContext context,
      ) {
        return ReUsableBottomSheet(
            svgAssetPath:
                AssetsConstants.bottomSheetNotch, // Use the correct asset path
            imageAssetPath:
                AssetsConstants.paymentFail, // Use the correct asset path
            title: 'Payment Failed',
            subtitle:
                "Please try again or contact support (Ren)\n if this error continues",
            buttonText: "Try Again",
            buttonColor: Colors.purple,
            onConfirm: () {
              Navigator.of(context).pop();
            }
            // Add any additional actions you want to perform on confirm
            );
      },
    );
  }

  Future<void> showBottomSheetToAttachCard(BuildContext context) async {
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        builder: (BuildContext context) {
          return Form(
            key: formKey,
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: SvgPicture.asset(
                          AssetsConstants.bottomSheetNotch,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        'Your wallet is empty, please attach a card to complete transaction.',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(AssetsConstants.lock),
                          const SizedBox(
                              width:
                                  8), // Add some space between the icon and the text
                          Text(
                            "Processed secured by trusted banks",
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.purple,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      _buildCardNumberField(),
                      const SizedBox(
                        height: 16,
                      ),
                      _buildNameFields(),
                      const SizedBox(
                        height: 40,
                      ),
                      _buildConfirmButton(formKey),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _buildConfirmButton(GlobalKey<FormState> formKey) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
        ),
        onPressed: () {
          if (formKey.currentState?.validate() ?? false) {
            // Form is valid, proceed with form submission
            // Add your submission logic here
            print('Form is valid, proceed with submission');
          } else {
            // Form is invalid, show error
            print('Form is invalid');
          }
        },
        child: Text(
          'Confirm',
          style: GoogleFonts.plusJakartaSans(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardNumberField() {
    return TextFormField(
      // controller: _accountNumberController,
      style: const TextStyle(color: Color(0xFF18202F)),
      decoration:
          _buildInputDecoration("Card Number", AssetsConstants.accountIcon),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter account number';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _buildNameFields() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            // controller: _firstNameController,
            style: const TextStyle(color: Color(0xFF18202F)),
            decoration:
                _buildInputDecoration("Expired", AssetsConstants.accountIcon),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter first name';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            //controller: _lastNameController,
            style: const TextStyle(color: Color(0xFF18202F)),
            decoration:
                _buildInputDecoration("CVC", AssetsConstants.accountIcon),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter last name';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration(String hintText, String assetPath) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFEFEFF3),
      border: InputBorder.none,
      hintText: hintText,
      hintStyle: GoogleFonts.plusJakartaSans(
        color: Colors.grey,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SvgPicture.asset(assetPath),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(38),
        borderSide: const BorderSide(
          color: Color(0xFFEFEFF3),
          width: 2.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(38),
        borderSide: const BorderSide(
          color: Color(0xFFEFEFF3),
          width: 2.0,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(38),
        borderSide: const BorderSide(
          color: Color(0xFFEFEFF3),
          width: 2.0,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(38),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
    );
  }
}
