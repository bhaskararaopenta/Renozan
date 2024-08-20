import 'package:flutter/material.dart';

class EmptyBodyProgressIndicatorWidget extends StatelessWidget {
  const EmptyBodyProgressIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: const Center(child: CircularProgressIndicator()));
  }
}
