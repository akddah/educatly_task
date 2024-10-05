import 'package:flutter/material.dart';
import 'package:task/main.dart';

showLoadingDialog() {
  return showDialog(
    context: navigatorKey.currentContext!,
    barrierDismissible: false,
    builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

hideLoadingDialog() {
  return Navigator.pop(navigatorKey.currentContext!);
}
