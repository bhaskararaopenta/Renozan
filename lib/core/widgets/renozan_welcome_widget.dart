import 'package:app/core/constants/asset_constants.dart';
import 'package:app/features/signup/colors/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class RenozanWelcomeWidget extends StatefulWidget {
  final String buttonText1;
  final String buttonText2;
  final String route1;
  final String route2;

  const RenozanWelcomeWidget({
    super.key,
    required this.buttonText1,
    required this.buttonText2,
    required this.route1,
    required this.route2,
  });

  @override
  State<RenozanWelcomeWidget> createState() => _RenozanWelcomeWidgetState();
}

class _RenozanWelcomeWidgetState extends State<RenozanWelcomeWidget> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: AlignmentDirectional.topCenter,
            end: AlignmentDirectional.bottomCenter,
            colors: [
              Color(0xFFA365ED),
              Color(0xFF5D3A87),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: screenHeight * 0.6,
              child: _buildStack(screenWidth, screenHeight),
            ),
            const SizedBox(height: 20),
            _buildWelcomeText(),
            const SizedBox(height: 42),
            _buildButton(screenWidth, widget.buttonText1, widget.route1),
            const SizedBox(height: 8),
            _buildButton(screenWidth, widget.buttonText2, widget.route2),
          ],
        ),
      ),
    );
  }

  Widget _buildStack(double screenWidth, double screenHeight) {
    return Stack(
      children: <Widget>[
        _buildPositionedImage(
          top: screenHeight * 0.015,
          left: screenWidth * 0.035,
          width: screenWidth * 0.9,
          height: screenHeight * 0.25,
          useSvg: false,
          assetPath: AssetsConstants.welcomeBackground,
          fit: BoxFit.cover,
        ),
        _buildPositionedImage(
          top: screenHeight * 0.49,
          left: screenWidth * 0.04,
          width: screenWidth * 0.19,
          height: screenWidth * 0.19,
          useSvg: true,
          assetPath: AssetsConstants.welcomeStar,
          fit: BoxFit.cover,
        ),
        _buildPositionedImage(
          top: screenHeight * 0.10,
          left: -screenWidth * 0.215,
          width: screenWidth * 0.7,
          height: screenWidth * 0.9,
          useSvg: true,
          assetPath: AssetsConstants.verticalLine,
        ),
        _buildPositionedImage(
          top: screenHeight * 0.535,
          left: screenWidth * 0.25,
          width: screenWidth * 0.8,
          height: 1,
          useSvg: true,
          assetPath: AssetsConstants.horizontalLine,
          fit: BoxFit.fill,
        ),
        _buildPositionedImage(
          top: screenHeight * 0.05,
          left: screenWidth * 0.068,
          width: screenWidth * 0.936,
          height: screenHeight * 0.46,
          useSvg: true,
          assetPath: AssetsConstants.card_1,
          fit: BoxFit.fill,
        ),
        _buildPositionedImage(
          top: -screenHeight * 0.005,
          left: screenWidth * 0.2,
          width: screenWidth * 0.80,
          height: screenHeight * 0.45,
          useSvg: false,
          assetPath: AssetsConstants.card_2,
          fit: BoxFit.cover,
        ),
      ],
    );
  }

  Widget _buildPositionedImage({
    required double top,
    required double left,
    required double width,
    required double height,
    required String assetPath,
    required bool useSvg,
    BoxFit fit = BoxFit.none,
  }) {
    return Positioned(
      top: top,
      left: left,
      child: SizedBox(
        width: width,
        height: height,
        child: useSvg
            ? SvgPicture.asset(
                assetPath,
                fit: fit,
              )
            : Image.asset(
                assetPath,
                fit: fit,
              ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
          children: [
            TextSpan(
              text: "Welcome to\n",
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.whitecolor,
                fontSize: 38,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: "Renozan",
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.whitecolor,
                fontSize: 38,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(double screenWidth, String text, String route) {
    return Container(
      width: screenWidth,
      height: 48,
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        child: Text(
          text,
          style: GoogleFonts.plusJakartaSans(
            textStyle: const TextStyle(
              color: Color(0xFF5D3A87),
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
