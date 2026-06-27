import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hotel_wave/core/utils/colors.dart';
import 'package:hotel_wave/features/admin/home/home_view.dart';
import 'package:hotel_wave/features/admin/wallet/hotel_wallet_view.dart';
import 'package:hotel_wave/features/admin/wallet/restaurent_wallet_view.dart';
import 'package:hotel_wave/features/profile/profile_view.dart';

class ManagerNavBarView extends StatefulWidget {
  const ManagerNavBarView({super.key});

  @override
  State<ManagerNavBarView> createState() => _ManagerNavBarViewState();
}

class _ManagerNavBarViewState extends State<ManagerNavBarView> {
  int _selectedIndex = 0;
  final List _page = [
    const ManagerHomeView(),
    const HotelWalletView(),
    const RestaurentWalletView(),
    const ProfileView()
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
                    icon: const Icon(Icons.hotel),
                    color: _selectedIndex == 1
                        ? AppColors.primary
                        : AppColors.white,
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
                    icon: const Icon(Icons.restaurant_rounded),
                    color: _selectedIndex == 2
                        ? AppColors.primary
                        : AppColors.white,
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
