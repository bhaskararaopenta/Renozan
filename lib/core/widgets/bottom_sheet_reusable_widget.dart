import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ReUsableBottomSheet extends StatefulWidget {
  final String svgAssetPath;
  final String imageAssetPath;
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onConfirm;
  final Color buttonColor;

  const ReUsableBottomSheet({
    Key? key,
    required this.svgAssetPath,
    required this.imageAssetPath,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onConfirm,
    this.buttonColor = Colors.purple,
  }) : super(key: key);

  @override
  _ReUsableBottomSheetState createState() => _ReUsableBottomSheetState();
}

class _ReUsableBottomSheetState extends State<ReUsableBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SvgPicture.asset(widget.svgAssetPath),
          const SizedBox(height: 40),
          Center(
            child: SvgPicture.asset(
              widget.imageAssetPath,
              height: 80,
              width: 80,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.buttonColor,
              ),
              onPressed: widget.onConfirm,
              child: Text(
                widget.buttonText,
                style: GoogleFonts.plusJakartaSans(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
