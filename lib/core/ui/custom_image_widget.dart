import 'dart:math';

import 'package:app/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomImageWidget extends StatelessWidget {
  final String? imageUrl;
  final String? assetImage; // Local asset image path
  final bool isSvg; // Boolean to check if the assetImage is an SVG
  final String? name; // Name for generating placeholder initial
  final IconData
      placeholderIcon; // Material Icon for default placeholder (if no name)
  final double? width;
  final double? height;
  final double? radius; // For circular avatars
  final BoxFit fit;
  final bool isCircular; // Controls if the widget should be circular
  final Color? backgroundColor; // Optional background color for the container

  const CustomImageWidget({
    super.key,
    this.imageUrl,
    this.assetImage, // Local asset image
    this.isSvg = true, // By default, we assume the asset is SVG
    this.name,
    this.placeholderIcon = Icons.image, // Default placeholder icon
    this.width,
    this.height,
    this.radius, // Optional radius for circular avatars
    this.fit = BoxFit.cover, // Default BoxFit is cover
    this.isCircular = false, // Controls circular or rectangular shape
    this.backgroundColor, // Optional background color (no default)
  });

  @override
  Widget build(BuildContext context) {
    if (isCircular && radius != null) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? Colors.grey[200],
        child: _buildImageContent(),
      );
    } else {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.grey[200],
          shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
        ),
        child: _buildImageContent(),
      );
    }
  }

  Widget _buildImageContent() {
    try {
      if (imageUrl != null && imageUrl!.isNotEmpty) {
        return Image.network(
          imageUrl!,
          width: width,
          height: height,
          fit: fit,
        );
      } else if (assetImage != null && assetImage!.isNotEmpty) {
        return isSvg
            ? SvgPicture.asset(
                assetImage!,
                width: width,
                height: height,
                fit: fit,
              )
            : Image.asset(
                assetImage!,
                width: width,
                height: height,
                fit: fit,
              );
      } else if (name != null && name!.isNotEmpty) {
        return _buildInitialPlaceholder();
      } else {
        return Icon(placeholderIcon,
            size: (width ?? height ?? radius ?? 50.0) * 0.8);
      }
    } catch (e) {
      log.e('Error loading image: $e');
      if (imageUrl != null) {
        log.e('Error loading imageUrl: $imageUrl');
      } else if (assetImage != null) {
        log.e('Error loading assetImage: $assetImage');
      }

      return _buildInitialPlaceholder();
    }
  }

  // Build the placeholder using the first letter of the name with random background color
  Widget _buildInitialPlaceholder() {
    final String initial = name != null && name!.isNotEmpty
        ? name![0].toUpperCase()
        : ''; // Get the first letter of the name or fallback

    return Container(
      alignment: Alignment.center,
      child: Text(
        initial,
        style: TextStyle(
          fontSize: (width ?? height ?? radius ?? 50) *
              0.8, // Scale font size based on widget size
          color: const Color(0xFFA365ED),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Generate a random color for the background
  Color _generateRandomColor({double opacity = 1.0}) {
    final Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256), // Red component
      random.nextInt(256), // Green component
      random.nextInt(256), // Blue component
      opacity, // Opacity component
    );
  }
}
