import 'package:firebase_app/screens/home_page.dart';
import 'package:firebase_app/screens/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => const HomePage(),
        "login_page": (context) => const LoginPage(),
      },
    ),
  );
}
