import 'package:app/app_routes.dart';
import 'package:app/core/base_provider.dart';
import 'package:app/core/constants/asset_constants.dart';
import 'package:app/core/ui/body_below_app_bar_widget.dart';
import 'package:app/features/login/login_view_model.dart';
import 'package:app/features/signup/colors/AppColors.dart';
import 'package:app/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<LoginViewModel>(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: SvgPicture.asset(AssetsConstants.backIcon),
          ),
          centerTitle: true,
          title: Text(
            "Login",
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          elevation: 0,
        ),
        body: const BodyBelowAppBarWidget(
          child: _LogInBody(),
        ),
      ),
    );
  }
}

class _LogInBody extends StatefulWidget {
  const _LogInBody({super.key});

  @override
  State<_LogInBody> createState() => _LogInBodyState();
}

class _LogInBodyState extends State<_LogInBody> {
  final pinControllers =
      List<TextEditingController>.generate(6, (_) => TextEditingController());
  final TextEditingController phoneNumberController = TextEditingController();
  final focusNodes = List<FocusNode>.generate(6, (_) => FocusNode());
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    for (var controller in pinControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Phone Number",
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: phoneNumberController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'Enter phone number',
                          hintStyle: GoogleFonts.plusJakartaSans(
                            color: AppColors.greycolor,
                            fontSize: 16,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFEFEFF3),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFEFEFF3),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF4F4F4),
                        ),
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "6 Digit PIN",
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(6, (index) {
                          return _buildOtpField(
                            index,
                            focusNodes[index],
                            pinControllers[index],
                            index < 5 ? focusNodes[index + 1] : null,
                          );
                        }),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Oops !",
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
                                // Navigate to a page or show a dialog for forgotten pin
                              },
                              child: Text(
                                "forgot my pin",
                                style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFF5680FF),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: Consumer<LoginViewModel>(
                  builder: (context, viewModel, child) {
                    if (viewModel.state == ViewState.done) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        // Navigate to the dashboard screen
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.dashboard,
                          (route) => false,
                        );
                      });
                    } else if (viewModel.state == ViewState.error) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(viewModel.errorMessage),
                          ),
                        );
                      });
                    }

                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.signUpBtnColor,
                      ),
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          String password = pinControllers
                              .map((controller) => controller.text)
                              .join();
                          viewModel.login(phoneNumberController.text, password);
                        }
                      },
                      child: viewModel.getState == ViewState.loading
                          ? CircularProgressIndicator(
                              color: AppColors.whitecolor)
                          : Text(
                              'Confirm',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.whitecolor,
                                fontSize: 20,
                              ),
                            ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpField(int index, FocusNode focusNode,
      TextEditingController controller, FocusNode? nextFocusNode) {
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
            LengthLimitingTextInputFormatter(1),
          ],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
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
          ),
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
}
