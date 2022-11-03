import 'package:firebase_app/helpers/firebase_helper.dart';
import 'package:firebase_app/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                User? user =
                    await FireBaseHelper.fireBaseHelper.signInAnonymously();
                snackBar(user: user, context: context, name: "Login");
              },
              child: const Text("Anonymously"),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => singUpAndSingIn(isSingIn: false),
                  child: const Text("Sing up"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => singUpAndSingIn(isSingIn: true),
                  child: const Text("Sing in"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                User? user =
                    await FireBaseHelper.fireBaseHelper.signInWithGoogle();
                snackBar(user: user, context: context, name: "Login");
              },
              child: const Text("Continue with Google"),
            ),
          ],
        ),
      ),
    );
  }

  singUpAndSingIn({required bool isSingIn}) {
    clearControllersAndVar();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text((isSingIn) ? "Sing In" : "Sing Up"),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 15),
              TextFormField(
                controller: emailController,
                decoration: textFieldDecoration("Email", Icons.email),
                onSaved: (val) {
                  email = val;
                },
                validator: (val) => (val!.isEmpty) ? "Enter First email" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: textFieldDecoration("Password", Icons.password),
                onSaved: (val) {
                  password = val;
                },
                validator: (val) =>
                    (val!.isEmpty) ? "Enter First Password" : null,
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();

                if (isSingIn) {
                  User? user = await FireBaseHelper.fireBaseHelper
                      .singIn(email: email!, password: password!);
                  Navigator.of(context).pop();
                  snackBar(user: user, context: context, name: "Sing In");
                } else {
                  User? user = await FireBaseHelper.fireBaseHelper
                      .singUp(email: email!, password: password!);
                  snackBar(user: user, context: context, name: "Sing Up");

                  Navigator.of(context).pop();
                }
              }
            },
            child: Text((isSingIn) ? "Sing In" : "Sing Up"),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  textFieldDecoration(String hint, var icon) {
    return InputDecoration(
      prefixIcon: Icon(icon),
      hintText: "Enter $hint Hear...",
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
      label: Text(hint),
    );
  }

  clearControllersAndVar() {
    emailController.clear();
    passwordController.clear();

    email = "";
    password = "";
  }
}
