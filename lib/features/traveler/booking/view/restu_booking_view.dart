import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hotel_wave/core/functions/routing.dart';
import 'package:hotel_wave/core/services/firebase_services.dart';
import 'package:hotel_wave/core/utils/app_text_styles.dart';
import 'package:hotel_wave/core/utils/colors.dart';
import 'package:hotel_wave/core/widgets/bottom_bar.dart';
import 'package:hotel_wave/core/widgets/custom_button.dart';
import 'package:hotel_wave/core/widgets/custom_error.dart';
import 'package:hotel_wave/features/models/restaurant_model.dart';

class RestuarentBookingView extends StatefulWidget {
  const RestuarentBookingView({super.key, required this.restuarentModel});

  final RestuarentModel restuarentModel;

  @override
  _RestuarentBookingViewState createState() => _RestuarentBookingViewState();
}

class _RestuarentBookingViewState extends State<RestuarentBookingView> {
  DateTime? _checkInDate;
  int _numberOfGuests = 1;
  int mealIndex = 0;
  String _specialRequests = '';

  void _showDatePicker(BuildContext context, String type) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null) {
      setState(() {
        if (type == 'checkIn') {
          _checkInDate = pickedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Room'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Check-In Date:',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 10),
            CustomButton(
              onTap: () => _showDatePicker(context, 'checkIn'),
              color: AppColors.shadeColor,
              text: _checkInDate == null
                  ? 'Select Check-In Date'
                  : '${_checkInDate!.day}/${_checkInDate!.month}/${_checkInDate!.year}',
            ),
            const SizedBox(height: 20),
            const Text(
              'Choose Your Meal Time:',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        mealIndex = 0;
                      });
                    },
                    child: Container(
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: mealIndex == 0
                              ? AppColors.primary
                              : AppColors.shadeColor,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        'breakfast',
                        style: getbodyStyle(
                          color: mealIndex == 0
                              ? AppColors.white
                              : AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        mealIndex = 1;
                      });
                    },
                    child: Container(
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          color: mealIndex == 1
                              ? AppColors.primary
                              : AppColors.shadeColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        'Lunch',
                        style: getbodyStyle(
                          color: mealIndex == 1
                              ? AppColors.white
                              : AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        mealIndex = 2;
                      });
                    },
                    child: Container(
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          color: mealIndex == 2
                              ? AppColors.primary
                              : AppColors.shadeColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        'Dinner',
                        style: getbodyStyle(
                          color: mealIndex == 1
                              ? AppColors.white
                              : AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Number of Guests:',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColors.shadeColor,
              ),
              child: DropdownButton<int>(
                value: _numberOfGuests,
                iconEnabledColor: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
                isExpanded: true,
                underline: const SizedBox(),
                onChanged: (value) {
                  setState(() {
                    _numberOfGuests = value!;
                  });
                },
                items: List.generate(
                  10,
                  (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text('${index + 1}'),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Special Requests:',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                setState(() {
                  _specialRequests = value;
                });
              },
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Enter any special requests (optional)',
                hintStyle: getsmallStyle(),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            const Spacer(),
            const Gap(20),
            CustomButton(
              onTap: () {
                if (_checkInDate == null) {
                  showErrorDialog(context, 'Please select check-in');
                } else {
                  _bookRestaurant();
                  navigateAndRemoveUntil(context, const NavBarWidget());
                }
              },
              text: 'Book Now',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _bookRestaurant() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseServices.getUser().uid)
        .get()
        .then((value) {
      FirebaseFirestore.instance.collection('restaurant-booking').doc().set({
        'userId': FirebaseServices.getUser().uid,
        'bookingDateTime': DateTime.now().toString(),
        'user': value.data(),
        'restaurant': widget.restuarentModel.toJson(),
        'checkIn': _checkInDate.toString(),
        'mealTime': mealIndex == 0
            ? 'breakfast'
            : mealIndex == 1
                ? 'Lunch'
                : 'Dinner',
        'numberOfGuests': _numberOfGuests,
        'specialRequests': _specialRequests,
        'status': 0, // 0 = pending, 1 = confirmed, 2 = canceled
        'rating': {}
      }, SetOptions(merge: true));
    });
  }
}
