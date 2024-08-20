import 'package:app/core/base_provider.dart';
import 'package:app/core/constants/asset_constants.dart';
import 'package:app/core/ui/body_below_app_bar_widget.dart';
import 'package:app/core/ui/custom_snackbars.dart';
import 'package:app/core/ui/empty_body_progress_indicator.dart';
import 'package:app/core/widgets/appbar_reusable_widget.dart';
import 'package:app/features/inventory/data/retailer_inventory_models.dart';
import 'package:app/features/inventory/data/sale_order_request_model.dart';
import 'package:app/features/inventory/inventory_view_model.dart';
import 'package:app/features/shop_flow/payments/payments_screen.dart';
import 'package:app/features/shop_flow/payments/payments_view_model.dart';
import 'package:app/features/signup/colors/AppColors.dart';
import 'package:app/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              getIt<InventoryViewModel>()..loadInventoryItems(),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<PaymentsViewModel>(),
        ),
      ],
      // return ChangeNotifierProvider(
      //   create: (context) => getIt<InventoryViewModel>()..loadInventoryItems(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: _buildAppBar(context),
        ),
        body: Consumer<InventoryViewModel>(
          builder: (context, viewModel, child) {
            switch (viewModel.state) {
              case ViewState.init:
              case ViewState.done:
                return BodyBelowAppBarWidget(
                    child: _buildBody(context, viewModel));
              case ViewState.loading:
                return const BodyBelowAppBarWidget(
                    child: EmptyBodyProgressIndicatorWidget());
              case ViewState.error:
                showCustomSnackBar(context, viewModel.errorMessage);
                return BodyBelowAppBarWidget(
                    child: _buildBody(context, viewModel));
              default:
                return const Center(
                  child: Text("Unexpected state"),
                );
            }
          },
        ),
      ),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: "Inventory",
      subtitle: "Hilo",
      showLeading: true,
      centerTitleAndSubtitle: true,
      additionalIcon: CircleAvatar(
          child: GestureDetector(
              child: Image.asset(
        AssetsConstants.proficeImage,
      ))),
      onLeadingIconTap: () {
        Navigator.pop(context);
      },
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

  Widget _buildBody(BuildContext context, InventoryViewModel viewModel) {
    return Container(
      color: const Color(0xFFFAFAFB),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            _buildSearchBar(),
            const SizedBox(height: 16.0),
            _buildHeader(),
            const SizedBox(height: 16.0),
            _buildCardsRow(viewModel),
            const SizedBox(height: 16.0),
            Expanded(
              child: Center(child: _buildItemsList(context, viewModel)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardsRow(InventoryViewModel viewModel) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: viewModel.selectCard1,
            child: _buildCard(
              viewModel.isCard1Selected,
              "Items",
              viewModel.allInventoryItemsCount().toString(),
              AssetsConstants.boxInventory,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: viewModel.selectCard2,
            child: _buildCard(
              !viewModel.isCard1Selected,
              "Top up\n low stock",
              viewModel.getLowStockCount().toString(),
              AssetsConstants.moneyBag,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard(bool isSelected, String title, String count, String asset) {
    return Card(
      color: isSelected ? const Color(0xFFE4D2F9) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: isSelected
                  ? const Color(0xFFC8A4F4)
                  : const Color(0xFFF7F7F9),
              child: SvgPicture.asset(asset),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  count,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsList(BuildContext context, InventoryViewModel viewModel) {
    return Stack(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Items",
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (!viewModel.isCard1Selected)
                  TextButton(
                    onPressed: viewModel.refillAllLowStock,
                    child: Text(
                      "Refill All",
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: viewModel.currentListItems().length,
                itemBuilder: (context, index) {
                  RetailerInventory inventoryItem =
                      viewModel.currentListItems()[index];
                  return _productTile(context, inventoryItem, viewModel);
                },
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              onPressed: () {
                viewModel.createSaleOrderRequest();
                _showBottomSheetCartItems(
                    context, viewModel.getSaleOrderRequest());
              },
              child: Text(
                viewModel.isCard1Selected ? 'View Cart' : 'Refill',
                style: GoogleFonts.plusJakartaSans(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _productTile(BuildContext context, RetailerInventory inventoryItem,
      InventoryViewModel viewModel) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: Color.fromARGB(255, 249, 248, 248),
            width: 1,
          )),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFF7F7F9),
              ),
              height: 80,
              width: 80,
              child: Image.network(
                inventoryItem.productVariants.variantImage,
                height: 62,
                width: 52,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    inventoryItem.productVariants.variantName,
                    maxLines: 2,
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    inventoryItem
                        .productVariants.distributorCode, //TBD:: change to name
                    maxLines: 2,
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "Stock  :",
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        inventoryItem.stock.toString(),
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 4),
                      if (inventoryItem.isLowOnStock())
                        Text(
                          '-${inventoryItem.getHowMuchLowOnStock().toString()}',
                          style: GoogleFonts.plusJakartaSans(
                            color: inventoryItem.isSuperLowOnStock()
                                ? Colors.red
                                : AppColors.primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
            _buildTrailingIcons(viewModel, inventoryItem),
          ],
        ),
      ),
    );
  }

  Widget _buildTrailingIcons(
      InventoryViewModel viewModel, RetailerInventory inventoryItem) {
    if (viewModel.isItemInCart(inventoryItem)) {
      return Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: SizedBox(
          width: 90,
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child:
                      SvgPicture.asset("assets/images/filled_minus_icon.svg"),
                  onTap: () {
                    viewModel.decrementItemQuantity(inventoryItem);
                  },
                ),
                Text(
                  '${viewModel.getQuantityOfItem(inventoryItem)}',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                InkWell(
                  child: SvgPicture.asset("assets/images/filled_add_icon.svg"),
                  onTap: () {
                    viewModel.incrementItemQuantity(inventoryItem);
                  },
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
          ),
          onPressed: () {
            viewModel.incrementItemQuantity(inventoryItem);
          },
          child: Text(
            "Add Stock",
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
    }
  }

  Widget _buildSearchBar() {
    return TextField(
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
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        SvgPicture.asset("assets/images/branching_paths_icon.svg"),
        const SizedBox(width: 8),
        Text(
          "Synced with Hilo POS system.",
          style: GoogleFonts.plusJakartaSans(
            color: Colors.purple,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  void _showBottomSheetCartItems(
      BuildContext context, SaleOrderRequest saleOrderRequest) {
    // Access the PaymentsViewModel once, outside the builder.
    final paymentsViewModel =
        Provider.of<PaymentsViewModel>(context, listen: false);

    showModalBottomSheet<void>(
      enableDrag: false,
      context: context,
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(15),
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 5),
                  SvgPicture.asset(AssetsConstants.bottomSheetNotch, height: 5),
                  const SizedBox(height: 5),
                  _buildTitle("Order Summary"),
                  const SizedBox(height: 5),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                            children: saleOrderRequest
                                .getCartItems()
                                .entries
                                .map((entry) {
                              return _buildCartItem(
                                context,
                                entry.key.productVariants.variantImage,
                                entry.key.productVariants.variantName,
                                entry.key.productVariants
                                    .distributorCode, //TBD:: change to name
                                entry.value,
                                entry.key.productVariants.sellPrice,
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 5),
                          _buildSummary(saleOrderRequest),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SizedBox(
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
                      Navigator.pop(context);
                      // Here, you can now call the payment options bottom sheet
                      PaymentsBottomSheets().showBottomSheetPaymentOptions(
                        context,
                        paymentsViewModel,
                      );
                    },
                    child: Text(
                      "Confirm Order",
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitle(String title) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF18202F),
        ),
      ),
    );
  }

  Widget _buildCartItem(
    BuildContext context,
    String productImage,
    String name,
    String distributorName,
    int quantity,
    double price,
  ) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 1.0),
          leading: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: const Color(0xFFFAFAFB),
            ),
            height: MediaQuery.of(context).size.height,
            child: SizedBox(
              height: 50,
              width: 50,
              child: Image.network(
                productImage,
              ),
            ),
          ),
          title: Text(
            name,
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF18202F),
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          subtitle: Text(distributorName),
          trailing: Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("${quantity}x"),
                Text("\$${(price * quantity).toStringAsFixed(2)}"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummary(SaleOrderRequest saleOrderRequest) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E1E2)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            _buildSummaryRow("Subtotal",
                "\$${saleOrderRequest.getSubTotal().toStringAsFixed(2)}"),
            const SizedBox(height: 5),
            _buildSummaryRow("Tax (10%)",
                "\$${saleOrderRequest.getTax().toStringAsFixed(2)}"),
            const SizedBox(height: 5),
            _buildSummaryRow("Admin Fee",
                "\$${saleOrderRequest.getAdminFee().toStringAsFixed(2)}"),
            const SizedBox(height: 5),
            _buildSummaryRow("Discount",
                "-\$${saleOrderRequest.getDiscount().toStringAsFixed(2)}"),
            const SizedBox(height: 10),
            _dashedLine(),
            const SizedBox(height: 5),
            _buildSummaryRow(
                "Total", "\$${saleOrderRequest.getTotal().toStringAsFixed(2)}"),
          ],
        ),
      ),
    );
  }

  Widget _dashedLine() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 5.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return const SizedBox(
              width: dashWidth,
              height: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.grey),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF9B9DA3),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFFA365ED),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
