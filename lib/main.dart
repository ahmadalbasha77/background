import 'package:background/error.dart';
import 'package:background/login.dart';
import 'package:background/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Al Massar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: checkToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // You can show a loading indicator here if needed
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Handle errors
            return ErrorScreen();
          } else {
            // Check the value of the token and navigate accordingly
            return snapshot.data != null && snapshot.data != ''
                ? HomeScreen()
                : LoginScreen();
          }
        },
      ),
    );
  }

  Future<String?> checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
