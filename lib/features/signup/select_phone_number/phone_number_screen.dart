import 'package:app/app_routes.dart';
import 'package:app/core/base_provider.dart';
import 'package:app/core/constants/asset_constants.dart';
import 'package:app/core/ui/body_below_app_bar_widget.dart';
import 'package:app/core/ui/custom_snackbars.dart';
import 'package:app/core/widgets/appbar_reusable_widget.dart';
import 'package:app/features/signup/colors/AppColors.dart';
import 'package:app/features/signup/select_phone_number/phone_number_view_model.dart';
import 'package:app/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SelectPhoneNumberScreen extends StatefulWidget {
  const SelectPhoneNumberScreen({super.key});

  @override
  State<SelectPhoneNumberScreen> createState() => _SelectPhoneNumberScreen();
}

class _SelectPhoneNumberScreen extends State<SelectPhoneNumberScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final String _dialCode = "+1"; // Default dial code

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<SelectPhoneNumberViewModel>(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: _buildAppBar(),
        ),
        body: Consumer<SelectPhoneNumberViewModel>(
          builder: (context, viewModel, child) {
            switch (viewModel.getState) {
              case ViewState.init:
                return BodyBelowAppBarWidget(
                    child: _buildBody(context, viewModel));
              case ViewState.loading:
                return BodyBelowAppBarWidget(
                    child: _buildBody(context, viewModel));
              case ViewState.done:
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushNamed(context, AppRoutes.verification);
                });
                return BodyBelowAppBarWidget(
                    child: _buildBody(context, viewModel));
              case ViewState.error:
                showCustomSnackBar(context, viewModel.errorMessage);
                return BodyBelowAppBarWidget(
                    child: _buildBody(context, viewModel));
              default:
                return Container();
            }
          },
        ),
      ),
    );
  }

  CustomAppBar _buildAppBar() {
    return CustomAppBar(
      title: "Let's Get Started",
      showLeading: true,
      centerTitle: true,
      onLeadingIconTap: () {
        Navigator.pop(context);
      },
      leadingIcon: SvgPicture.asset(
        AssetsConstants.backIcon,
      ),
    );
  }

  Widget _buildBody(BuildContext context, SelectPhoneNumberViewModel model) {
    return Container(
      color: Color(0xFFFAFAFB),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              _buildPhoneHeader(),
              const SizedBox(
                height: 10,
              ),
              _buildMobileTextField(),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Already have an account ?",
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.greycolor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: InkWell(
                      onTap: () {
                        // Navigate to a page or show a dialog for getting Renozan
                      },
                      child: Text(
                        "Sign In",
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF5680FF),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              _buildSignUpButton(context, model),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneHeader() {
    return Text(
      "Enter your phone number for your confirmation\n code",
      style: GoogleFonts.plusJakartaSans(
        color: AppColors.greycolor,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildSignUpButton(
      BuildContext context, SelectPhoneNumberViewModel model) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: double.infinity,
          height: 44,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.signUpBtnColor,
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                model.submitPhoneNumber(_dialCode, _phoneController.text);
              }
            },
            child: Text(
              'Sign Up',
              style: GoogleFonts.plusJakartaSans(
                textStyle: TextStyle(
                  color: AppColors.whitecolor,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileTextField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // width: 96,
          // height: 50,
          height: 57,
          decoration: BoxDecoration(
            color: const Color(0xFFEFEFF3),
            borderRadius: BorderRadius.circular(38),
            border: Border.all(
              color: const Color(0xFFEFEFF3),
              width: 1.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(11),
            child: Row(
              children: [
                SvgPicture.asset(AssetsConstants.usFlag),
                const SizedBox(
                  width: 8,
                ),
                const Text("+1"),
                const SizedBox(
                  width: 8,
                ),
                SvgPicture.asset(AssetsConstants.arrowDown)
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: SizedBox(
            child: TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter mobile number";
                }
                // Check if the input contains only digits
                final numericRegex = RegExp(r'^[0-9]+$');
                if (!numericRegex.hasMatch(value)) {
                  return "Please enter a valid mobile number";
                }
                return null;
              },
              decoration: _textFieldDecoration(),
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _textFieldDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(
          vertical: 16, horizontal: 22), // Adjust padding as needed
      filled: true,
      fillColor: const Color(0xFFEFEFF3),
      hintText: "Mobile Number",
      hintStyle: GoogleFonts.plusJakartaSans(
        color: AppColors.greycolor,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      enabledBorder: OutlineInputBorder(
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
          // width: 2.0,
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
          color: Colors.red,
          //  width: 2.0,
        ),
      ),
    );
  }
}
