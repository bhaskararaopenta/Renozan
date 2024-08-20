import 'package:app/app_routes.dart';
import 'package:app/core/base_provider.dart';
import 'package:app/core/constants/asset_constants.dart';
import 'package:app/core/ui/body_below_app_bar_widget.dart';
import 'package:app/core/ui/custom_snackbars.dart';
import 'package:app/core/widgets/appbar_reusable_widget.dart';
import 'package:app/features/signup/colors/AppColors.dart';
import 'package:app/features/signup/user_info/use_info_view_model.dart';
import 'package:app/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class UserInformationScreen extends StatelessWidget {
  UserInformationScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _dobController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<UserInfoViewmodel>(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: _buildAppBar(context),
        ),
        body: Consumer<UserInfoViewmodel>(
          builder: (context, viewModel, child) {
            switch (viewModel.getState) {
              case ViewState.init:
                return BodyBelowAppBarWidget(
                    child: _buildBody(context, viewModel));
              case ViewState.loading:
                return _buildBodyWithLoadingIndicator(context, viewModel);
              case ViewState.done:
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushNamed(context, AppRoutes.createPassword);
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

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: "User Information",
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
      BuildContext context, UserInfoViewmodel viewModel) {
    return Stack(
      children: [
        BodyBelowAppBarWidget(
            child: _buildBody(context, viewModel)), // Show the existing body
        const Center(
            child: CircularProgressIndicator()), // Show the loading indicator
      ],
    );
  }

  Widget _buildBody(BuildContext context, UserInfoViewmodel model) {
    return Container(
      color: Color(0xFFFAFAFB),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderText(),
              const SizedBox(height: 30),
              _buildTextField(
                  controller: _nameController,
                  labelText: "Name",
                  prefixIcon: AssetsConstants.nameIcon,
                  validator: _validateName,
                  context: context),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _dobController,
                labelText: "Date of Birth",
                prefixIcon: AssetsConstants.calenderIcon,
                validator: _validateDob,
                context: context,
                isDOBField: true,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                  controller: _addressController,
                  labelText: "Address",
                  prefixIcon: AssetsConstants.locationIcon,
                  validator: _validateAddress,
                  context: context),
              const SizedBox(height: 20),
              _buildTextField(
                  controller: _emailController,
                  labelText: "Email",
                  prefixIcon: AssetsConstants.mailIcon,
                  validator: _validateEmail,
                  context: context),
              const SizedBox(height: 10),
              _buildCheckboxRow(model),
              const Spacer(),
              _buildConfirmButton(context, model),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderText() {
    return Text(
      "Details must match your official documents",
      style: GoogleFonts.plusJakartaSans(
        color: AppColors.greycolor,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String labelText,
    required String prefixIcon,
    FormFieldValidator<String>? validator,
    bool isDOBField = false, // Add a boolean parameter to distinguish DOB field
  }) {
    final FocusNode focusNode = FocusNode();
    final ValueNotifier<bool> isFocused = ValueNotifier<bool>(false);

    focusNode.addListener(() {
      isFocused.value = focusNode.hasFocus;
    });

    return FormField<String>(
      validator: validator,
      builder: (FormFieldState<String> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: isFocused,
              builder: (context, hasFocus, child) {
                final textField = TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  style: const TextStyle(color: Color(0xFF18202F)),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(7),
                    border: InputBorder.none,
                    labelText: labelText,
                    labelStyle: GoogleFonts.plusJakartaSans(
                      color: AppColors.greycolor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset(prefixIcon),
                    ),
                  ),
                  onChanged: isDOBField
                      ? null
                      : (value) {
                          field.didChange(value); // Update the FormField state
                        },
                );

                return isDOBField
                    ? GestureDetector(
                        onTap: () async {
                          final DateTime initialDate = DateTime(2000, 5, 25);
                          final DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: initialDate,
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (selectedDate != null) {
                            final String dateString =
                                '${selectedDate.year}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.day.toString().padLeft(2, '0')}';
                            controller.text = dateString;
                            field.didChange(
                                dateString); // Update the FormField state
                          }
                        },
                        child: AbsorbPointer(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFEFF3),
                              border: Border.all(
                                color: field.hasError
                                    ? Colors.red
                                    : (hasFocus
                                        ? Colors.transparent
                                        : Colors.transparent),
                              ),
                              borderRadius: BorderRadius.circular(38),
                            ),
                            child: textField,
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFEFF3),
                          border: Border.all(
                            color: field.hasError
                                ? Colors.red
                                : (hasFocus
                                    ? Colors.transparent
                                    : Colors.transparent),
                          ),
                          borderRadius: BorderRadius.circular(38),
                        ),
                        child: textField,
                      );
              },
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 15),
                child: Text(
                  field.errorText!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildCheckboxRow(UserInfoViewmodel model) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 10),
        Checkbox(
          focusColor: const Color(0xFF9B9DA3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          value: model.isChecked,
          onChanged: (bool? newValue) {
            model.setChecked(newValue ?? false);
          },
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            'Keep me up to date about New Renozan offers\nProduct & Service',
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.greycolor,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmButton(BuildContext context, UserInfoViewmodel model) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.signUpBtnColor,
        ),
        onPressed: () {
          if (_formKey.currentState?.validate() ?? false) {
            if (model.isChecked) {
              model.submitUserInfo(
                _nameController.text,
                _dobController.text,
                _addressController.text,
                _emailController.text,
              );
            } else {
              // Show a message to the user indicating that the checkbox must be checked
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Please check the checkbox to proceed')),
              );
            }
          }
        },
        child: Text(
          'Confirm',
          style: GoogleFonts.plusJakartaSans(
            textStyle: TextStyle(
              color: AppColors.whitecolor,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateDob(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select your date of birth';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your address';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    }
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }
}
