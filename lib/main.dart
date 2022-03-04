import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:noteappwithfirebase/pages/detail_page.dart';
import 'package:noteappwithfirebase/pages/home_page.dart';
import 'package:noteappwithfirebase/pages/sign_in_page.dart';
import 'package:noteappwithfirebase/pages/sign_up_page.dart';
import 'package:noteappwithfirebase/services/hive_service.dart';

void main() async{
  await Hive.initFlutter();
  await Hive.openBox(HiveDB.DB_NAME);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(

  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    _checkLogin() {
      final FirebaseAuth  _auth = FirebaseAuth.instance;
      final User? user = _auth.currentUser;
      if (user == null) {
        // HiveDB.loadUserId().then((value) {
        //   HiveDB.removeUser(user!.uid);
        // });
        return const SignInPage();
      }
      HiveDB.storeUserId(user.uid);
      return const HomePage();
    }

    return MaterialApp(
      title: 'Note App with FireBase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _checkLogin(),
      routes: {
        HomePage.id: (context) => const HomePage(),
        SignInPage.id: (context) => const SignInPage(),
        SignUpPage.id: (context) => const SignUpPage(),
        // DetailPage.id: (context) => const DetailPage(),
      },
    );
  }
}