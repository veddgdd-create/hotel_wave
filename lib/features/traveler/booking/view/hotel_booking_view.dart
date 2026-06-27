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
import 'package:hotel_wave/features/models/hotel_model/hotel_model.dart';

class HotelBookingView extends StatefulWidget {
  const HotelBookingView({super.key, required this.hotel});

  final HotelModel hotel;

  @override
  _HotelBookingViewState createState() => _HotelBookingViewState();
}

class _HotelBookingViewState extends State<HotelBookingView> {
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _numberOfGuests = 1;
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
        } else {
          _checkOutDate = pickedDate;
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
        child: SingleChildScrollView(
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
                'Check-Out Date:',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 10),
              CustomButton(
                onTap: () => _showDatePicker(context, 'checkOut'),
                color: AppColors.shadeColor,
                text: _checkOutDate == null
                    ? 'Select Check-Out Date'
                    : '${_checkOutDate!.day}/${_checkOutDate!.month}/${_checkOutDate!.year}',
              ),
              const SizedBox(height: 20),
              const Text(
                'Number of Guests:',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                    5,
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
              const Divider(
                thickness: .5,
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Text(
                    'Total Price: $_numberOfGuests x ${widget.hotel.rooms?[_numberOfGuests == 1 ? 0 : 1].pricePerNight} \$',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const Spacer(),
                  Text(
                    '${_numberOfGuests.toDouble() * widget.hotel.rooms![0].pricePerNight!}\$',
                    style:
                        getTitleStyle(color: AppColors.primary, fontSize: 20),
                  ),
                ],
              ),
              const Gap(20),
              CustomButton(
                onTap: () {
                  if (_checkInDate == null || _checkOutDate == null) {
                    showErrorDialog(
                        context, 'Please select check-in and check-out dates');
                  } else {
                    _bookRoom();
                    navigateAndRemoveUntil(context, const NavBarWidget());
                  }
                },
                text: 'Book Now',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _bookRoom() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseServices.getUser().uid)
        .get()
        .then((value) {
      FirebaseFirestore.instance.collection('hotel-booking').doc().set({
        'userId': FirebaseServices.getUser().uid,
        'bookingDateTime': DateTime.now().toString(),
        'user': value.data(),
        'hotel': widget.hotel.toJson(),
        'checkIn': _checkInDate.toString(),
        'checkOut': _checkOutDate.toString(),
        'numberOfGuests': _numberOfGuests,
        'specialRequests': _specialRequests,
        'status': 0, // 0 = pending, 1 = confirmed, 2 = canceled

        'totalPrice': _numberOfGuests.toDouble() *
            widget.hotel.rooms![_numberOfGuests == 1 ? 0 : 1].pricePerNight!,
        'rating': {}
      }, SetOptions(merge: true));
    });
  }
}
