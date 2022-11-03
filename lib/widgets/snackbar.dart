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
