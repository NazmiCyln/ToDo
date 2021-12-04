import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/auth.dart';
import 'package:todo/gorevekle.dart';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({Key? key}) : super(key: key);

  @override
  _AnaSayfaState createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  //Mevcut kullanıcı uidsi
  late String mevcutKullaniciUidTutucu;

  final dbRef = FirebaseDatabase.instance.reference().child("Gorevler");

  AuthService _authService = AuthService();

  //Ana sayfa ilk açıldığında hangi kullanıcı giriş yapmışsa onun uidsini alsın
  @override
  void initState() {
    // TODO: implement initState
    mevcutKullaniciUidAl();
    super.initState();
  }

  void mevcutKullaniciUidAl() async {
    //Veri tabanından udi yi al
    var mevcutKullanici = FirebaseAuth.instance.currentUser;

    setState(() {
      mevcutKullaniciUidTutucu = mevcutKullanici!.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF45BD98),
        title: const Text(
          "ToDo",
          style: TextStyle(
            color: Color(0xFF531D11),
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _authService.signOut();
            },
            icon: const Icon(
              Icons.exit_to_app,
              color: Color(0xFF531D11),
              size: 30,
            ),
          ),
        ],
      ),
      body: Container(
        //Ekranın boyutlarını al
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        //StreamBuilder ile firebaseden verileri çekiyoruz
        child: StreamBuilder<QuerySnapshot>(
          //mevcut kullanıcının görevlerim altındaki tüm verileri al
          stream: FirebaseFirestore.instance
              .collection("Gorevler")
              .doc(mevcutKullaniciUidTutucu)
              .collection("Gorevlerim")
              .snapshots(),
          builder: (context, veriTabaniVerilerim) {
            //veriTabaniVerilerim iletişim kurmaya çalışıyorsa centerda yüklendiğine dair progress döndür
            if (veriTabaniVerilerim.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            //Listele
            else {
              //veriTabanıVerilerinin içindeki verileri al alinanVeriye aktar
              var alinanVeri = veriTabaniVerilerim.data!.docs;
              return ListView.builder(
                itemCount: alinanVeri.length,
                itemBuilder: (BuildContext context, int index) {
                  //Eklenme zamanı tutucu
                  var eklenmeZamani =
                      (alinanVeri[index]["tamZaman"] as Timestamp).toDate();

                  return Container(
                    margin: const EdgeInsets.fromLTRB(10, 5, 10, 1),
                    height: 90,
                    decoration: BoxDecoration(
                      color: const Color(0xFF45BD98),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        //değerleri ilgili yerde kenarlara dağıt
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            //Değerleri ilgili yerde sola hizala
                            crossAxisAlignment: CrossAxisAlignment.start,
                            //Dikey olarak ortala
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Text(
                                alinanVeri[index]["ad"],
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF452E03),
                                ),
                              ),
                              Text(
                                DateFormat.yMd().add_jm().format(eklenmeZamani),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  color: Color(0xFF633F03),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            //Değerleri ilgili yerde sola hizala
                            crossAxisAlignment: CrossAxisAlignment.start,
                            //Dikey olarak ortala
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                alinanVeri[index]["sonTarih"],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF523501),
                                ),
                              )
                            ],
                          ),
                          IconButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection("Gorevler")
                                  .doc(mevcutKullaniciUidTutucu)
                                  .collection("Gorevlerim")
                                  .doc(
                                    alinanVeri[index]["zaman"],
                                  )
                                  .delete();
                            },
                            icon: const Icon(
                              Icons.delete,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GorevEkle()),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: const Color(0xFF45BD98),
      ),
    );
  }
}
