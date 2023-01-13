import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:guessme/authentication/data/models/user_model.dart';
import 'package:guessme/main.dart';
import 'package:guessme/profile/screens/widgets/view_profile_picture.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ProfilePicture extends StatefulWidget {
  final UserModel userModel;
  const ProfilePicture({Key? key, required this.userModel}) : super(key: key);

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final destination = 'files/profile_photos';
  File? _photo;

  final ImagePicker _picker = ImagePicker();
  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child(sharedPref.udid);
      await ref.putFile(_photo!);
    } catch (e) {
      print('error occured');
    }
  }

  String url = '';
  getImage() async {
    final ref = firebase_storage.FirebaseStorage.instance
        .ref(destination)
        .child(widget.userModel.udid);

    await ref.getDownloadURL();
    url = '';
    setState(() {});
  }

  @override
  void initState() {
    getImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewProfilePicture(
                          userModel: widget.userModel,
                          imageurl: url,
                        )));
          },
          child: Material(
            elevation: 10,
            color: Colors.white,
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(100),
            child: Container(
              
              width: 100,
              height: 100,
              decoration: BoxDecoration(),
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Container(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Future<String> getProfileImageUrl({required String udid}) async {
  final destination = 'files/profile_photos';
  final ref =
      firebase_storage.FirebaseStorage.instance.ref(destination).child(udid);
  String img = await ref.getDownloadURL();
  return img;
}
