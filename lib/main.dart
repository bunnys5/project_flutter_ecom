import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'shop.dart';

void main() {
  runApp(MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usname = TextEditingController();
  TextEditingController pws = TextEditingController();
  bool showPassword = true;

  var resultLogin = '', login = '';
  final IP = '10.160.96.72';

  void checkLogin(String username, String password) async {
    try {
      String url = "http://${IP}/appsale/login.php?us=$username&pw=$password";

      print(url);
      var response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
        'Charset': 'utf-8'
      });
      if (response.statusCode == 200) {
        var rs = response.body.replaceAll('ï»¿', '');
        var rsLogin = convert.jsonDecode(rs);

        setState(() {
          login = rsLogin['login'];
          if (login.contains('OK')) {
            resultLogin = 'Login ถูกต้อง';

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MenuPage(
                        user_name: usname.text,
                      )),
            );
          } else {
            resultLogin = 'Login ผิดพลาด';
          }
        });
        // print(_lsProducts?[0].title);
      } else {
        print('Request failed with status: ${response.statusCode}.');
        throw Exception('Failed to load Data');
      }
    } catch (e) {
      print(e);
    }
  } //searchBusinessByGroup

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.store,
          color: Colors.white,
        ),
        title: Text('ร้านค้าของฉัน'),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Image.asset(
                  'assets/logo.png',
                  width: 150,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                  controller: usname,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    suffixIcon: Icon(Icons.people_alt),
                    // border: OutlineInputBorder(
                    //     borderSide: BorderSide(color: Colors.blue)),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                    controller: pws,
                    obscureText: showPassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      helperText: 'forget password',
                      helperStyle: TextStyle(color: Colors.blue),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                          icon: showPassword
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility)),
                    )),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10)),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      checkLogin(usname.text, pws.text);
                      //           Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => const MenuPage()),
                      // );
                    });
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  '$resultLogin',
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          )),
    );
  }
}
