import 'package:app/core/base_provider.dart';
import 'package:app/core/constants/asset_constants.dart';
import 'package:app/core/ui/body_below_app_bar_widget.dart';
import 'package:app/core/ui/custom_snackbars.dart';
import 'package:app/core/widgets/appbar_reusable_widget.dart';
import 'package:app/features/manage_money/add_bank_account/add_bank_account_view_model.dart';
import 'package:app/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddBankAccountScreen extends StatefulWidget {
  const AddBankAccountScreen({super.key});

  @override
  State<AddBankAccountScreen> createState() => _AddBankAccountScreenState();
}

class _AddBankAccountScreenState extends State<AddBankAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();

  @override
  void dispose() {
    // Dispose of controllers when the widget is removed from the widget tree
    _firstNameController.dispose();
    _lastNameController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => getIt<AddBankAccountViewModel>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: _buildAppBar(),
        ),
        body: Consumer<AddBankAccountViewModel>(
          builder: (context, viewModel, child) {
            switch (viewModel.state) {
              case ViewState.init:
                return BodyBelowAppBarWidget(child: _body(context, viewModel));

              case ViewState.loading:
                return BodyBelowAppBarWidget(
                  child: _body(context, viewModel, showProgress: true),
                );

              //_body(context, viewModel, showProgress: true);
              case ViewState.error:
                showCustomSnackBar(context, viewModel.errorMessage);
                return BodyBelowAppBarWidget(
                    child: _body(context, viewModel, showBottomSheet: true));
              case ViewState.done:
                return BodyBelowAppBarWidget(
                    child: _body(context, viewModel, showBottomSheet: true));

              //_body(context, viewModel, showBottomSheet: true);
              default:
                return const Center(
                  child: Text("data"),
                );
            }
          },
        ),
      ),
    );
  }

  CustomAppBar _buildAppBar() {
    return CustomAppBar(
      title: "Add Bank Account",
      centerTitle: true,
      showLeading: true,
      leadingIcon: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: SvgPicture.asset(AssetsConstants.backIcon),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Image.asset(AssetsConstants.globePic),
        ),
      ],
    );
  }

  Widget _body(BuildContext context, AddBankAccountViewModel viewModel,
      {bool showProgress = false, bool showBottomSheet = false}) {
    if (showBottomSheet && viewModel.hasShownBottomSheet) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showBottomSheetForConfirmation(context);
        viewModel.resetBottomSheetFlag(); // Reset flag after showing
      });
    }

    return Form(
      key: _formKey,
      child: Container(
        color: Color(0xFFFAFAFB),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildBankCard(viewModel),
              const SizedBox(height: 24),
              _buildTitle(),
              const SizedBox(height: 16),
              _buildNameFields(),
              const SizedBox(height: 16),
              _buildAccountTypeDropdown(viewModel),
              const SizedBox(height: 16),
              _buildAccountNumberField(),
              const SizedBox(height: 16),
              _buildBranchDropdown(viewModel),
              const Spacer(),
              _buildAttachBankButton(viewModel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBankCard(AddBankAccountViewModel viewModel) {
    final bankName = viewModel.bankDetails?.name ?? 'Unknown Bank';
    return Card(
      color: Colors.white,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListTile(
          splashColor: Colors.grey.withOpacity(0.1),
          contentPadding: const EdgeInsets.only(left: 2.0),
          leading: Image.asset(AssetsConstants.iconOwner),
          title: Text(
            bankName,
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: const Color(0xFF18202F),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      "Enter banking credentials",
      style: GoogleFonts.plusJakartaSans(
        color: const Color(0xFF18202F),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildNameFields() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _firstNameController,
            style: const TextStyle(color: Color(0xFF18202F)),
            decoration:
                _buildInputDecoration("First Name", AssetsConstants.nameIcon),
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
            controller: _lastNameController,
            style: const TextStyle(color: Color(0xFF18202F)),
            decoration:
                _buildInputDecoration("Last Name", AssetsConstants.nameIcon),
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
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(
            left: 14, right: 8.0), // Adjust padding here for space
        child: SizedBox(
          width: 20, // Specify the width to control icon size
          height: 20, // Specify the height to control icon size
          child: SvgPicture.asset(assetPath),
        ),
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
        borderSide: const BorderSide(),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(38),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
    );
  }

  Widget _buildAccountTypeDropdown(AddBankAccountViewModel viewModel) {
    return DropdownButtonFormField<String>(
      value: viewModel.selectedAccountType,
      decoration: _buildDropdownInputDecoration(AssetsConstants.accountIcon),
      hint: Text(
        'Select Account Type',
        style: GoogleFonts.plusJakartaSans(
          color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      icon: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: SvgPicture.asset(
          AssetsConstants.arrowDown,
        ),
      ),
      items: viewModel.accountTypes.map((String accountType) {
        return DropdownMenuItem<String>(
          value: accountType,
          child: Text(
            accountType,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        viewModel.setSelectedAccountType(newValue);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select account type';
        }
        return null;
      },
      style: const TextStyle(color: Color(0xFF18202F)),
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  InputDecoration _buildDropdownInputDecoration(String assetPath) {
    return InputDecoration(
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
        borderSide: const BorderSide(),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(38),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
      filled: true,
      fillColor: const Color(0xFFEFEFF3),
      border: InputBorder.none,
      prefixIcon: Padding(
        padding: const EdgeInsets.only(
            left: 14, right: 8.0), // Adjust padding here for space
        child: SizedBox(
          width: 20, // Specify the width to control icon size
          height: 20, // Specify the height to control icon size
          child: SvgPicture.asset(assetPath),
        ),
      ),
    );
  }

  Widget _buildAccountNumberField() {
    return TextFormField(
      controller: _accountNumberController,
      style: const TextStyle(color: Color(0xFF18202F)),
      decoration: _buildInputDecoration(
          "Enter account number", AssetsConstants.accountIcon),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter account number';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _buildBranchDropdown(AddBankAccountViewModel viewModel) {
    return DropdownButtonFormField<String>(
      value: viewModel.selectedBranch,
      decoration: _buildDropdownInputDecoration(AssetsConstants.buildingsIcon),
      hint: Text(
        'Select Branch',
        style: GoogleFonts.plusJakartaSans(
          color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      icon: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: SvgPicture.asset(
          AssetsConstants.arrowDown,
        ),
      ),
      items: viewModel.branchList.map((String branch) {
        return DropdownMenuItem<String>(
          value: branch,
          child: Text(
            branch,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        viewModel.setSelectedBranch(newValue);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select branch';
        }
        return null;
      },
      style: const TextStyle(color: Color(0xFF18202F)),
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _buildAttachBankButton(AddBankAccountViewModel viewModel) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFA365ED),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            viewModel.submitUserDetails(_lastNameController.text,
                _accountNumberController.text, _firstNameController.text);
            //user form details pass to viewmodel
            //submitUserAccountDetail this method add the details to repository viewmodel.submitUsrDetails()
          }
        },
        child: Text(
          'Attach Bank',
          style: GoogleFonts.plusJakartaSans(
            textStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showBottomSheetForConfirmation(BuildContext context) async {
    showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.white,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 5),
                SvgPicture.asset(
                  AssetsConstants.bottomSheetNotch,
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    const SizedBox(height: 40),
                    Center(
                      child: SvgPicture.asset(
                        AssetsConstants.creditCards,
                        height: 80,
                        width: 80,
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'New Account Added Successfully.',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "You've successfully created a new account\n and can start using it right away",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 64,
                    )
                  ],
                )
              ],
            ),
          );
        });
  }
}
