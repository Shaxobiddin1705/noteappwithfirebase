import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:noteappwithfirebase/pages/detail_page.dart';
import 'package:noteappwithfirebase/pages/sign_in_page.dart';
import 'package:noteappwithfirebase/services/auth_service.dart';
import 'package:noteappwithfirebase/services/hive_service.dart';
import 'package:noteappwithfirebase/services/real_time_database.dart';

import '../models/post_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String id = 'home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool onPressed = false;

  void _loadPosts() async{
    var _auth = FirebaseAuth.instance;
    String uid = HiveDB.loadUserId();
    RTDService.getPosts(_auth.currentUser!.uid).then((items) {
      _showResponse(items);
    });
  }

  _showResponse(List<Post> items) {
    setState(() {
      posts = items;
    });
  }

  _deletePost({required key}) {
    RTDService.deletePost(key: key);
    Navigator.pop(context);
    _loadPosts();
  }

  @override
  void initState() {
    _loadPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30,),

              //#Avatar
              Container(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CircleAvatar(
                    minRadius: 50,
                    maxRadius: 50,
                    child: Lottie.asset('assets/animations/user_avatar.json',fit: BoxFit.cover),
                  ),
                ),
              ),

              const SizedBox(height: 15,),

              const Center(
                child: Text("Shaxobiddin \nSultonov", textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
              ),

              const SizedBox(height: 15,),

              ExpansionTile(
                title: const Text("Settings", style: TextStyle(fontSize: 17),),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 17),
                    child: InkWell(
                      child: const Text("Delete this account!!!", style: TextStyle(fontSize: 15),),
                      onTap: () {
                        AuthService.deleteUser(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: (){
                _logoutDialog();
              },
              icon: const Icon(Icons.logout),
              splashRadius: 25,
          )
        ],
      ),
      body: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
        return listOfItems(index);
      }
    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(message: 'new', index: '0',))).then((value) {
            if(value.toString() == 'done') {
              setState(() {
                _loadPosts();
              });
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget listOfItems(int index) {
    return GestureDetector(
      onTap: () async{
        await Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(message: 'edit', index: index.toString(),))).then((value){
          if(value.toString() == 'done') {
            setState(() {
              _loadPosts();
            });
          }
        });
      },
      onLongPress: () {
        _deleteDialog(key: posts[index].key);
        _loadPosts();
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 280,
              width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: posts[index].image_url, fit: BoxFit.cover,
                    placeholder: (context, url) => Lottie.asset('assets/animations/loading.json', height: 280, animate: true),
                  ),
                )
            ),

            const SizedBox(height: 10,),
            Text(posts[index].title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            const SizedBox(height: 5,),
            Text(posts[index].content),
            const Divider(color: Colors.grey,),
          ],
        ),
      ),
    );
  }

  void _deleteDialog({required key}) {
    showDialog (
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Are you sure to delete this post?", style: TextStyle(fontSize: 17),),
          actions: [
            TextButton(
              onPressed: (){
                setState(() {
                  _deletePost(key: key);
                });
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red),),
            ),
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },

    );
  }

  void _logoutDialog() {
    showDialog (
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Are you sure to logout?", style: TextStyle(fontSize: 17),),
          actions: [
            TextButton(
              onPressed: (){
                AuthService.singOutUser(context);
                Navigator.pushReplacementNamed(context, SignInPage.id);
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },

    );
  }
}
