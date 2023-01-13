import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:guessme/authentication/data/models/user_model.dart';
import 'package:guessme/utils/widgets/top_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

import '../../../main.dart';

class ViewProfilePicture extends StatefulWidget {
  final UserModel userModel;
  final String imageurl;

  const ViewProfilePicture({
    Key? key,
    required this.userModel,
    required this.imageurl,
  }) : super(key: key);

  @override
  State<ViewProfilePicture> createState() => _ViewProfilePictureState();
}

class _ViewProfilePictureState extends State<ViewProfilePicture> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopBar(left: widget.userModel.name),
            widget.userModel.udid == sharedPref.udid
                ? ElevatedButton(
                    onPressed: () async {
                      await imgFromGallery();
                      await CachedNetworkImage.evictFromCache(widget.imageurl);
                      Navigator.pop(context);
                    },
                    child: const Text("edit"))
                : Container(),
            Expanded(
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: CachedNetworkImage(
                    imageUrl: widget.imageurl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Container(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
