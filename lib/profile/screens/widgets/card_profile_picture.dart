import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CardProfilePicture extends StatefulWidget {
  final String udid;
  const CardProfilePicture({Key? key, required this.udid}) : super(key: key);

  @override
  State<CardProfilePicture> createState() => _CardProfilePictureState();
}

class _CardProfilePictureState extends State<CardProfilePicture> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final destination = 'files/profile_photos';
  String url = '';
  getImage() async {
    final ref = firebase_storage.FirebaseStorage.instance
        .ref(destination)
        .child(widget.udid);
    String url = '';
    try {
      url = await ref.getDownloadURL();
    } catch (e) {
      url = "";
    }
    setState(() {});
  }

  @override
  void initState() {
    getImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(url),
          ),
        ),
      ),
    );
  }
}
