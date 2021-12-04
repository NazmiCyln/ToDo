import 'package:flutter/material.dart';
import 'auth.dart';

class KayitFormu extends StatefulWidget {
  const KayitFormu({Key? key}) : super(key: key);

  @override
  _KayitFormuState createState() => _KayitFormuState();
}

//Kayıtlı kullanıcı olma durumu değişkeni global değişken
bool kayitDurumu = false;

//kayıt parametreleri
late String kullaniciAdi, email, sifre;

class _KayitFormuState extends State<KayitFormu> {
  //Doğrulama Anahtarı
  var _dogrulamaAnahtari = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _dogrulamaAnahtari,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            Container(
              height: 170,
              child: Image.asset("images/todo.jpg"),
            ),
            if (!kayitDurumu)
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: TextFormField(
                  onChanged: (alinanAd) {
                    kullaniciAdi = alinanAd;
                  },
                  //ad alanı boş ise hata ver, doluysa birşey yapma
                  validator: (alinanAd) {
                    return alinanAd!.isEmpty
                        ? "Ad kısmı boş bırakılamaz"
                        : null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Kullanıcı adı giriniz",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: TextFormField(
                onChanged: (alinanEmail) {
                  email = alinanEmail;
                },
                //email alanında @ yok ise hata ver, var ise birşey yapma
                validator: (alinanEmail) {
                  return alinanEmail!.contains("@") ? null : "Geçersiz Email";
                },
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email giriniz",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: TextFormField(
                onChanged: (alinanSifre) {
                  sifre = alinanSifre;
                },
                validator: (alinanSifre) {
                  return alinanSifre!.length >= 6
                      ? null
                      : "Şifre 6 karaktenden az olamaz";
                },
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Şifre giriniz",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Container(
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    kayitEkle();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF45BD98),
                    shadowColor: Colors.black,
                  ),
                  child: kayitDurumu
                      ? const Text(
                          "Giris Yap",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        )
                      : const Text(
                          "Kaydol",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    kayitDurumu = !kayitDurumu;
                  });
                },
                child: kayitDurumu
                    ? const Text(
                        "Hesabım yok",
                        style: TextStyle(
                          color: Color(0xFF5E4505),
                          fontSize: 17,
                        ),
                      )
                    : const Text(
                        "Hesabım var",
                        style: TextStyle(
                          color: Color(0xFF5E4505),
                          fontSize: 17,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Veriyi doğrulayıp kullanıcı kaydı yap
  void kayitEkle() async {
    if (_dogrulamaAnahtari.currentState!.validate()) {
      formuTeslimEt(kullaniciAdi, email, sifre);
    }
  }
}

formuTeslimEt(String kullaniciAdi, String email, String sifre) async {
  AuthService _authService = AuthService();

  //kayıt durumu true ise giriş yap
  if (kayitDurumu) {
    _authService.signIn(email, sifre);
  }
  //Kayit durumu false ise kaydol
  else {
    _authService.createPerson(kullaniciAdi, email, sifre);
  }
}
