import 'package:app/core/base_provider.dart';
import 'package:app/core/constants/asset_constants.dart';
import 'package:app/core/ui/body_below_app_bar_widget.dart';
import 'package:app/core/ui/custom_snackbars.dart';
import 'package:app/core/ui/empty_body_progress_indicator.dart';
import 'package:app/core/widgets/appbar_reusable_widget.dart';
import 'package:app/features/product_service/brand.dart';
import 'package:app/features/product_service/category.dart';
import 'package:app/features/product_service/product.dart';
import 'package:app/features/shop_flow/payments/payments_screen.dart';
import 'package:app/features/shop_flow/payments/payments_view_model.dart';
import 'package:app/features/shop_flow/products/data/product_sale_order_request.dart';
import 'package:app/features/shop_flow/products/products_view_model.dart';
import 'package:app/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatefulWidget {
  final int brandId;
  final String brandName;
  const ProductsScreen(
      {super.key, required this.brandId, required this.brandName});
  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    final brandId = widget.brandId;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => getIt<BrandProductsViewModel>()
            ..fetchBrandDetailsAndProducts(brandId),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<PaymentsViewModel>(),
        ),
      ],
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: _buildAppBar(),
        ),
        body: Consumer<BrandProductsViewModel>(
          builder: (context, model, child) {
            log.d('viewState: ${model.getState}');
            log.d('ErrorMessage: ${model.getErrorMessage}');

            switch (model.getState) {
              case ViewState.init:
              case ViewState.loading:
                return const BodyBelowAppBarWidget(
                    child: EmptyBodyProgressIndicatorWidget());
              case ViewState.error:
                showCustomSnackBar(context, model.errorMessage);
                return BodyBelowAppBarWidget(
                    child: _buildProductsBody(context, model));
              case ViewState.done:
                return BodyBelowAppBarWidget(
                    child: _buildProductsBody(context, model));
              default:
                return const Center(child: Text('Unknown state'));
            }
          },
        ),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  CustomAppBar _buildAppBar() {
    return CustomAppBar(
      title: widget.brandName, // Dynamic title from the previous page
      showLeading: true,
      centerTitle: true,
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

  Widget _buildProductsBody(
      BuildContext context, BrandProductsViewModel viewModel) {
    final brand = viewModel.brand;
    final filtersData = viewModel.filtersData;
    return SingleChildScrollView(
      child: Container(
        color: Color(0xFFFAFAFB),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5.0),
              _buildSelectedBrand(brand),
              const SizedBox(height: 15.0),
              _buildBrandTile(brand),
              const SizedBox(height: 15.0),
              _buildSearchBar(),
              const SizedBox(height: 15.0),
              _buildFilters(filtersData, viewModel),
              const SizedBox(height: 15.0),
              _buildProductsList(viewModel),
              const SizedBox(height: 15.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedBrand(Brand brand) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        border: Border.all(color: Colors.white),
      ),
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(0, 60, 0, 60),
      child: Center(child: Image.asset(brand.image)),
    );
  }

  Widget _buildBrandTile(Brand brand) {
    return InkWell(
      customBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      onTap: () {},
      child: Card(
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
              child: Image.asset(
                brand.image,
                fit: BoxFit.contain,
              ),
            ),
            title: Text(
              brand.name,
              style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF18202F),
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
            subtitle: const Text("Inventoried items"),
            trailing: const Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Text(
                '40',
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
        ),
      ),
    );
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

  Widget _buildFilters(
      List<Category> filtersData, BrandProductsViewModel viewModel) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filtersData.map((category) {
          final bool isSelected = viewModel.selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: ElevatedButton(
              onPressed: () {
                viewModel.selectCategory(category);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isSelected ? const Color(0xFFA365ED) : Colors.white,
              ),
              child: Text(
                category.name,
                style: GoogleFonts.plusJakartaSans(
                    color: isSelected ? Colors.white : const Color(0xFF9B9DA3),
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  _buildProductsList(BrandProductsViewModel viewModel) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: viewModel.products.length,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) {
        Product data = viewModel.products[index];
        return _buildProductCard(data, viewModel);
      },
    );
  }

  Widget _buildProductCard(Product product, BrandProductsViewModel viewModel) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: Colors.white,
            width: 2,
          )),
      child: Column(
        children: [
          Expanded(
            flex: 7,
            child: InkWell(
              onTap: () {
                viewModel.selectProduct(product);
                showBottomSheetOfProduct(context, viewModel);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFFAFAFB),
                  image: DecorationImage(
                    image: AssetImage(
                        product.image), // Replace with your actual image path
                    fit: BoxFit.contain,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset(
                                  AssetsConstants.inventoryBoxIcon),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text("20"),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product.title.length > 10
                          ? '${product.title.substring(0, 8)}...'
                          : product.title,
                    ),
                    Text(
                      '\$${product.price.toString()}',
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFFFAFAFB)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            viewModel.decrementQuantity(product);
                            log.d("sub button clicked");
                          },
                          child: SvgPicture.asset(
                            AssetsConstants.minusButton,
                            height: 20,
                          ),
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Text('${viewModel.getQuantity(product)}'),
                        const SizedBox(
                          width: 3,
                        ),
                        InkWell(
                          onTap: () {
                            viewModel.incrementQuantity(product);
                            log.d("add button clicked");
                          },
                          child: SvgPicture.asset(
                            AssetsConstants.addButton,
                            height: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Consumer<BrandProductsViewModel>(
      builder: (context, brandViewModel, child) => Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(56)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BottomAppBar(
            color: Colors.white,
            shape: const CircularNotchedRectangle(),
            notchMargin: 8.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${brandViewModel.totalItems} Products',
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF18202F),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Total",
                          style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF9B9DA3)),
                        ),
                        Text(
                            '\$${brandViewModel.totalAmount.toStringAsFixed(2)}',
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFA365ED))),
                      ],
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        brandViewModel.createSaleOrderRequest();
                        final saleOrderRequest =
                            brandViewModel.getSaleOrderRequest();
                        _showBottomSheetCartItems(
                          context,
                          saleOrderRequest!,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA365ED),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Text(
                        'Pay',
                        style: GoogleFonts.plusJakartaSans(
                            color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showBottomSheetOfProduct(
      BuildContext context, BrandProductsViewModel viewModel) async {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        builder: (BuildContext context) {
          final selectedProduct = viewModel.selectedProduct;

          return Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: SvgPicture.asset(
                        AssetsConstants.bottomSheetNotch,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0xFFFAFAFB),
                      ),
                      padding: const EdgeInsets.fromLTRB(0, 60, 0, 60),
                      width: double.infinity,
                      child: Center(child: Image.asset(selectedProduct.image)),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      selectedProduct.title,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      selectedProduct.description,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: const Color(0xFFF1E8FC),
                      ),
                      width: double.infinity,
                      child: Text(
                        "Minimum Order  :  10 items",
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.purple,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: Colors.black),
                          color: Colors.white70),
                      width: double.infinity,
                      child: Text(
                        "Code  :  483859553264",
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  void _showBottomSheetCartItems(
      BuildContext context, SaleOrderRequestForProducts saleOrderRequest) {
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
                  SvgPicture.asset(
                    'assets/images/bottom_sheet_notch.svg',
                    height: 5,
                  ),
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
                                entry.key.image,
                                entry.key.title,
                                //entry.key.categoryId,
                                "fix this",
                                entry.value,
                                entry.key.price,
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 15),
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
                      // Here you can add any additional action if needed
                      PaymentsBottomSheets().showBottomSheetPaymentOptions(
                          context, paymentsViewModel);
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
            height: 50,
            width: 50,
            child: Image.asset(productImage),
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

  Widget _buildSummary(SaleOrderRequestForProducts saleOrderRequest) {
    final subtotal = saleOrderRequest.getSubTotal();
    final tax = saleOrderRequest.getTax();
    final adminFee = saleOrderRequest.getAdminFee();
    final discount = saleOrderRequest.getDiscount();
    final total = saleOrderRequest.getTotal();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E1E2)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            _buildSummaryRow("Subtotal", "\$${subtotal.toStringAsFixed(2)}"),
            const SizedBox(height: 5),
            _buildSummaryRow("Tax (10%)", "\$${tax.toStringAsFixed(2)}"),
            const SizedBox(height: 5),
            _buildSummaryRow("Admin Fee", "\$${adminFee.toStringAsFixed(2)}"),
            const SizedBox(height: 5),
            _buildSummaryRow("Discount", "-\$${discount.toStringAsFixed(2)}"),
            const SizedBox(height: 10),
            _dashedLine(),
            const SizedBox(height: 5),
            _buildSummaryRow("Total", "\$${total.toStringAsFixed(2)}"),
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
