import 'package:flutter/material.dart';

import '../../../../core/constants/constant.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Find a perfect', style: nunitoRegular17),
              Text('Hotel for you', style: nunito26),
              const SizedBox(height: 9),
              // Row(
              //   children: [
              //     SvgPicture.asset('assets/icons/location.svg'),
              //     const SizedBox(width: 5),
              //     Text(
              //       'United States',
              //       style: nunito14.copyWith(fontFamily: 'Roboto'),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
