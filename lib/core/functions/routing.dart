import 'package:flutter/material.dart';

void navigateTo(context, Widget newView) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => newView,
    ),
  );
}

void navigateToWithReplacement(context, Widget newView) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => newView,
    ),
  );
}

void navigateAndRemoveUntil(context, Widget newView) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (context) => newView,
    ),
    (route) => false,
  );
}
