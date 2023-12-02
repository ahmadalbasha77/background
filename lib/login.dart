import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class Api {}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

String URL =
    'abnaleizischoolbuses-env.eba-2qsps2xf.eu-central-1.elasticbeanstalk.com';

Future<bool> LoginFun(BuildContext context,String Username, String Password) async {
  Response response = await post(Uri.http(URL, '/api/shared/LogInBus'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "Username": Username,
        "Password": Password,
        "BusNumber": "",
        "PhoneNumber": ""
      }));
  print(response.body);
  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    print(data['token']);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', data['token']);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => HomeScreen(),
    ));
    return true;
  } else {
    print('=================Error==================================');
    return false;
  }
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController user = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(49, 44, 61, 1.0),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: 250,
          ),
          Center(
            child: Text('LogIn',
                style: TextStyle(fontSize: 26, color: Colors.white)),
          ),
          SizedBox(
            height: 100,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: TextFormField(
              controller: user,
              style: TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                  suffixIcon: Icon(Icons.person),
                  hintStyle: TextStyle(color: Colors.black),
                  hintText: 'user55',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  filled: true,
                  fillColor: Color.fromRGBO(243, 242, 238, 1),
                  labelText: "User name, phone number",
                  labelStyle: TextStyle(color: Colors.black45)),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: TextFormField(
              controller: password,
              style: TextStyle(color: Colors.black87),
              obscureText: true,
              decoration: InputDecoration(
                  suffixIcon: Icon(Icons.lock),
                  hintStyle: TextStyle(color: Colors.black),
                  hintText: '**** ****',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  filled: true,
                  fillColor: Color.fromRGBO(243, 242, 238, 1),
                  labelText: "password",
                  labelStyle: TextStyle(color: Colors.black45)),
            ),
          ),
          SizedBox(
            height: 100,
          ),
          Container(
            width: 270,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () async {
                LoginFun(context,user.text, password.text);
              },
              child: Text(
                "Login",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
