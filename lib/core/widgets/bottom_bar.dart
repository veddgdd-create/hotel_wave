import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotel_wave/core/utils/colors.dart';
import 'package:hotel_wave/features/profile/profile_view.dart';
import 'package:hotel_wave/features/traveler/cart/cart_view.dart';
import 'package:hotel_wave/features/traveler/home/view/favourite_view.dart';
import 'package:hotel_wave/features/traveler/home/view/home_screen.dart';

class NavBarWidget extends StatefulWidget {
  const NavBarWidget({super.key});

  @override
  _NavBarWidgetState createState() => _NavBarWidgetState();
}

class _NavBarWidgetState extends State<NavBarWidget> {
  int _selectedIndex = 0;
  final List _page = [
    const HomeScreen(),
    const CustomerFavouriteView(),
    const CustomerCartView(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _page[_selectedIndex],
          Positioned(
            bottom: 15,
            left: 40,
            right: 40,
            child: Container(
              height: 55,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.bottomBarColor,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    enableFeedback: false,
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    },
                    icon: Icon(
                      Icons.home_outlined,
                      size: 25,
                      color: _selectedIndex == 0
                          ? AppColors.primary
                          : AppColors.white,
                    ),
                  ),
                  IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    enableFeedback: false,
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/heart-big.svg',
                      width: 20,
                      color: _selectedIndex == 1
                          ? AppColors.primary
                          : AppColors.white,
                    ),
                  ),
                  IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    enableFeedback: false,
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 2;
                      });
                    },
                    icon: Icon(
                      Icons.shopping_bag_outlined,
                      color: _selectedIndex == 2
                          ? AppColors.primary
                          : AppColors.white,
                    ),
                  ),
                  IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    enableFeedback: false,
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 3;
                      });
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/user.svg',
                      width: 17,
                      color: _selectedIndex == 3
                          ? AppColors.primary
                          : AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
