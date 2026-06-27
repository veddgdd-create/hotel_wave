import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:hotel_wave/core/constants/constant.dart';
import 'package:hotel_wave/core/constants/dummy.dart';
import 'package:hotel_wave/core/functions/routing.dart';
import 'package:hotel_wave/core/utils/app_text_styles.dart';
import 'package:hotel_wave/core/utils/colors.dart';
import 'package:hotel_wave/core/widgets/custom_button.dart';
import 'package:hotel_wave/core/widgets/custom_error.dart';
import 'package:hotel_wave/features/models/hotel_model/hotel_model.dart';
import 'package:hotel_wave/features/traveler/booking/view/hotel_booking_view.dart';
import 'package:hotel_wave/features/traveler/booking/widgets/detail_info.dart';
import 'package:hotel_wave/features/traveler/booking/widgets/facility_item.dart';
import 'package:hotel_wave/features/traveler/booking/widgets/image_container.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({
    super.key,
    required this.model,
  });
  final HotelModel model;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _message = TextEditingController();

  int rate = 0;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
        bottomNavigationBar:
            (FirebaseAuth.instance.currentUser?.photoURL != '0')
                ? Padding(
                    padding: const EdgeInsets.all(20),
                    child: CustomButton(
                      color: AppColors.redColor,
                      text: 'Delete Hotel',
                      onTap: () {
                        FirebaseFirestore.instance
                            .collection('hotels')
                            .doc(widget.model.id)
                            .delete();
                        Navigator.pop(context);
                      },
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(20),
                    child: CustomButton(
                      text: 'Book Now',
                      onTap: () {
                        navigateTo(
                            context,
                            HotelBookingView(
                              hotel: widget.model,
                            ));
                      },
                    ),
                  ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ImageContainer(
              model: widget.model,
            ),
            const Gap(10),
            DetailInfo(
              title: widget.model.name ?? '',
              rating: widget.model.rating!.toStringAsFixed(1),
              reviews: widget.model.reviews!.length.toString(),
              price: widget.model.rooms!.first.pricePerNight.toString(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Facilities',
                style: nunito16.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Gap(10),
            SizedBox(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: facilities.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: FacilityItem(svgPath: facilities[index]),
                    );
                  },
                ),
              ),
            ),
            const Gap(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Description',
                style: nunito16.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                widget.model.description ?? '',
                style: nunito14,
              ),
            ),
            const Gap(10),
            Divider(
              color: AppColors.accentColor,
            ),
            const Gap(10),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ExpansionTile(
                collapsedBackgroundColor: AppColors.shadeColor,
                collapsedIconColor: AppColors.accentColor,
                backgroundColor: Colors.transparent,
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                childrenPadding: const EdgeInsets.symmetric(vertical: 10),
                subtitle: Text(
                  'Send Your Feedback Now',
                  style: getsmallStyle(),
                ),
                title: Text(
                  'Review',
                  style: getTitleStyle(fontSize: 16),
                ),
                children: [
                  TextFormField(
                    controller: _message,
                    maxLines: 3,
                    decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        fillColor: AppColors.white),
                  ),
                  const Gap(15),
                  Row(
                    children: [
                      Row(
                        children: List.generate(
                          5,
                          (index) => InkWell(
                            onTap: () {
                              setState(() {
                                rate = index + 1;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                (rate <= index)
                                    ? Icons.star_border_purple500_sharp
                                    : Icons.star_purple500_sharp,
                                color: AppColors.primary,
                                size: 27,
                              ),
                            ),
                          ),
                        ).toList(),
                      ),
                      const Spacer(),
                      CustomButton(
                        width: 90,
                        height: 40,
                        radius: 10,
                        text: 'SEND',
                        onTap: () {
                          double totalRating = 0;
                          int totalReviews = widget.model.reviews!.length;

                          for (var review in widget.model.reviews!) {
                            totalRating += review.rate!.toDouble();
                          }

                          double res = totalRating / totalReviews;
                          // update rate in hotel collection
                          FirebaseFirestore.instance
                              .collection('hotels')
                              .doc(widget.model.id)
                              .update({
                            'rating': (res > 5 ? 5 : res),
                            'reviews': [
                              ...widget.model.reviews!.map((e) => e.toJson()),
                              {
                                'message': _message.text,
                                'rate': rate.toDouble(),
                                'name': FirebaseAuth
                                    .instance.currentUser!.displayName
                              }
                            ]
                          }).then((value) {
                            _message.clear();
                            setState(() {
                              rate = 0;
                            });

                            showErrorDialog(
                                context,
                                'Your Review sent Successfully',
                                AppColors.bottomBarColor);
                          });
                        },
                      )
                    ],
                  ),
                ],
              ),
            )
          ]),
        ));
  }
}
