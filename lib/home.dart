import 'dart:convert';

import 'package:background/Data/apiURLs.dart';
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

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;

    Response response = await get(ApiURLs.getBusData,
        headers: {'Authorization': 'Bearer ' + token});
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  Future<void> fetchData() async {
    var data = await GetBus();
    if (data != null) {
      print("===============================================");
      print(data.toString());
      print("===============================================");
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
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: busData == null
            ? const CircularProgressIndicator()
            : Column(children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                        right: BorderSide.none,
                        left: BorderSide.none,
                        top: BorderSide(color: Colors.black26),
                        bottom: BorderSide(color: Colors.black26)),
                  ),
                  child: ListTile(
                    title: const Text('Name : ', style: TextStyle(fontSize: 20)),
                    subtitle: Text(busData?['username'],
                        style: TextStyle(fontSize: 17)),
                  ),
                ),
                // Container(
                //   decoration: const BoxDecoration(
                //     border: Border(
                //         right: BorderSide.none,
                //         left: BorderSide.none,
                //         top: BorderSide(color: Colors.black26),
                //         bottom: BorderSide(color: Colors.black26)),
                //   ),
                //   child: ListTile(
                //     title: const Text('ID number : ', style: TextStyle(fontSize: 20)),
                //     subtitle: Text(busData?['busNumberA'],
                //         style: const TextStyle(fontSize: 17)),
                //   ),
                // ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                        right: BorderSide.none,
                        left: BorderSide.none,
                        top: BorderSide(color: Colors.black26),
                        bottom: BorderSide(color: Colors.black26)),
                  ),
                  child: ListTile(
                    title:
                        const Text('Vehicle ID : ', style: TextStyle(fontSize: 20)),
                    subtitle: Text(busData?['busNumberA'] + '-' + busData?['busNumberB'],
                        style: const TextStyle(fontSize: 17)),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                        right: BorderSide.none,
                        left: BorderSide.none,
                        top: BorderSide(color: Colors.black26),
                        bottom: BorderSide(color: Colors.black26)),
                  ),
                  child: ListTile(
                    title:
                        const Text('Phone number : ', style: TextStyle(fontSize: 20)),
                    subtitle: Text(busData?['phoneNumber'],
                        style: const TextStyle(fontSize: 17)),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                        right: BorderSide.none,
                        left: BorderSide.none,
                        top: BorderSide(color: Colors.black26),
                        bottom: BorderSide(color: Colors.black26)),
                  ),
                  child: ListTile(
                    title: const Text('Working hours : ',
                        style: TextStyle(fontSize: 20)),
                    subtitle: Text(
                        '${extractTimeFromIsoString(busData?['workingHoursStart'].toString())} - ${extractTimeFromIsoString(busData?['workingHoursEnd'].toString())}',
                        style: const TextStyle(fontSize: 17)),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                        right: BorderSide.none,
                        left: BorderSide.none,
                        top: BorderSide(color: Colors.black26),
                        bottom: BorderSide(color: Colors.black26)),
                  ),
                  child: ListTile(
                    title: const Text('Line name : ', style: TextStyle(fontSize: 20)),
                    subtitle: Text(busData?['lineName'],
                        style: const TextStyle(fontSize: 17)),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                        right: BorderSide.none,
                        left: BorderSide.none,
                        top: BorderSide(color: Colors.black26),
                        bottom: BorderSide(color: Colors.black26)),
                  ),
                  child: ListTile(
                    title: const Text('Tracking : ', style: TextStyle(fontSize: 20)),
                    subtitle: Text('',
                        style:
                            TextStyle(fontSize: 17, color: Colors.green[700])),
                  ),
                ),
                const SizedBox(
                  height: 70,
                ),
                Container(
                  width: 200,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(49, 44, 61, 1.0),
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
                    child: const Text(
                      "Show line",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ]),
      ),
    );
  }


  String extractTimeFromIsoString(String? isoString) {
  // Parse ISO 8601 string to DateTime
  DateTime dateTime = DateTime.parse(isoString!);

  // Format DateTime to time string
  String timeString = "${dateTime.hour}:${dateTime.minute}:${dateTime.second}";

  return timeString;
}
}
