import 'package:app/app_routes.dart';
import 'package:app/core/base_provider.dart';
import 'package:app/core/constants/asset_constants.dart';
import 'package:app/core/ui/body_below_app_bar_widget.dart';
import 'package:app/core/ui/custom_snackbars.dart';
import 'package:app/core/widgets/appbar_reusable_widget.dart';
import 'package:app/features/signup/colors/AppColors.dart';
import 'package:app/features/signup/select_role/select_role_view_model.dart';
import 'package:app/features/user_account/retailer_role.dart';
import 'package:app/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SelectRoleScreen extends StatelessWidget {
  SelectRoleScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _posController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<SelectRolePageViewModel>(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: _buildAppBar(context),
        ),
        body: Consumer<SelectRolePageViewModel>(
          builder: (context, viewModel, child) {
            switch (viewModel.getState) {
              case ViewState.init:
                return BodyBelowAppBarWidget(
                    child: _buildBody(context, viewModel));
              case ViewState.loading:
                return _buildBodyWithLoadingIndicator(context, viewModel);
              case ViewState.done:
                if (viewModel.showBottomSheet) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showBottomSheetForConfirmation(context, viewModel);
                    viewModel.showBottomSheet =
                        false; // Reset the flag after showing the bottom sheet
                  });
                }
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

  Widget _buildBodyWithLoadingIndicator(
      BuildContext context, SelectRolePageViewModel model) {
    return Stack(
      children: [
        BodyBelowAppBarWidget(
            child: _buildBody(context, model)), // Show the existing body
        const Center(
            child: CircularProgressIndicator()), // Show the loading indicator
      ],
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: "Select Position",
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

  Widget _buildBody(BuildContext context, SelectRolePageViewModel model) {
    return Container(
      color: Colors.white,
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRoleHeader(),
              const SizedBox(height: 16),
              _buildroleSelectionCard(
                model,
                AssetsConstants.iconOwner,
                "Owner/Senior Executive",
                "Access to all functionalities",
                RetailerRole.owner,
              ),
              const SizedBox(height: 2),
              _buildroleSelectionCard(
                model,
                AssetsConstants.iconStaff,
                "Staff/Normal Employee",
                "Access to all features besides wallet",
                RetailerRole.staff,
              ),
              const SizedBox(height: 30),
              _buildPosTextField(model),
              const SizedBox(height: 30),
              Center(
                child: InkWell(
                  onTap: () {
                    // Navigate to a page or show a dialog for getting Renozan
                  },
                  child: Text(
                    "Don't have a Renozan?",
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF5680FF),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              _buildConfirmButton(context, model),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleHeader() {
    return Text(
      "What is your role:",
      style: GoogleFonts.plusJakartaSans(
        color: AppColors.greycolor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildConfirmButton(
      BuildContext context, SelectRolePageViewModel model) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.signUpBtnColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(65)),
          ),
        ),
        onPressed: () async {
          if (_formKey.currentState?.validate() ?? false) {
            final String posNumber = _posController.text;
            if (posNumber.isNotEmpty) {
              model.uploadPosNumber(posNumber);

              // Set flag to show bottom sheet after uploading POS number
              model.showBottomSheet = true;
            }
          } else {
            log.e('Form validation failed'); // Debug log
          }
        },
        child: Text(
          "Confirm",
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.whitecolor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildPosTextField(SelectRolePageViewModel model) {
    return Column(
      children: [
        Text(
          "Enter the unique number given to your POS system to access your account",
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.greycolor,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _posController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter POS Number';
            }
            return null;
          },
          onChanged: (value) {
            // You can handle additional logic here if needed
          },
          decoration: InputDecoration(
            hintText: 'Unique POS number',
            hintStyle: GoogleFonts.plusJakartaSans(
              color: AppColors.greycolor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(20),
              child: SvgPicture.asset(AssetsConstants.posNumberIcon),
            ),
            filled: true,
            fillColor: const Color(0xFFEFEFF3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(38),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(38),
              borderSide: const BorderSide(
                color: Color(0xFFEFEFF3),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(38),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 243, 13, 5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(38),
              borderSide: const BorderSide(color: Color(0xFFEFEFF3)),
            ),
          ),
        ),
      ],
    );
  }

  // Custom radio button widget
  Widget _buildcustomCheckBox(bool selected) {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? Colors.transparent : AppColors.greycolor,
          width: 2,
        ),
        color: selected ? AppColors.signUpBtnColor : Colors.transparent,
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

  // Role selection card
  Widget _buildroleSelectionCard(
    SelectRolePageViewModel model,
    String imageAsset,
    String title,
    String description,
    RetailerRole role,
  ) {
    return InkWell(
      customBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      onTap: () {
        model.setSelectedRole(role);
        log.t("Role selected: $role");
      },
      child: Card(
        color: AppColors.whitecolor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              SizedBox(
                child: Image.asset(
                  imageAsset,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF18202F),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.greycolor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: _buildcustomCheckBox(model.selectedRole == role),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showBottomSheetForConfirmation(
      BuildContext context, SelectRolePageViewModel model) async {
    print("showing bottom sheet for conformatiom"); //debug log
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(15),
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(height: 5),
                      SvgPicture.asset(AssetsConstants.bottomSheetNotch,
                          height: 5),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Is this your organization?',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Center(
                              child: model.imageUrl != null &&
                                      model.imageUrl!.isNotEmpty
                                  ? Image.asset(
                                      model.imageUrl!,
                                      height: 80,
                                      width: 80,
                                    )
                                  : Container(),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                model.name ?? 'No Name',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.greycolor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.signUpBtnColor,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(65)),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, AppRoutes.selectPhoneNumber);
                                },
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
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
