import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

snackBar(
    {required User? user,
    required BuildContext context,
    required String name}) {
  if (user != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$name Successful...\n UID : ${user.uid}"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.of(context).pushReplacementNamed("/", arguments: user);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$name Failed."),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

connectionSnackBar({required BuildContext context}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red,
      content: Row(
        children: const [
          Icon(Icons.wifi_off, color: Colors.white),
          SizedBox(width: 10),
          Text("No Internet Connection Available"),
        ],
      ),
    ),
  );
}
