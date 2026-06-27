import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hotel_wave/core/constants/constant.dart';
import 'package:hotel_wave/core/utils/colors.dart';

class DetailInfo extends StatelessWidget {
  final String title;
  final String reviews;
  final String rating;
  final String? price;

  const DetailInfo({
    super.key,
    required this.title,
    this.price,
    required this.reviews,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(title, style: nunito23)),
                  if (price != null)
                    Row(
                      children: [
                        Text(
                          '$price\$ ',
                          style: nunito18.copyWith(
                            fontFamily: 'Roboto',
                            color: AppColors.primary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          '/ per night',
                          style: nunito10.copyWith(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            color: kAccentColor,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              const Gap(10),
              Row(
                children: [
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/star.svg'),
                      const SizedBox(width: 4),
                      Text(
                        '$rating ($reviews)',
                        style: nunito14.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/location.svg'),
                      const SizedBox(width: 5),
                      Text(
                        'Nasr City, Cairo',
                        style: nunito14.copyWith(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 17),
      ],
    );
  }
}
