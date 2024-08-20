import 'package:app/app_routes.dart';
import 'package:app/core/base_provider.dart';
import 'package:app/core/constants/asset_constants.dart';
import 'package:app/core/ui/body_below_app_bar_widget.dart';
import 'package:app/core/ui/custom_snackbars.dart';
import 'package:app/core/ui/empty_body_progress_indicator.dart';
import 'package:app/core/widgets/appbar_reusable_widget.dart';
import 'package:app/features/manage_money/choose_a_bank/choose_a_bank_view_model.dart';
import 'package:app/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChoosingBank extends StatefulWidget {
  const ChoosingBank({super.key});

  @override
  State<ChoosingBank> createState() => _ChoosingBankState();
}

class _ChoosingBankState extends State<ChoosingBank> {
  late ChooseBankViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<ChooseBankViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _viewModel..loadChooseBankScreen(),
      child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: _buildAppBar(),
          ),
          body: Consumer<ChooseBankViewModel>(
            builder: (context, viewModel, child) {
              switch (viewModel.state) {
                case ViewState.loading:
                  return const BodyBelowAppBarWidget(
                      child: EmptyBodyProgressIndicatorWidget());
                case ViewState.error:
                  showCustomSnackBar(context, viewModel.errorMessage);
                  return BodyBelowAppBarWidget(
                      child: _buildChooseBank(context, viewModel));
                case ViewState.done:
                  return BodyBelowAppBarWidget(
                      child: _buildChooseBank(context, viewModel));
                default:
                  return const Center(child: Text('Unknown state'));
              }
            },
          )),
    );
  }

  CustomAppBar _buildAppBar() {
    return CustomAppBar(
      title: "Choose A Bank",
      centerTitle: true,
      showLeading: true,
      leadingIcon: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: SvgPicture.asset(AssetsConstants.backIcon),
      ),
      additionalIcon: CircleAvatar(child: GestureDetector(child: SvgPicture.asset(AssetsConstants.backIcon))),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Image.asset(AssetsConstants.globePic),
        ),
      ],
    );
  }

  Widget _buildChooseBank(BuildContext context, ChooseBankViewModel viewModel) {
    return Container(
      color: const Color(0xFFFAFAFB),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16.0),
          _buildSearchBar(),
          const SizedBox(height: 15.0),
          _buildTitle(),
          const SizedBox(height: 15.0),
          _buildBankList(viewModel),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: const Color(0xFFEFEFF3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        "Please select your bank",
        style: TextStyle(
            color: Color(0xFF18202F),
            fontSize: 18,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildBankList(ChooseBankViewModel viewModel) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: viewModel.bankList?.length,
        itemBuilder: (context, index) {
          final bank = viewModel.bankList?[index];
          final bankName = bank?.name ?? 'Unknown Bank';
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Card(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: ListTile(
                  splashColor: Colors.grey.withOpacity(0.1),
                  contentPadding: const EdgeInsets.only(left: 2.0),
                  leading: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color(0xFFFAFAFB),
                    ),
                    width: 50,
                    height: MediaQuery.of(context).size.height,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset(
                        AssetsConstants.bankImage,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  title: Text(
                    bankName,
                    style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: const Color(0xFF18202F)),
                  ),
                  onTap: () {
                    print("Bank Name: $bankName");
                    viewModel.setBankDetails(bankName, index);
                    _showBottomSheetSelect(context, bankName, viewModel);
                    // Handle bank selection
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showBottomSheetSelect(
      BuildContext context, String bankName, ChooseBankViewModel viewModel) {
    showModalBottomSheet(
        context: context,
        builder: (context) => ChangeNotifierProvider.value(
            value: viewModel,
            child: Consumer<ChooseBankViewModel>(
              builder: (context, value, child) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(AssetsConstants.bottomSheetNotch,
                        height: 5),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Add beneficiary",
                        style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xFF18202F),
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Select your account type",
                          style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF9B9DA3),
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        )),
                    const SizedBox(height: 20),
                    _buildSelectType(
                        viewModel,
                        AssetsConstants.chooseBankPersonal,
                        "Personal",
                        AccountType.Personal),
                    const SizedBox(
                      height: 10,
                    ),
                    _buildSelectType(
                        viewModel,
                        AssetsConstants.chooseBankBusiness,
                        "Business",
                        AccountType.Business),
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
                          // viewModel.setBankName(bankName);
                          Navigator.pushNamed(
                            context,
                            AppRoutes.addBankAccount,
                          );
                        },
                        child: Text(
                          "Withdraw Securely",
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
            )));
  }

  _buildSelectType(ChooseBankViewModel viewModel, String imageAsset,
      String title, AccountType accountType) {
    return InkWell(
      customBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      onTap: () {
        viewModel.setAccountType(accountType);
        print("Role selected: $accountType");
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            contentPadding: const EdgeInsets.only(left: 1.0),
            leading: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color(0xFFFAFAFB),
              ),
              height: MediaQuery.of(context).size.height,
              width: 50,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(imageAsset),
              ),
            ),
            title: Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF18202F),
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
            trailing: Container(
              margin: const EdgeInsets.all(10),
              child: _buildcustomCheckBox(viewModel.accountType == accountType),
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
        color: selected ? Colors.purple : Colors.transparent,
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
}
