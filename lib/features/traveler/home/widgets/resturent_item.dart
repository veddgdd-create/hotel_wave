import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hotel_wave/core/utils/colors.dart';

import '../../../../core/constants/constant.dart';

class ResturentItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String location;
  final String rating;

  const ResturentItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.location,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.shadeColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          )),
      child: Row(
        children: [
          SizedBox(
            height: 90,
            width: 150,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Image.asset('assets/logo.png');
                },
              ),
            ),
          ),
          const Gap(15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: nunito14.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Gap(5),
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/star.svg'),
                    const SizedBox(width: 5),
                    Text(
                      rating,
                      style: nunito10.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Gap(10),
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/location.svg'),
                    const SizedBox(width: 5),
                    Text(
                      'Nasr City, Cairo',
                      style: nunito10,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(10),
        ],
      ),
    );
  }
}
