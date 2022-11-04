import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/helpers/cloud_firestore_helper.dart';
import 'package:firebase_app/helpers/firebase_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  String? name;
  String? city;
  int? age;

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          insertAndUpdateRecord(isUpdate: false);
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: CloudFirestoreHelper.cloudFirestoreHelper.selectRecords(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.hasData) {
            List<QueryDocumentSnapshot> data = snapshot.data!.docs;

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, i) {
                return Card(
                  elevation: 3,
                  child: ListTile(
                    isThreeLine: true,
                    leading: Text("${i + 1}"),
                    title: Text("${data[i]["name"]}"),
                    subtitle:
                        Text("${data[i]["city"]}\nAge : ${data[i]["age"]}"),
                    trailing: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            nameController.text = "${data[i]["name"]}";
                            ageController.text = "${data[i]["age"]}";
                            cityController.text = "${data[i]["city"]}";

                            insertAndUpdateRecord(
                                isUpdate: true, id: data[i].id);
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            CloudFirestoreHelper.cloudFirestoreHelper
                                .deleteRecords(id: data[i].id);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  insertAndUpdateRecord({required bool isUpdate, id}) {
    (isUpdate) ? null : clearControllersAndVar();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title:
            Center(child: Text((isUpdate) ? "Update Record" : "Insert Record")),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 15),
              TextFormField(
                controller: nameController,
                decoration: textFieldDecoration("Name", Icons.person),
                onSaved: (val) {
                  name = val;
                },
                validator: (val) => (val!.isEmpty) ? "Enter Name First" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: textFieldDecoration("Age", Icons.accessibility),
                onSaved: (val) {
                  age = int.parse(val!);
                },
                validator: (val) => (val!.isEmpty) ? "Enter Age First." : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: cityController,
                decoration: textFieldDecoration("City", Icons.location_city),
                onSaved: (val) {
                  city = val;
                },
                validator: (val) => (val!.isEmpty) ? "Enter City First." : null,
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();

                Map<String, dynamic> data = {
                  "name": name,
                  "age": age,
                  "city": city,
                };

                if (isUpdate) {
                  CloudFirestoreHelper.cloudFirestoreHelper
                      .updateRecords(data: data, id: id);
                } else {
                  CloudFirestoreHelper.cloudFirestoreHelper
                      .insertData(data: data);
                }

                Navigator.of(context).pop();
              }
            },
            child: Text((isUpdate) ? "Update" : "Add"),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(shape: const StadiumBorder()),
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
    nameController.clear();
    ageController.clear();
    cityController.clear();

    name = null;
    city = null;
    age = null;
  }
}
