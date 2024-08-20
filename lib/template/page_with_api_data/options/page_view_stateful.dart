import 'package:app/core/base_provider.dart';
import 'package:app/services/service_locator.dart';
import 'package:app/template/page_with_api_data/page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageAsStatefulWidget extends StatefulWidget {
  const PageAsStatefulWidget({super.key});

  @override
  PageAsStatefulWidgetState createState() => PageAsStatefulWidgetState();
}

class PageAsStatefulWidgetState extends State<PageAsStatefulWidget> {
  late ProductsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<ProductsViewModel>();
    _viewModel.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    //note the use .value() instead of .create()
    //since we already created view model in initState
    return ChangeNotifierProvider<ProductsViewModel>.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Products'),
        ),
        body: Consumer<ProductsViewModel>(
          builder: (context, viewModel, child) {
            switch (viewModel.getState) {
              case ViewState.loading:
                return const Center(child: CircularProgressIndicator());
              case ViewState.done:
                return ListView.builder(
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
