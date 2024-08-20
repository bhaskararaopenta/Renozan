import 'package:app/app_routes.dart';
import 'package:app/core/base_provider.dart';
import 'package:app/core/constants/asset_constants.dart';
import 'package:app/core/ui/body_below_app_bar_widget.dart';
import 'package:app/core/ui/custom_snackbars.dart';
import 'package:app/core/ui/empty_body_progress_indicator.dart';
import 'package:app/core/widgets/appbar_reusable_widget.dart';
import 'package:app/features/wallet/wallet_model.dart';
import 'package:app/features/manage_money/cash_in_out/bank_account_model.dart';
import 'package:app/features/manage_money/cash_in_out/cash_in_out_view_model.dart';
import 'package:app/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CashInOutPage extends StatefulWidget {
  const CashInOutPage({super.key});

  @override
  State<CashInOutPage> createState() => _CashInOutPageState();
}

class _CashInOutPageState extends State<CashInOutPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController
        .addListener(_handleTabSelection); // Add listener for tab changes
  }

  void _handleTabSelection() {
    Provider.of<CashInOutViewModel>(context, listen: false).currentTabIndex =
        _tabController.index;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<CashInOutViewModel>()..loadCashInOutScreen(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: _buildAppBar(),
        ),
        body: Consumer<CashInOutViewModel>(
          builder: (context, model, child) {
            log.d('viewState: ${model.getState}');
            log.d('ErrorMessage: ${model.getErrorMessage}');
            log.d('CardDetails length: ${model.cardDetails.length}');
            log.d('BankDetails length: ${model.bankDetails.length}');

            switch (model.getState) {
              case ViewState.init:
              case ViewState.loading:
                return const BodyBelowAppBarWidget(
                    child: EmptyBodyProgressIndicatorWidget());
              case ViewState.error:
                showCustomSnackBar(context, model.errorMessage);
                return BodyBelowAppBarWidget(
                    child: _buildCashInOutBody(context, model));
              case ViewState.done:
                return BodyBelowAppBarWidget(
                    child: _buildCashInOutBody(context, model));
              default:
                return const Center(child: Text('Unknown state'));
            }
          },
        ),
      ),
    );
  }

  CustomAppBar _buildAppBar() {
    return CustomAppBar(
      title: "Cash In/Out", // or "Choose A Bank", or "Add Bank Account"
      showLeading: true,
      centerTitle: true,
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

  Widget _buildCashInOutBody(BuildContext context, CashInOutViewModel model) {
    return Container(
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(height: 20),
              SizedBox(
                height: 210,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: _buildCardsGallery(context, model),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFF482670),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            model.currentTabIndex = 0;
                            _tabController.animateTo(0);
                          },
                          child: Container(
                            height: double.infinity,
                            width: double.infinity, // Take up the full width
                            decoration: BoxDecoration(
                              color: model.currentTabIndex == 0
                                  ? Colors.white
                                  : Color(0xFF482670),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  AssetsConstants.cashOut,
                                  color: model.currentTabIndex == 0
                                      ? Color(0xFF482670)
                                      : Colors.white,
                                ),
                                // Image(
                                //   image: AssetImage(AssetsConstants.cashOut),
                                //   color: model.currentTabIndex == 0
                                //       ? Color(0xFF482670)
                                //       : Colors.white, // Change image color
                                //   filterQuality: FilterQuality.high,
                                // ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  "Cash Out",
                                  style: TextStyle(
                                    color: model.currentTabIndex == 0
                                        ? Color(0xFF482670)
                                        : Colors.white, // Change text color
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            model.currentTabIndex = 1;
                            _tabController.animateTo(1);
                          },
                          child: Container(
                            height: double.infinity,
                            width: double.infinity, // Take up the full width
                            decoration: BoxDecoration(
                              color: model.currentTabIndex == 1
                                  ? Colors.white
                                  : Color(0xFF482670),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  AssetsConstants.addCash,
                                  color: model.currentTabIndex == 1
                                      ? Color(0xFF482670)
                                      : Colors.white,
                                ),
                                // Image(
                                //   image: AssetImage(AssetsConstants.addCash),
                                //   color: model.currentTabIndex == 1
                                //       ? Color(0xFF482670)
                                //       : Colors.white, // Change image color
                                //   filterQuality: FilterQuality.high,
                                // ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  "Add Cash",
                                  style: TextStyle(
                                    color: model.currentTabIndex == 1
                                        ? Color(0xFF482670)
                                        : Colors.white, // Change text color
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                _buildTab1Content(context, model),
                _buildTab2Content(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab1Content(BuildContext context, CashInOutViewModel model) {
    // Check if the bank details list is empty or contains empty data
    if (model.bankDetails.isEmpty ||
        model.bankDetails.every((bank) =>
            bank.image.isEmpty &&
            bank.bank.isEmpty &&
            bank.accountNumber.isEmpty)) {
      return _buildTab1Content1();
    } else {
      return _buildTab1Content2(context, model);
    }
  }

  Widget _buildTab1Content2(BuildContext context, CashInOutViewModel model) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xFFEFEFF3),
                ),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Enter Amount"),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(),
                      SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text("select bank"),
                    _buildBankItems(context, model),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFA365ED),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(65)),
                    ),
                  ),
                  onPressed: () {},
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
      ),
    );
  }

  Widget _buildTab1Content1() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Banks",
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Color(0xFF18202F),
                    ),
                  ),
                  Text(
                    "you have connected the following accounts:",
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF9B9DA3),
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: SvgPicture.asset(AssetsConstants.bank),
                            ),
                            Text(
                              "you dont have bank account yet,please",
                              style: GoogleFonts.plusJakartaSans(
                                color: Color(0xFF9B9DA3),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              "add one first",
                              style: GoogleFonts.plusJakartaSans(
                                color: Color(0xFF9B9DA3),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFA365ED),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(65)),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.chooseBank);
                },
                child: Text(
                  "Add New Account",
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
    );
  }

  Widget _buildTab2Content() {
    return Container(
      child: Center(
        child: Text(
          'Tab 2 Content',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildCardsGallery(BuildContext context, CashInOutViewModel model) {
    if (model.getState == ViewState.loading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: model.cardDetails.length,
        itemBuilder: (context, index) {
          WalletInfo data = model.cardDetails[index];
          return _buildCardItem(data, context);
        },
      );
    }
  }

  Widget _buildBankItems(BuildContext context, CashInOutViewModel model) {
    return Column(
      children: model.bankDetails.map((data) {
        return _buildBankItem(data);
      }).toList(),
    );
  }

  Widget _buildBankItem(BankDetailsData data) {
    return Card(
      child: ListTile(
        title: Text(data.bank),
        leading: Image.asset(
          data.image,
          height: 30,
        ),
        subtitle: Text(
          data.accountNumber,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        trailing: Icon(Icons.edit),
        onTap: () {},
      ),
    );
  }

  Widget _buildCardItem(WalletInfo cardData, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
            image: AssetImage(AssetsConstants.cardBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Renozan Balance",
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          cardData.balance.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                    Image.asset(AssetsConstants.key),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "CARD NUMBER",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      cardData.cardNumber,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      cardData.expiryDate,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
