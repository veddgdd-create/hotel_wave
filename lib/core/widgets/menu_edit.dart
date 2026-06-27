import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hotel_wave/core/utils/app_text_styles.dart';
import 'package:hotel_wave/core/utils/colors.dart';

class EditMenuItems extends StatelessWidget {
  const EditMenuItems({
    super.key,
    required this.data,
    this.isOffer = false,
  });

  final bool isOffer;
  final QuerySnapshot<Map<String, dynamic>> data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(10),
        Expanded(
            child: ListView.builder(
          itemCount: data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot item = data.docs[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.accentColor,
              ),
              width: MediaQuery.sizeOf(context).width * .9,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.bottomBarColor,
                          radius: 60,
                          backgroundImage: NetworkImage(
                            item['image'],
                          ),
                        ),
                        const Gap(30),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${item['name']}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: getTitleStyle(),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star_purple500_sharp,
                                    color: AppColors.accentColor,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '${item['rate']}(${item['rate_num']})',
                                    style: getTitleStyle(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'EGP ${((item['offer_persent'] != 0) ? (item['price'] * (100 - item['offer_persent']) * .01).toString() : item['price']).toString()}',
                              style: getTitleStyle(
                                  color: AppColors.accentColor,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            if ((item['offer_persent']) != 0)
                              Text(
                                'EGP ${item['price']}',
                                style: getTitleStyle(
                                        color: AppColors.white.withOpacity(.5),
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12)
                                    .copyWith(
                                        decorationColor:
                                            AppColors.white.withOpacity(.5),
                                        decoration: TextDecoration.lineThrough),
                              ),
                            const Spacer(),
                            if ((item['offer_persent']) != 0)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 3),
                                decoration: BoxDecoration(
                                    color: AppColors.accentColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  '${(item['offer_persent'])}% OFF',
                                  style: getsmallStyle(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                          ],
                        ),
                        const Gap(10),
                        // if (item['description'] != '')
                        //   Text(
                        //     item['description'],
                        //     maxLines: 1,
                        //     overflow: TextOverflow.ellipsis,
                        //     style: getTitleStyle(
                        //         color: AppColors.white, fontSize: 12),
                        //   ),
                        // const Gap(10),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {},
                                child: Ink(
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: AppColors.accentColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Text(
                                      'EDIT ITEM',
                                      style: getsmallStyle(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        )),
      ],
    );
  }
}
