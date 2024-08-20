import 'package:app/services/service_locator.dart';
import 'package:app/template/simple_page/simple_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SimplePageView extends StatelessWidget {
  const SimplePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SimplePageViewModel>(
      create: (_) => getIt<SimplePageViewModel>(),
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Simple Page'),
          ),
          body: Center(
            child: Consumer<SimplePageViewModel>(
              builder: (context, viewModel, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'You have pushed the button this many times:',
                    ),
                    Text(
                      '${viewModel.counter}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => context.read<SimplePageViewModel>().incrementCounter(),
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}