import 'package:app/core/constants/asset_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BodyBelowAppBarWidget extends StatelessWidget {
  final Widget child;
  const BodyBelowAppBarWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 435,
          width: double.infinity,
          child: SvgPicture.asset(
            AssetsConstants.appbarBackgroundd,
            fit: BoxFit.fitWidth,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 80),
          child: child,
        ),
      ],
    );
  }
}
