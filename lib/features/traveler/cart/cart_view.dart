import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hotel_wave/core/utils/app_text_styles.dart';
import 'package:hotel_wave/core/utils/colors.dart';
import 'package:hotel_wave/core/widgets/custom_button.dart';
import 'package:hotel_wave/features/traveler/home/widgets/resturent_item.dart';

class CustomerCartView extends StatefulWidget {
  const CustomerCartView({super.key});

  @override
  State<CustomerCartView> createState() => _CustomerCartViewState();
}

class _CustomerCartViewState extends State<CustomerCartView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? user;

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Cart'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              TabBar(dividerHeight: 0, tabs: [
                Tab(
                  child: Text(
                    'Hotel',
                    style: getbodyStyle(
                      fontSize: 16,
                      color: AppColors.white,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Restaurant',
                    style: getbodyStyle(
                      fontSize: 16,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ]),
              Expanded(
                child: TabBarView(
                  children: [
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('hotel-booking')
                            .where('userId', isEqualTo: user!.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.data?.docs
                                  .where((element) => element['status'] == 0)
                                  .isEmpty ==
                              true) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_shopping_cart_rounded,
                                    size: 150,
                                    color: AppColors.shadeColor,
                                  ),
                                  const Gap(20),
                                  Text(
                                    'No Items in your Cart\nExplore and add to your Cart',
                                    textAlign: TextAlign.center,
                                    style: getbodyStyle(
                                      fontSize: 16,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 20),
                              child: ListView.separated(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  var item = snapshot.data!.docs[index].data();
                                  if (item['status'] != 0) {
                                    return const SizedBox();
                                  }
                                  return GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        padding: const EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(15),
                                            ),
                                            color: AppColors.bottomBarColor,
                                            border: Border.all(
                                                color: AppColors.shadeColor)),
                                        child: Column(
                                          children: [
                                            ResturentItem(
                                              imageUrl: item['hotel']['cover'],
                                              name: item['hotel']['name'],
                                              location: item['hotel']
                                                  ['location'],
                                              rating: (item['hotel']['rating'])
                                                  .toStringAsFixed(1),
                                            ),
                                            const Gap(10),
                                            Row(
                                              children: [
                                                Text(
                                                  'Check In: ',
                                                  style: getTitleStyle(
                                                      color: AppColors.primary),
                                                ),
                                                Text(
                                                  item['checkIn']
                                                      .toString()
                                                      .split(' ')[0],
                                                  style: getbodyStyle(),
                                                ),
                                              ],
                                            ),
                                            const Gap(5),
                                            Row(
                                              children: [
                                                Text(
                                                  'Check Out: ',
                                                  style: getTitleStyle(
                                                      color: AppColors.primary),
                                                ),
                                                Text(
                                                  item['checkOut']
                                                      .toString()
                                                      .split(' ')[0],
                                                  style: getbodyStyle(),
                                                ),
                                              ],
                                            ),
                                            const Gap(5),
                                            Row(
                                              children: [
                                                Text(
                                                  'No. of gests: ',
                                                  style: getTitleStyle(
                                                      color: AppColors.primary),
                                                ),
                                                Text(
                                                  ' ${item['numberOfGuests'].toString()}',
                                                  style: const TextStyle(
                                                      fontSize: 16.0),
                                                ),
                                              ],
                                            ),
                                            const Gap(15),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: CustomButton(
                                                    onTap: () {
                                                      cancelRoom(snapshot.data!
                                                          .docs[index].id);
                                                    },
                                                    height: 40,
                                                    color: AppColors.redColor,
                                                    text: 'Cancel Room',
                                                  ),
                                                ),
                                                const Gap(20),
                                                Text(
                                                  ' ${item['totalPrice'].toString()} \$',
                                                  style: const TextStyle(
                                                      fontSize: 16.0),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ));
                                },
                                separatorBuilder: (context, index) =>
                                    const Gap(15),
                              ),
                            );
                          }
                        }),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('restaurant-booking')
                            .where('userId', isEqualTo: user!.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.data?.docs
                                  .where((element) => element['status'] == 0)
                                  .isEmpty ==
                              true) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_shopping_cart_rounded,
                                    size: 150,
                                    color: AppColors.shadeColor,
                                  ),
                                  const Gap(20),
                                  Text(
                                    'No Items in your Cart\nExplore and add to your Cart',
                                    textAlign: TextAlign.center,
                                    style: getbodyStyle(
                                      fontSize: 16,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 20),
                              child: ListView.separated(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  var item = snapshot.data!.docs[index].data();
                                  if (item['status'] != 0) {
                                    return const SizedBox();
                                  }
                                  return GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        padding: const EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(15),
                                            ),
                                            color: AppColors.bottomBarColor,
                                            border: Border.all(
                                                color: AppColors.shadeColor)),
                                        child: Column(
                                          children: [
                                            ResturentItem(
                                              imageUrl: item['restaurant']
                                                  ['cover'],
                                              name: item['restaurant']['name'],
                                              location: item['restaurant']
                                                  ['location'],
                                              rating: (item['restaurant']
                                                      ['rating'])
                                                  .toString(),
                                            ),
                                            const Gap(10),
                                            Row(
                                              children: [
                                                Text(
                                                  'Check In: ',
                                                  style: getTitleStyle(
                                                      color: AppColors.primary),
                                                ),
                                                Text(
                                                  item['checkIn']
                                                      .toString()
                                                      .split(' ')[0],
                                                  style: getbodyStyle(),
                                                ),
                                              ],
                                            ),
                                            const Gap(5),
                                            Row(
                                              children: [
                                                Text(
                                                  'Meal Type: ',
                                                  style: getTitleStyle(
                                                      color: AppColors.primary),
                                                ),
                                                Text(
                                                  item['mealTime']
                                                      .toString()
                                                      .split(' ')[0],
                                                  style: getbodyStyle(),
                                                ),
                                              ],
                                            ),
                                            const Gap(5),
                                            Row(
                                              children: [
                                                Text(
                                                  'No. of gests: ',
                                                  style: getTitleStyle(
                                                      color: AppColors.primary),
                                                ),
                                                Text(
                                                  ' ${item['numberOfGuests'].toString()}',
                                                  style: const TextStyle(
                                                      fontSize: 16.0),
                                                ),
                                              ],
                                            ),
                                            const Gap(15),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: CustomButton(
                                                    onTap: () {
                                                      cancelRestaurant(snapshot
                                                          .data!
                                                          .docs[index]
                                                          .id);
                                                    },
                                                    height: 40,
                                                    color: AppColors.redColor,
                                                    text: 'Cancel Room',
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ));
                                },
                                separatorBuilder: (context, index) =>
                                    const Gap(15),
                              ),
                            );
                          }
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void cancelRoom(id) {
    FirebaseFirestore.instance
        .collection('hotel-booking')
        .doc(id)
        .set({'status': 2}, SetOptions(merge: true));
  }

  void cancelRestaurant(id) {
    FirebaseFirestore.instance
        .collection('restaurant-booking')
        .doc(id)
        .set({'status': 2}, SetOptions(merge: true));
  }
}
