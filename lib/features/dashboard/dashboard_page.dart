import 'package:app/app_routes.dart';
import 'package:app/core/colors/app_colors.dart';
import 'package:app/core/constants/asset_constants.dart';
import 'package:app/features/dashboard/navbar_pages/more_page.dart';
import 'package:app/features/dashboard/navbar_pages/payment_page.dart';
import 'package:app/features/dashboard/navbar_pages/scan_page.dart';
import 'package:app/features/dashboard/navbar_pages/statistic_page.dart';
import 'package:app/features/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  static const List<Widget> _screens = <Widget>[
    HomeScreen(),
    StatisticPage(),
    ScanPage(),
    PaymentPage(),
    MorePage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 251, 251, 254),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.scanCode);
        },
        child: SvgPicture.asset(AssetsConstants.scanLogo),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 235, 235, 249),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(10),
            ),
          ),
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildNavItem(
                icon: AssetsConstants.homeLogo,
                label: 'Home',
                index: 0,
              ),
              _buildNavItem(
                icon: AssetsConstants.statisticLogo,
                label: 'Statistic',
                index: 1,
              ),
              const SizedBox(width: 40), // Space for the FAB
              _buildNavItem(
                icon: AssetsConstants.paymentLogo, // Corrected icon for Payment
                label: 'Payment',
                index: 3,
              ),
              _buildNavItem(
                icon: AssetsConstants.moreLogo,
                label: 'More',
                index: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      {required String icon, required String label, required int index}) {
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            color: _currentIndex == index
                ? AppColors.navSelectedColor
                : AppColors.navDisableColor,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: _currentIndex == index
                  ? AppColors.navSelectedColor
                  : AppColors.navDisableColor,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
