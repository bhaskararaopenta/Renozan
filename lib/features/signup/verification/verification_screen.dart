import 'package:app/app_routes.dart';
import 'package:app/core/base_provider.dart';
import 'package:app/core/constants/asset_constants.dart';
import 'package:app/core/ui/body_below_app_bar_widget.dart';
import 'package:app/core/ui/custom_snackbars.dart';
import 'package:app/core/widgets/appbar_reusable_widget.dart';
import 'package:app/features/signup/colors/AppColors.dart';
import 'package:app/features/signup/verification/verification_view_model.dart';
import 'package:app/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final otpControllers = <TextEditingController>[];
  final focusNodes = <FocusNode>[];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize controllers and focus nodes for 6 OTP fields
    for (int i = 0; i < 6; i++) {
      otpControllers.add(TextEditingController());
      focusNodes.add(FocusNode());
    }
  }

  @override
  void dispose() {
    // Dispose of controllers and focus nodes
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<VerifyOtpViewModel>(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: _buildAppBar(),
        ),
        body: Consumer<VerifyOtpViewModel>(
          builder: (context, viewModel, child) {
            switch (viewModel.getState) {
              case ViewState.init:
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showCustomSnackBar(context,
                      "Enter test OTP: ${viewModel.getTestOtp}. Remove this in production");
                });
                return BodyBelowAppBarWidget(
                    child: _buildBody(context, viewModel));

              case ViewState.loading:
                // Implement loading indicator if needed
                return _buildBodyWithLoadingIndicator(context, viewModel);
              case ViewState.done:
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushNamed(context, AppRoutes.userInformation);
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
      title: "Verification",
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

  Widget _buildBodyWithLoadingIndicator(
      BuildContext context, VerifyOtpViewModel model) {
    return Stack(
      children: [
        BodyBelowAppBarWidget(
            child: _buildBody(context, model)), // Show the existing body
        const Center(
            child: CircularProgressIndicator()), // Show the loading indicator
      ],
    );
  }

  Widget _buildBody(BuildContext context, VerifyOtpViewModel model) {
    return Container(
      color: const Color(0xFFFAFAFB),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Code sent to (603) 555-0123, unless you already\n have an account",
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.greycolor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(6, (index) {
                  return _buildOtpField(
                    index,
                    focusNodes[index],
                    otpControllers[index],
                    index < 5 ? focusNodes[index + 1] : null,
                  );
                }),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Text(
                    'Not receive code?',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.greycolor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Add functionality for resend code
                    },
                    child: Text(
                      '  Resend',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF5680FF),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.signUpBtnColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(65)),
                    ),
                  ),
                  onPressed: () {
                    bool allFieldsFilled = otpControllers
                        .every((controller) => controller.text.isNotEmpty);

                    if (!allFieldsFilled) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter verification code'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else if (_formKey.currentState?.validate() ?? false) {
                      String otp = otpControllers
                          .map((controller) => controller.text)
                          .join();
                      // Replace with actual token

                      model.submitOtp(otp);
                    }
                  },

                  // onPressed: () {
                  //   Navigator.pushNamed(context, AppRoutes.userInformation);
                  // },
                  child: Text(
                    "Confirm",
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.whitecolor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpField(
    int index,
    FocusNode focusNode,
    TextEditingController controller,
    FocusNode? nextFocusNode,
  ) {
    return Container(
      width: 50,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: const Color(0xFFEFEFF3),
      ),
      child: Center(
        child: TextFormField(
          focusNode: focusNode,
          controller: controller,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(
                1), // Ensure only one digit is allowed
          ],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: _otpFieldDecoration(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Color(0xFFA365ED),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return ''; // Empty string to show no message, but mark as invalid
            }
            return null; // Return null if valid
          },
          onChanged: (value) {
            if (value.isNotEmpty && nextFocusNode != null) {
              nextFocusNode.requestFocus();
            } else if (value.isEmpty && index > 0) {
              focusNodes[index - 1].requestFocus();
            }
          },
        ),
      ),
    );
  }

  InputDecoration _otpFieldDecoration() {
    return InputDecoration(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(12.0),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(12.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(12.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(12.0),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(12.0),
      ),
      fillColor: const Color(0xFFEFEFF3),
      filled: true,
    );
  }
}
