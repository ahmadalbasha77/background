import 'package:flutter/material.dart';

import 'map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      body: Column(children: [
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
            subtitle: Text('ahmad albasha', style: TextStyle(fontSize: 17)),
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
            subtitle: Text('200054848888899', style: TextStyle(fontSize: 17)),
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
            title: Text('Vehicle ID : ', style: TextStyle(fontSize: 20)),
            subtitle: Text('24-221166', style: TextStyle(fontSize: 17)),
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
            title: Text('Phone number : ', style: TextStyle(fontSize: 20)),
            subtitle: Text('07852123366', style: TextStyle(fontSize: 17)),
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
            title: Text('Working hours : ', style: TextStyle(fontSize: 20)),
            subtitle: Text('16:00 - 19:00', style: TextStyle(fontSize: 17)),
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
            subtitle: Text('amman', style: TextStyle(fontSize: 17)),
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
            subtitle: Text('Tracked',
                style: TextStyle(fontSize: 17, color: Colors.green[700])),
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
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            onPressed: () async {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MapTScreen(),
              ));
            },
            child: Text(
              "Show line",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ]),
    );
  }
}
