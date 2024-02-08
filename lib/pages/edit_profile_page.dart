import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_app/provider/profile_provider.dart';

class EditProfilePage extends StatefulWidget {
  final String name;
  final String location;
  final String bio;
  final String field;
  final String profilePhoto;

  const EditProfilePage({
    super.key,
    required this.name,
    required this.profilePhoto,
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

  // final picker = ImagePicker();
  File? _imageFile;

  Future<void> getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  String? profileUrl;

  Future<void> uploadImage() async {
    if (_imageFile == null) return;

    // String fileName = _imageFile!.path.split('/').last;
    String fileName = "profile$email";
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('profile_images/$fileName');
    var uploadTask = firebaseStorageRef.putFile(_imageFile!);
    profileUrl = await firebaseStorageRef.getDownloadURL();
    // print(profileUrl);
    await FirebaseAuth.instance.currentUser!.updatePhotoURL(profileUrl);
    await updateProfile();
    await uploadTask.whenComplete(() => print('Image uploaded'));
  }

  Future<void> updateProfile() async {
    if (profileUrl == null) return;
    await FirebaseFirestore.instance.collection('user').doc(email).update({
      'profileUrl': profileUrl,
    });
    log("Profile Updated");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () async {
              showDialog(
                context: context,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );
              await uploadImage();
              if (!context.mounted) return;
              // if (profileUrl == null) {
              //   context.read<ProfileProvider>().editUserProfileDetails(
              //         email: email,
              //         name: nameController.text,
              //         bio: bioController.text,
              //         location: locationController.text,
              //         field: fieldController.text,
              //         profileUrl: widget.profilePhoto,
              //       );
              // } else {
              context.read<ProfileProvider>().editUserProfileDetails(
                    email: email,
                    name: nameController.text,
                    bio: bioController.text,
                    location: locationController.text,
                    field: fieldController.text,
                    profileUrl:
                        profileUrl != null ? profileUrl! : widget.profilePhoto,
                  );
              // }
              Navigator.pop(context);
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
              height: MediaQuery.sizeOf(context).height * 0.2,
              decoration: BoxDecoration(
                //? Banner Image
                image: DecorationImage(
                  image: Image.network(
                          "https://imgs.search.brave.com/R3bGwA4un2aVaeeVdn4HdZROk8LSjWjAwpPZVvXHRww/rs:fit:500:0:0/g:ce/aHR0cHM6Ly9tYXJr/ZXRwbGFjZS5jYW52/YS5jb20vRUFEYXBD/X1dtaUkvNC8wLzE2/MDB3L2NhbnZhLXJl/c29ydC1waG90by10/d2l0dGVyLWhlYWRl/ci11OTZzNHVvTFJ1/US5qcGc")
                      .image,
                  fit: BoxFit.fill,
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: GestureDetector(
                          onTap: () async => await getImage(),
                          //? Profile Image
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            backgroundImage: _imageFile != null
                                ? Image.file(_imageFile!).image
                                : NetworkImage(
                                    widget.profilePhoto,
                                  ),
                            child: const Stack(
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
