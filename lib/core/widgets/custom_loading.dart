import 'package:flutter/material.dart';
import 'package:hotel_wave/core/utils/colors.dart';

void showLoaderDialog(BuildContext context) {
  //------------ Using Custom Loading for IOS & Android

  // showDialog(
  //   barrierDismissible: false,
  //   barrierColor: Colors.black.withOpacity(.7),
  //   context: context,
  //   builder: (BuildContext context) {
  //     return Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Lottie.asset('assets/loading.json', width: 150, height: 150),
  //       ],
  //     );
  //   },
  // );

  // //------------ Using CupertinoAlertDialog for IOS

  // showDialog(
  //   barrierDismissible: false,
  //   barrierColor: Colors.black.withOpacity(.7),
  //   context: context,
  //   builder: (BuildContext context) {
  //     return CupertinoAlertDialog(
  //       content: Row(
  //         children: [
  //           CircularProgressIndicator(
  //             color: AppColors. primary,
  //           ),
  //           Container(
  //               margin: const EdgeInsets.only(right: 15),
  //               child: const Text("جاري التحميل ...")),
  //         ],
  //       ),
  //     );
  //   },
  // );

  //------------ Using AlertDialog for Android

  showDialog(
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(.7),
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(
              color: AppColors.accentColor,
            ),
            Container(
                margin: const EdgeInsets.only(left: 15),
                child: const Text("Loading...")),
          ],
        ),
      );
    },
  );
}
