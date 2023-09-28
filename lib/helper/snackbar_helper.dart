import 'package:flutter/material.dart';
import 'package:flutter_dj/simple_widget/simple_text.dart';

void showAppSnackBar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Center(
        child: SimpleText(
      text: message,
      fontSize: 16,
    )),
  ));
}
