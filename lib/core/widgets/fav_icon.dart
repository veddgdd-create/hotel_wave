import 'package:flutter/material.dart';
import 'package:hotel_wave/core/services/firebase_services.dart';
import 'package:hotel_wave/core/utils/colors.dart';
import 'package:hotel_wave/core/widgets/custom_error.dart';
import 'package:hotel_wave/features/models/hotel_model/hotel_model.dart';

class FavouriteIconWidget extends StatelessWidget {
  const FavouriteIconWidget({
    super.key,
    required this.model,
  });
  final HotelModel model;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        FirebaseServices.addToFav(
                model: model, user: FirebaseServices.getUser())
            .then((value) {
          showErrorDialog(
              context, 'Added To Favourite', AppColors.bottomBarColor);
        });
      },
      child: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          color: AppColors.accentColor,
          borderRadius: BorderRadius.circular(13),
        ),
        child: const Icon(Icons.favorite_border_rounded),
      ),
    );
  }
}
