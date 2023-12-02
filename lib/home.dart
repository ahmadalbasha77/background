import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import 'map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? busData;

  static Future<Map<String, dynamic>?> GetBus() async {
    String tt =
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVc2VySUQiOiJNYTN5a3pObWlDS2wzZlIvU0lVd3N3PT0iLCJyb2xlIjoiQnVzIiwibmJmIjoxNzAxNDU1NDg0LCJleHAiOjE3MDE1NTI2ODQsImlhdCI6MTcwMTQ1NTQ4NH0.yrWnBh-K7qFOlj7greu_asw1GA095orMI75eEwdAC5I';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    print('==============================================');
    print(token);
    print('==============================================');

    Response response = await get(Uri.http(URL, '/api/Bus/GetBusData'),
        headers: {'Authorization': tt});
    print(response.body);
    if (response.statusCode == 200) {
      print('****************200*****************************************');
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      print('lllll');
      return null;
    }
  }

  Future<void> fetchData() async {
    var data = await GetBus();
    if (data != null) {
      setState(() {
        busData = data;
      });
    }
  }

  @override
  void initState() {
    fetchData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: busData == null
            ? CircularProgressIndicator()
            : Column(children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide.none,
                        left: BorderSide.none,
                        top: BorderSide(color: Colors.black26),
                        bottom: BorderSide(color: Colors.black26)),
                  ),
                  child: ListTile(
                    title: Text('Name : ', style: TextStyle(fontSize: 20)),
                    subtitle: Text(busData?['username'],
                        style: TextStyle(fontSize: 17)),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide.none,
                        left: BorderSide.none,
                        top: BorderSide(color: Colors.black26),
                        bottom: BorderSide(color: Colors.black26)),
                  ),
                  child: ListTile(
                    title: Text('ID number : ', style: TextStyle(fontSize: 20)),
                    subtitle: Text(busData?['busNumberA'],
                        style: TextStyle(fontSize: 17)),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide.none,
                        left: BorderSide.none,
                        top: BorderSide(color: Colors.black26),
                        bottom: BorderSide(color: Colors.black26)),
                  ),
                  child: ListTile(
                    title:
                        Text('Vehicle ID : ', style: TextStyle(fontSize: 20)),
                    subtitle: Text(busData?['busNumberB'],
                        style: TextStyle(fontSize: 17)),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide.none,
                        left: BorderSide.none,
                        top: BorderSide(color: Colors.black26),
                        bottom: BorderSide(color: Colors.black26)),
                  ),
                  child: ListTile(
                    title:
                        Text('Phone number : ', style: TextStyle(fontSize: 20)),
                    subtitle: Text(busData?['phoneNumber'],
                        style: TextStyle(fontSize: 17)),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide.none,
                        left: BorderSide.none,
                        top: BorderSide(color: Colors.black26),
                        bottom: BorderSide(color: Colors.black26)),
                  ),
                  child: ListTile(
                    title: Text('Working hours : ',
                        style: TextStyle(fontSize: 20)),
                    subtitle: Text(
                        '${busData?['workingHoursStart'].toString()} - ${busData?['workingHoursEnd'].toString()}',
                        style: TextStyle(fontSize: 17)),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide.none,
                        left: BorderSide.none,
                        top: BorderSide(color: Colors.black26),
                        bottom: BorderSide(color: Colors.black26)),
                  ),
                  child: ListTile(
                    title: Text('Line name : ', style: TextStyle(fontSize: 20)),
                    subtitle: Text(busData?['lineName'],
                        style: TextStyle(fontSize: 17)),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide.none,
                        left: BorderSide.none,
                        top: BorderSide(color: Colors.black26),
                        bottom: BorderSide(color: Colors.black26)),
                  ),
                  child: ListTile(
                    title: Text('Tracking : ', style: TextStyle(fontSize: 20)),
                    subtitle: Text('',
                        style:
                            TextStyle(fontSize: 17, color: Colors.green[700])),
                  ),
                ),
                SizedBox(
                  height: 70,
                ),
                Container(
                  width: 200,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(49, 44, 61, 1.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: () async {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MapTScreen(
                          lanLat: busData?['line'],
                          latLanStop: busData?['stops'],
                        ),
                      ));
                    },
                    child: Text(
                      "Show line",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ]),
      ),
    );
  }
}
