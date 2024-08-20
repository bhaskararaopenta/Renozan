import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget {
  final Widget? leadingIcon;
  final VoidCallback? onLeadingIconTap;
  final bool showLeading;
  final String title;
  final String? subtitle;
  final bool centerTitle;
  final bool showSubtitle;
  final bool centerTitleAndSubtitle;
  final IconData? subtitleIcon;
  final Widget? additionalIcon;
  final bool showAdditionalIcon;
  final List<Widget> actions;
  final bool showActions;

  const CustomAppBar({
    super.key,
    this.leadingIcon,
    this.onLeadingIconTap,
    this.showLeading = true,
    required this.title,
    this.subtitle,
    this.centerTitle = false,
    this.showSubtitle = true,
    this.centerTitleAndSubtitle = false,
    this.subtitleIcon,
    this.actions = const [],
    this.showActions = true,
    this.additionalIcon,
    this.showAdditionalIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      backgroundColor: Colors.transparent,
      title: _buildTitle(),
      leading: showLeading ? _buildLeading() : null,
      leadingWidth: leadingIcon != null ? 70 : null,
      actions: showActions && actions.isNotEmpty ? actions : null,
      centerTitle: centerTitleAndSubtitle ? true : centerTitle,
    );
  }

  Widget _buildTitle() {
    // Check if title is not empty or subtitle is present
    bool shouldShowAdditionalIcon = showAdditionalIcon &&
        additionalIcon != null &&
        (title.isNotEmpty || subtitle != null);

    if (showSubtitle && subtitle != null) {
      return Column(
        crossAxisAlignment: centerTitleAndSubtitle
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: centerTitleAndSubtitle
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              if (shouldShowAdditionalIcon) ...[
                additionalIcon!, // Render the widget here
                const SizedBox(width: 8),
              ],
              Column(
                crossAxisAlignment: centerTitleAndSubtitle
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: centerTitleAndSubtitle
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: [
                      if (subtitleIcon != null &&
                          !shouldShowAdditionalIcon) ...[
                        Icon(
                          subtitleIcon,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        subtitle!,
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    }

    // Show only the title with additionalIcon if applicable
    return Row(
      mainAxisAlignment:
          centerTitle ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        if (shouldShowAdditionalIcon) ...[
          additionalIcon!, // Render the widget here
          const SizedBox(width: 8),
        ],
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildLeading() {
    return GestureDetector(
      onTap: onLeadingIconTap,
      child: leadingIcon ??
          SvgPicture.asset(
            height: 50,
            width: 50,
            'path_to_default_image', // Update this path as needed
            fit: BoxFit.cover,
          ),
    );
  }
}
