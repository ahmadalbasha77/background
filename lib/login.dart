import 'package:flutter/material.dart';

import 'home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(49, 44, 61, 1.0),
      body: Column(children: [
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
            style: TextStyle(color: Colors.black87),
            obscureText: true,
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
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ));
            },
            child: Text(
              "Login",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
        ),
      ]),
    );
  }
}
