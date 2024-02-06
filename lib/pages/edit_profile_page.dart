import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/provider/profile_provider.dart';

class EditProfilePage extends StatefulWidget {
  final String name;
  final String location;
  final String bio;
  final String field;

  const EditProfilePage({
    super.key,
    required this.name,
    required this.location,
    required this.bio,
    required this.field,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController bioController;
  late TextEditingController fieldController;
  late TextEditingController locationController;
  late String email;

  @override
  void initState() {
    email = FirebaseAuth.instance.currentUser!.email.toString();
    nameController = TextEditingController(text: widget.name);
    bioController = TextEditingController(text: widget.bio);
    fieldController = TextEditingController(text: widget.field);
    locationController = TextEditingController(text: widget.location);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              context.read<ProfileProvider>().editUserProfileDetails(
                    email: email,
                    name: nameController.text,
                    bio: bioController.text,
                    location: locationController.text,
                    field: fieldController.text,
                  );
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Text(
                "Save",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: Image.network(
                          "https://imgs.search.brave.com/R3bGwA4un2aVaeeVdn4HdZROk8LSjWjAwpPZVvXHRww/rs:fit:500:0:0/g:ce/aHR0cHM6Ly9tYXJr/ZXRwbGFjZS5jYW52/YS5jb20vRUFEYXBD/X1dtaUkvNC8wLzE2/MDB3L2NhbnZhLXJl/c29ydC1waG90by10/d2l0dGVyLWhlYWRl/ci11OTZzNHVvTFJ1/US5qcGc")
                      .image,
                  fit: BoxFit.fill,
                ),
              ),
              child: const Stack(
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.all(7.0),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTvi7HpQ-_PMSMOFrj1hwjp6LDcI-jm3Ro0Xw&usqp=CAU",
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    CupertinoIcons.camera,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  EditProfileTextField(
                    maxLines: 1,
                    name: "Name",
                    controller: nameController,
                  ),
                  EditProfileTextField(
                    maxLines: null,
                    name: "Bio",
                    controller: bioController,
                  ),
                  EditProfileTextField(
                    maxLines: null,
                    name: "Location",
                    controller: locationController,
                  ),
                  EditProfileTextField(
                    maxLines: null,
                    name: "Field",
                    controller: fieldController,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfileTextField extends StatelessWidget {
  final String name;
  final TextEditingController controller;
  final int? maxLines;
  const EditProfileTextField(
      {super.key,
      required this.name,
      required this.controller,
      required this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        maxLines: maxLines,
        style: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        controller: controller,
        cursorRadius: const Radius.circular(18),
        cursorColor: Colors.blue,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          labelText: name,
          labelStyle: TextStyle(
            fontSize: 20,
            color: Colors.grey.shade400,
          ),
          floatingLabelStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 20,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }
}
