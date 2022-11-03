import 'package:firebase_app/helpers/firebase_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    User? res = ModalRoute.of(context)!.settings.arguments as User?;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase App"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              FireBaseHelper.fireBaseHelper.singOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("login_page", (route) => false);
            },
            icon: const Icon(Icons.power_settings_new),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const SizedBox(height: 70),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                (res!.photoURL == null)
                    ? "https://cdn-icons-png.flaticon.com/512/149/149071.png"
                    : res.photoURL.toString(),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "Name : ${(res.displayName == null) ? "--" : res.displayName}",
            ),
            const SizedBox(height: 10),
            Text("Email : ${(res.email == null) ? "---" : res.email}"),
          ],
        ),
      ),
      body: Container(),
    );
  }
}
