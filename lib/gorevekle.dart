import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo/auth.dart';

class GorevEkle extends StatefulWidget {
  const GorevEkle({Key? key}) : super(key: key);

  @override
  _GorevEkleState createState() => _GorevEkleState();
}

class _GorevEkleState extends State<GorevEkle> {
  //verileri alıyor
  TextEditingController adAlici = TextEditingController();
  TextEditingController tarihAlici = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF45BD98),
        title: const Text(
          "Görev Ekle",
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 61,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 12, 10, 0),
              child: TextFormField(
                controller: adAlici,
                decoration: const InputDecoration(
                  labelText: "Görev Adı",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          Container(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 12, 10, 0),
              child: TextFormField(
                controller: tarihAlici,
                decoration: const InputDecoration(
                  labelText: "Son Tarih",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 5),
            height: 65,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                //Görevi Firebase'e kaydet
                verileriEkle();
              },
              child: const Text(
                "Görevi Ekle",
                style: TextStyle(fontSize: 17),
              ),
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF45BD98),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Verileri ekleme
  verileriEkle() async {
    AuthService _authService = AuthService();

    _authService.veriEkle(adAlici.text, tarihAlici.text);

    Fluttertoast.showToast(msg: "Görev eklendi");

    adAlici.clear();
    tarihAlici.clear();
  }
}
