import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_wave/features/models/hotel_model/hotel_model.dart';
import 'package:hotel_wave/features/traveler/home/widgets/hotel_item.dart';

class AllHotelsList extends StatelessWidget {
  const AllHotelsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Hotels'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('hotels').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              var hotels = snapshot.data!.docs;
              return Padding(
                padding: const EdgeInsets.only(left: 24),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: .8),
                  itemCount: hotels.length,
                  itemBuilder: (context, index) {
                    HotelModel hotel =
                        HotelModel.fromJson(hotels[index].data());

                    return HotelItem(model: hotel);
                  },
                ),
              );
            }),
      ),
    );
  }
}
