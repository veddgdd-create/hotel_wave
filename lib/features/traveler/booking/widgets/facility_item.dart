import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotel_wave/core/constants/constant.dart';

class FacilityItem extends StatelessWidget {
  final String svgPath;

  const FacilityItem({super.key, required this.svgPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        color: kShadeColor,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: SvgPicture.asset(
          svgPath,
        ),
      ),
    );
  }
}
