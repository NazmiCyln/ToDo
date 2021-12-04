import 'package:flutter/material.dart';
import 'kayitformu.dart';

class KayitEkrani extends StatefulWidget {
  const KayitEkrani({Key? key}) : super(key: key);

  @override
  _KayitEkraniState createState() => _KayitEkraniState();
}

class _KayitEkraniState extends State<KayitEkrani> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF45BD98),
        title: Text("Kayıt Ekranı"),
        centerTitle: true,
      ),
      body: KayitFormu(),
    );
  }
}
