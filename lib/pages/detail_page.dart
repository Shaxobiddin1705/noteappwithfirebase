import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:noteappwithfirebase/models/store_model.dart';
import 'package:noteappwithfirebase/services/real_time_database.dart';

import '../models/post_model.dart';

class DetailPage extends StatefulWidget {
  late String message;
  late String index;
  DetailPage({Key? key, required this.message, required this.index}) : super(key: key);
  static const String id = "detail_page";


  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  File? _image;
  bool onPressed = false;
  bool isLoading = false;

  Future<void> getImage({required ImageSource source}) async{
    Navigator.pop(context);
    final image = await ImagePicker().pickImage(source: source);
    if(image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  void _addPost() {
    String title = titleController.text.trim().toString();
    String content = contentController.text.trim().toString();
    final FirebaseAuth  _auth = FirebaseAuth.instance;
    // final _database = FirebaseDatabase.instance.ref();
    setState(() {
      isLoading = true;
    });
    StoreService.uploadImage(_image!).then((value) => {
      RTDService.addPost(Post(_auth.currentUser!.uid, title, content, value!)).then((value) {
        setState(() {
          isLoading = false;
        });
      _goHomePage();
      })
    });
  }

  void _updatePost() {
    String title = titleController.text.trim().toString();
    String content = contentController.text.trim().toString();
    setState(() {
      isLoading = true;
    });
    RTDService.updatePost(title: title, content: content, key: posts[int.parse(widget.index)].key).then((value) {
      setState(() {
        isLoading = false;
      });
      _goHomePage();
    });
  }

  void _goHomePage() {
    Navigator.pop(context, 'done');
  }

  @override
  void initState() {
    if(widget.message == 'edit') {
      titleController = TextEditingController(text: posts[int.parse(widget.index)].title);
      contentController = TextEditingController(text: posts[int.parse(widget.index)].content);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Add Post"),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              // height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10,),

                  widget.message == 'new' ?
                  GestureDetector(
                      onTap: (){
                        _dialog();
                      },
                      child: _image == null ? Container(
                        width: MediaQuery.of(context).size.width,
                        child: Lottie.asset('assets/animations/camera.json', height: 250, animate: true,),
                      ) :
                      Image(image: FileImage(File(_image!.path)), height: 300,fit: BoxFit.cover,)
                  ) : Container(
                    height: 250,
                    child: CachedNetworkImage(
                      imageUrl: posts[int.parse(widget.index)].image_url, fit: BoxFit.cover,
                      placeholder: (context, url) => Lottie.asset('assets/animations/loading.json', height: 250, animate: true),
                    ),
                  ),

                  const SizedBox(height: 10,),


                  //#title
                  TextField(
                    controller: titleController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                        hintText: "Title",
                        hintStyle: TextStyle(color: CupertinoColors.systemGrey)
                    ),
                  ),

                  const SizedBox(height: 10,),

                  //#content
                  TextField(
                    controller: contentController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                        hintText: "Content",
                        hintStyle: TextStyle(color: CupertinoColors.systemGrey)
                    ),
                  ),

                  const SizedBox(height: 20,),

                  //#signIn
                  MaterialButton(
                      onPressed: () {
                        widget.message == 'new' ? _addPost() : _updatePost();
                      },
                      child: const Text("Add"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      height: 45,
                      minWidth: MediaQuery.of(context).size.width - 50,
                      textColor: Colors.white,
                      color: const Color(0xff0096ff)
                  ),
                ],
              ),
            ),
          ),
          isLoading ? Center(child: Lottie.asset('assets/animations/loading_2.json', height: 280, animate: true)) : const SizedBox.shrink(),
        ],
      )
    );
  }

  void _dialog() {
    showDialog (
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose image"),
          actions: [
            TextButton(
              onPressed: (){
                getImage(source: ImageSource.gallery);
              },
              child: Text("Gallery"),
            ),
            TextButton(
              onPressed: (){
                getImage(source: ImageSource.camera);
              },
              child: Text("Camera"),
            ),
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },

    );
  }
}
