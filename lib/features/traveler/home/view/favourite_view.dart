import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hotel_wave/core/utils/app_text_styles.dart';
import 'package:hotel_wave/core/utils/colors.dart';
import 'package:hotel_wave/features/traveler/home/widgets/resturent_item.dart';

class CustomerFavouriteView extends StatefulWidget {
  const CustomerFavouriteView({super.key});

  @override
  State<CustomerFavouriteView> createState() => _CustomerFavouriteViewState();
}

class _CustomerFavouriteViewState extends State<CustomerFavouriteView> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favourite'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('favourite-list')
              .doc(user?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data?.data()?.isEmpty ?? true) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_outlined,
                      size: 150,
                      color: AppColors.shadeColor,
                    ),
                    const Gap(20),
                    Text(
                      'No Items in your favourite\nExplore and add to your favourite',
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: ListView.separated(
                  itemCount: snapshot.data!.data()!.length,
                  itemBuilder: (context, index) {
                    var item = snapshot.data!.data()!;
                    List<String> keyy = snapshot.data!.data()!.keys.toList();
                    return Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                              onTap: () {},
                              child: ResturentItem(
                                imageUrl: item[keyy[index]]['cover'],
                                name: item[keyy[index]]['name'],
                                location: item[keyy[index]]['location'],
                                rating:
                                    (item[keyy[index]]['rating']).toString(),
                              )),
                        ),
                        const Gap(10),
                        GestureDetector(
                          onTap: () {
                            deleteItemFromFav(item[keyy[index]]['id']);
                          },
                          child: Container(
                            height: 90,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                color: AppColors.redColor,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15),
                                )),
                            child: Icon(
                              Icons.delete,
                              color: AppColors.white,
                            ),
                          ),
                        )
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => const Gap(15),
                ),
              );
            }
          }),
    );
  }

  void deleteItemFromFav(item) {
    FirebaseFirestore.instance.collection('favourite-list').doc(user?.uid).set({
      item: FieldValue.delete(),
    }, SetOptions(merge: true));
  }
}
