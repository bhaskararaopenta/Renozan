import 'package:app/app_routes.dart';
import 'package:app/app_view_model.dart';
import 'package:app/core/base_provider.dart';
import 'package:app/core/constants/asset_constants.dart';
import 'package:app/core/ui/body_below_app_bar_widget.dart';
import 'package:app/core/ui/custom_snackbars.dart';
import 'package:app/core/ui/empty_body_progress_indicator.dart';
import 'package:app/core/widgets/appbar_reusable_widget.dart';
import 'package:app/features/activity/activity_page.dart';
import 'package:app/features/credit/credit_page.dart';
import 'package:app/features/home/home_screen_view_model.dart';
import 'package:app/features/home/recentActivity_model.dart';
import 'package:app/features/inventory/inventory_screen.dart';
import 'package:app/features/manage_money/cash_in_out/cash_in_out_screen.dart';
import 'package:app/features/wallet/wallet_model.dart';
import 'package:app/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/ui/custom_image_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _handleTap(String title, BuildContext context) {
    var model = Provider.of<HomeScreenViewModel>(context, listen: false);
    model.handleTap(title, () {
      switch (title) {
        case "Inventory":
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const InventoryScreen()),
          );
          break;
        case "Activity":
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ActivityPage()),
          );
          break;
        case "Credit":
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreditPage()),
          );
          break;
        case "Cash In/Out":
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CashInOutPage()),
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<HomeScreenViewModel>()..loadHomeScreenData(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: _buildAppBar(),
        ),
        body: Consumer<HomeScreenViewModel>(
          builder: (context, model, child) {
            switch (model.getState) {
              case ViewState.init:
              case ViewState.loading:
                return const BodyBelowAppBarWidget(
                    child: EmptyBodyProgressIndicatorWidget());
              case ViewState.error:
                showCustomSnackBar(context, model.errorMessage);
                return BodyBelowAppBarWidget(
                    child: Container(color: Colors.white));
              case ViewState.done:
                return BodyBelowAppBarWidget(
                    child: _buildHomeScreenBody(context, model));
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
      title: "Hi there, Hilo",
      subtitle: "Kingston, Jamaican",
      subtitleIcon: Icons.location_on_sharp,
      showLeading: true,
      leadingIcon: CircleAvatar(
        child: GestureDetector(
          onTap: () {},
          child: Image.asset(AssetsConstants.proficeImage, fit: BoxFit.cover),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: CircleAvatar(
                  child: GestureDetector(
                    onTap: () {},
                    child: Image.asset(AssetsConstants.globePic),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  var appViewModel =
                      Provider.of<AppViewModel>(context, listen: false);
                  appViewModel.logoutUser();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.appWelcome,
                    (route) => false,
                  );
                },
                child: SvgPicture.asset(
                  AssetsConstants.notificationBell,
                  height: 43,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHomeScreenBody(BuildContext context, HomeScreenViewModel model) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 15),
              SizedBox(
                height: 210,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: _buildCardsGallery(context, model),
                ),
              ),
              _buildOperations(context),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            color: const Color(0xFFFAFAFB),
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 13.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Distributors",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: const Color(0xFF101828),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                _buildDistributorsRow(context, model),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.fromLTRB(8, 2, 2, 0),
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Text(
                              'Recent Activity',
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF101828),
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 5,
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    'View all',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: const Color(0xFFA365ED),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
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
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: transactionCard(context, model),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperations(BuildContext context) {
    return Consumer<HomeScreenViewModel>(builder: (context, model, child) {
      return Padding(
        padding: const EdgeInsets.all(15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color.fromARGB(255, 137, 85, 199),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                getColumnItem(
                  "Inventory",
                  AssetsConstants.inventory,
                  () => _handleTap("Inventory", context),
                  model.isTapped["Inventory"]!,
                ),
                getColumnItem(
                  "Activity",
                  AssetsConstants.activity,
                  () => _handleTap("Activity", context),
                  model.isTapped["Activity"]!,
                ),
                getColumnItem(
                  "Credit",
                  AssetsConstants.credit,
                  () => _handleTap("Credit", context),
                  model.isTapped["Credit"]!,
                ),
                getColumnItem(
                  "Cash In/Out",
                  AssetsConstants.cashInOut,
                  () => _handleTap("Cash In/Out", context),
                  model.isTapped["Cash In/Out"]!,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  // Widget transactionCard(BuildContext context,HomeScreenViewModel model) {
  Widget transactionCard(BuildContext context, HomeScreenViewModel model) {
    return Column(
      children: model.recentActivity.map((data) {
        return _buildTransactionItem(data);
      }).toList(),
    );
  }

  Widget _buildTransactionItem(RecentActivityData recentActivityData) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 2, 8, 3),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Colors.white.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: ListTile(
          title: Text(
            recentActivityData.text,
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF18202F),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            recentActivityData.date,
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF9B9DA3),
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
          leading: CircleAvatar(
            radius: 25.0,
            child: Image.asset(
              recentActivityData.image,
              fit: BoxFit.cover,
            ),
          ),
          trailing: Text(
            recentActivityData.amount,
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF19A941),
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDistributorsRow(
      BuildContext context, HomeScreenViewModel model) {
    // Ensure "All" is always included, even if there are less than 3 distributors.
    int itemCount =
        model.distributors.length >= 4 ? 5 : model.distributors.length + 1;

    List<Widget> distributorWidgets = List<Widget>.generate(
      itemCount,
      (index) {
        // For the last item or if distributors are less than 3, add "All".
        if (index == itemCount - 1) {
          return _buildDistributorRowEntry(
            context,
            assetImage: AssetsConstants.all,
            text: "All",
            onTap: () => Navigator.pushNamed(context, AppRoutes.distributor),
          );
        } else {
          return _buildDistributorRowEntry(
            context,
            imageUrl: model.distributors[index].logo,
            text: model.distributors[index].businessName,
            onTap: () => Navigator.pushNamed(context, AppRoutes.distributor),
          );
        }
      },
    );

    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: distributorWidgets),
        ),
      ),
    );
  }

  Widget _buildDistributorRowEntry(BuildContext context,
      {String? assetImage,
      String? imageUrl,
      required String text,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: SizedBox(
          width: 60,
          height: 82,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              assetImage != null
                  ? CustomImageWidget(
                      assetImage: assetImage,
                      isCircular: true,
                      radius: 30.0,
                      backgroundColor: Colors.grey[200],
                    )
                  : CustomImageWidget(
                      imageUrl: imageUrl,
                      isCircular: true,
                      radius: 30.0,
                      backgroundColor: Colors.grey[200],
                      name: text,
                    ),
              Text(
                text,
                maxLines: 1,
                textAlign:
                    TextAlign.center, // Align text in center horizontally
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: const Color(0xFF979797),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardsGallery(BuildContext context, HomeScreenViewModel model) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: model.walletInfoList.length,
      itemBuilder: (context, index) {
        WalletInfo data = model.walletInfoList[index];
        return _buildCardItem(data, context);
      },
    );
  }

  Widget getColumnItem(
      String title, String asset, VoidCallback onTap, bool isTapped) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: 30.0,
            backgroundColor: isTapped
                ? Colors.white
                : const Color.fromRGBO(255, 255, 255, 0.1),
            child: SvgPicture.asset(
              asset,
              color: isTapped ? const Color(0xFFA365ED) : null,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardItem(WalletInfo walletInfo, BuildContext context) {
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
                        Text("Renozan Balance",
                            style: GoogleFonts.plusJakartaSans(
                                color: Colors.white, fontSize: 15)),
                        Text(
                          walletInfo.balance.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 30),
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
                    Text("CARD NUMBER",
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontSize: 12)),
                    Text(walletInfo.cardNumber,
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontSize: 15)),
                    Text(walletInfo.expiryDate,
                        style: GoogleFonts.plusJakartaSans(
                            color: Colors.white, fontSize: 12)),
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
