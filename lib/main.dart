import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo/anasayfa.dart';
import 'package:todo/kayitekrani.dart';
import 'kayitekrani.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Yapilacaklar());
}

class Yapilacaklar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xFF45BD98),
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, kullaniciVerisi) {
          if (kullaniciVerisi.hasData) {
            return AnaSayfa();
          }
          else {
            return KayitEkrani();
          }
        },
      ),
    );
  }
}
