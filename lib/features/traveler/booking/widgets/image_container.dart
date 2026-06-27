import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotel_wave/core/widgets/custom_back_action.dart';
import 'package:hotel_wave/core/widgets/fav_icon.dart';
import 'package:hotel_wave/features/models/hotel_model/hotel_model.dart';

class ImageContainer extends StatelessWidget {
  final HotelModel model;

  const ImageContainer({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.58,
          width: MediaQuery.of(context).size.width,
          child: Align(
            alignment: Alignment.topCenter,
            child: Hero(
              tag: model.id ?? 0,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                  child: Image.network(
                    model.cover ?? '',
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
            ),
          ),
        ),
        if (FirebaseAuth.instance.currentUser?.photoURL == '0')
          Positioned(
              top: 40,
              right: 35,
              child: FavouriteIconWidget(
                model: model,
              )),
        const Positioned(top: 40, left: 35, child: CustomBackAction()),
        Positioned(
          top: 360,
          left: 24,
          right: 24,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: model.images!
                  .map((e) => ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          e,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Image.asset(
                              'assets/logo.png',
                              width: 90,
                            );
                          },
                        ),
                      ))
                  .toList()),
        )
      ],
    );
  }
}
