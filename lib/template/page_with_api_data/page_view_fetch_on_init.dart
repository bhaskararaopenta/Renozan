import 'package:app/core/base_provider.dart';
import 'package:app/services/service_locator.dart';
import 'package:app/template/page_with_api_data/page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageWithFetchDataOnInit extends StatelessWidget {
  const PageWithFetchDataOnInit({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<ProductsViewModel>()..fetchProducts(),
      child: Scaffold(
        body: Consumer<ProductsViewModel>(
          builder: (context, viewModel, child) {
            switch (viewModel.getState) {
              case ViewState.loading:
                return const Center(child: CircularProgressIndicator());
              case ViewState.done:
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: viewModel.products.length,
                    itemBuilder: (context, index) {
                      var product = viewModel.products[index];
                      return Card(
                        child: ListTile(
                          title: Text(product.title),
                          subtitle: Text(product.description),
                          trailing: Text('\$${product.price}'),
                          onTap: () {},
                        ),
                      );
                    },
                  ),
                );
              case ViewState.error:
                return Center(child: Text(viewModel.getErrorMessage));
              default:
                return Container();
            }
          },
        ),
      ),
    );
  }
}



