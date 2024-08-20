import 'package:app/app_routes.dart';
import 'package:app/core/base_provider.dart';
import 'package:app/core/constants/asset_constants.dart';
import 'package:app/core/ui/body_below_app_bar_widget.dart';
import 'package:app/core/ui/custom_image_widget.dart';
import 'package:app/core/ui/custom_snackbars.dart';
import 'package:app/core/ui/empty_body_progress_indicator.dart';
import 'package:app/core/widgets/appbar_reusable_widget.dart';
import 'package:app/features/product_service/category.dart';
import 'package:app/features/shop_flow/distributors/distributor_view_model.dart';
import 'package:app/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../product_service/business_connection_models.dart';

class DistributorScreen extends StatefulWidget {
  const DistributorScreen({super.key});

  @override
  State<DistributorScreen> createState() => _DistributorScreenState();
}

class _DistributorScreenState extends State<DistributorScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<DistributorViewModel>()..loadDistributorScreen(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: _buildAppBar(),
        ),
        body: Consumer<DistributorViewModel>(
          builder: (context, model, child) {
            log.d('viewState: ${model.getState}');
            log.d('ErrorMessage: ${model.getErrorMessage}');
            log.d('distributorsDetails length: ${model.distributors.length}');

            switch (model.getState) {
              case ViewState.init:
              case ViewState.loading:
                return const BodyBelowAppBarWidget(
                    child: EmptyBodyProgressIndicatorWidget());
              case ViewState.error:
                showCustomSnackBar(context, model.errorMessage);
                return BodyBelowAppBarWidget(
                    child: _buildDistributorBody(context, model));
              case ViewState.done:
                return BodyBelowAppBarWidget(
                    child: _buildDistributorBody(context, model));
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
      title: "Distributor",
      showLeading: true,
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
          icon: SvgPicture.asset(AssetsConstants.appbarHouse),
        ),
        IconButton(
          onPressed: () {},
          icon: Image.asset(AssetsConstants.globePic),
        ),
      ],
    );
  }


  Widget _buildDistributorBody(
      BuildContext context, DistributorViewModel viewModel) {
    return Container(
      color: const Color(0xFFFAFAFB),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            _buildSearchBar(),
            const SizedBox(height: 15.0),
            _buildTitle(),
            const SizedBox(height: 15.0),
            _buildDistributorsList(viewModel),
          ],
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

  Widget _buildTitle() {
    return const Text(
      "You are connected with the following distributors",
      style: TextStyle(
          color: Color(0xFF9B9DA3), fontSize: 15, fontWeight: FontWeight.w400),
    );
  }

  Widget _buildDistributorsList(DistributorViewModel viewModel) {
    return Expanded(
      child: GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemCount: viewModel.distributors.length,
          itemBuilder: (context, index) {
            BusinessConnection data = viewModel.distributors[index];
            return _distributorItem(data, viewModel);
          }),
    );
  }

  Widget _distributorItem(
      BusinessConnection distributorsData, DistributorViewModel viewModel) {
    bool isSelected = viewModel.isSelected &&
        viewModel.selectedDistributor == distributorsData;
    return InkWell(
      onTap: () {
        viewModel.selectDistributor(distributorsData);
        viewModel
            .setBottomSheetOpenState(true); // Set bottom sheet state to open
        showBottomSheetForBrands(context, viewModel);
      },
      child: Card(
        color: isSelected ? const Color(0xFFE4D2F9) : Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: Colors.white,
              width: 2,
            )),
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:
                          isSelected ? Colors.white : const Color(0xFFFAFAFB),
                    ),
                    child: CustomImageWidget(
                      height: 60,
                      width: 60,
                      imageUrl: distributorsData.logo,
                      name: distributorsData.businessName,
                    ),
                  )),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  distributorsData.businessName,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showBottomSheetForBrands(
      BuildContext context, DistributorViewModel viewModel) async {
    await showModalBottomSheet<void>(
        context: context,
        backgroundColor: const Color(0xFFFAFAFB),
        builder: (BuildContext context) {
          return ChangeNotifierProvider.value(
            value: viewModel,
            child: Builder(
              builder: (BuildContext context) {
                final viewModel =
                    Provider.of<DistributorViewModel>(context, listen: true);
                final selectedDistributor = viewModel.selectedDistributor;
                final brands = viewModel.selectedDistributorBrands;
                final filtersData = viewModel.filtersData;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(height: 16),
                      InkWell(
                        customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        onTap: () {},
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              )),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                            child: SizedBox(
                              height: 88,
                              child: Row(
                                children: [
                                  // contentPadding:
                                  //     const EdgeInsets.only(left: 1.0),
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: const Color(0xFFFAFAFB),
                                      ),
                                      //height: MediaQuery.of(context).size.height,
                                      child: CustomImageWidget(
                                          name:
                                              selectedDistributor.businessName,
                                          height: 60,
                                          width: 60,
                                          imageUrl: selectedDistributor.logo)),
                                  Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          selectedDistributor.businessName,
                                          style: GoogleFonts.plusJakartaSans(
                                              color: const Color(0xFF18202F),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(selectedDistributor.accountCode),
                                      ],
                                    ),
                                  ),
                                  const Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Text(
                                        textAlign: TextAlign.right,
                                        "N/A",
                                        style: TextStyle(fontSize: 25),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildFiltersButtons(filtersData, viewModel),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: GridView.builder(
                            scrollDirection: Axis.vertical,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            itemCount: brands.length,
                            itemBuilder: (context, index) {
                              final brand = brands[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, AppRoutes.products,
                                      arguments: {
                                        'brandId': brand.id,
                                        'brandName': brand.name,
                                      });
                                },
                                child: Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 8,
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: const Color(0xFFFAFAFB),
                                            ),
                                            child: CustomImageWidget(
                                                height: 60,
                                                width: 60,
                                                imageUrl: brand.image,
                                                name: brand.name),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 0, 5, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                brand.name.length > 10
                                                    ? '${brand.name.substring(0, 6)}...'
                                                    : brand.name,
                                              ),
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                      AssetsConstants
                                                          .inventoryBoxIcon),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  const Text("25"),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }).whenComplete(() {
      viewModel.setBottomSheetOpenState(false);
      viewModel.resetSelectedState();
      print('Bottom sheet closed');
    });
  }

  Widget _buildFiltersButtons(
      List<Category> filtersData, DistributorViewModel viewModel) {
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
}
