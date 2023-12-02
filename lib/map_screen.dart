import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:background_location/background_location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class MapTScreen extends StatefulWidget {
  List lanLat;
  List latLanStop;

  MapTScreen({super.key, required this.lanLat, required this.latLanStop});

  @override
  State<MapTScreen> createState() => _MapTScreenState();
}

class _MapTScreenState extends State<MapTScreen> {
  Future<void> _initBackgroundLocation() async {
    print('++++++++++++++++++++++++++++++++++++++++++++++');
    // Request location permissions
    var status = await Permission.location.request();
    if (status.isGranted) {
      // Initialize BackgroundLocation
      BackgroundLocation.setAndroidNotification(
        title: 'Background Location',
        message: 'Location is being tracked in the background.',
        icon: 'image/bus.png',
      );
      Timer? locationTimer;

      BackgroundLocation.getLocationUpdates((location) {
        if (locationTimer == null) {
          print('++++++++++++++');
          const Duration interval = Duration(seconds: 30);
          locationTimer = Timer.periodic(interval, (Timer timer) {
            // sendDelegateStatusApi(location);
            print('=======================');
            print('Location: ${location.latitude}, ${location.longitude}');

            // Handle the location updates here.
          });
        }
      });

      // Start background location tracking
      BackgroundLocation.startLocationService();
    } else {
      // Permission denied. Handle accordingly.
      print('Location permission denied.');
    }
  }

  CameraPosition? _kGooglePlex;

  Polyline? _polyline;

  // Initialize an empty marker set
  Set<Marker> marker = {};

  Future<void> getPosition() async {
    Position? cl;
    bool service;
    service = await Geolocator.isLocationServiceEnabled();
    LocationPermission per =
        LocationPermission.denied; // Initialize with a default value

    try {
      per = await Geolocator.checkPermission();
      if (per == LocationPermission.denied) {
        per = await Geolocator.requestPermission();
        // Display a CircularProgressIndicator when requesting permission
        showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        );
      }
    } catch (e) {
      print("Error checking or requesting permission: $e");
    }

    if (service && per == LocationPermission.whileInUse) {
      cl = await Geolocator.getCurrentPosition();
      marker.add(Marker(
        draggable: true,
        markerId: MarkerId('1'),
        position: LatLng(cl.latitude, cl.longitude),
        icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(12, 12)),
          // Adjust the size as needed
          'image/bus.png',
        ),
      ));
      // Move the camera to the current location
      _kGooglePlex = CameraPosition(
        zoom: 14.5,
        target: LatLng(cl.latitude, cl.longitude),
      );
    }

    setState(() {});
  }

  addStopMarker() async {
    marker.add(
      Marker(
        draggable: true,
        markerId: MarkerId('2'),
        position: LatLng(widget.latLanStop[0]['latitude'],
            widget.latLanStop[0]['longitude']),
        icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(12, 12)), // Adjust the size as needed
          'image/stop.png',
        ),
      ),
    );
    marker.add(
      Marker(
        draggable: true,
        markerId: MarkerId('3'),
        position: LatLng(widget.latLanStop[1]['latitude'],
            widget.latLanStop[1]['longitude']),
        icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(12, 12)), // Adjust the size as needed
          'image/stop.png',
        ),
      ),
    );
    marker.add(
      Marker(
        draggable: true,
        markerId: MarkerId('4'),
        position: LatLng(widget.latLanStop[2]['latitude'],
            widget.latLanStop[2]['longitude']),
        icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(12, 12)), // Adjust the size as needed
          'image/stop.png',
        ),
      ),
    );
  }

  static Future<bool> sendDelegateStatusApi(Location locationDto) async {
    String tt =
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVc2VySUQiOiJNYTN5a3pObWlDS2wzZlIvU0lVd3N3PT0iLCJyb2xlIjoiQnVzIiwibmJmIjoxNzAxNDU1NDg0LCJleHAiOjE3MDE1NTI2ODQsImlhdCI6MTcwMTQ1NTQ4NH0.yrWnBh-K7qFOlj7greu_asw1GA095orMI75eEwdAC5I';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': tt,
    };

    dynamic body = jsonEncode({
      'Latitude': locationDto.latitude,
      'Longitude': locationDto.longitude,
    });

    //print("FGS: LOCSEND: Sending Location: $body, token: $token");

    final response = await http.post(
        Uri.http(
            "abnaleizischoolbuses-env.eba-2qsps2xf.eu-central-1.elasticbeanstalk.com",
            "/api/BusLocation/PostBusLocation"),
        headers: headers,
        body: body);
    print("FGS: LOCSEND: RESPONSE CODE: " + response.statusCode.toString());
    print("FGS: LOCSEND: RESPONSE BODY: " + response.body);
    if (response.statusCode == 200) {
      print("FGS: LOCSEND: SEND Status Success");
      return true;
    } else {
      print("FGS: LOCSEND: SEND Status Fail");
      return false;
    }
  }

  getPolyline() {
    // Create a polyline from current position to the destination
    _polyline = Polyline(
      polylineId: PolylineId('polyline'),
      color: Colors.blue,
      width: 5,
      points: [
        LatLng(widget.lanLat[0]['latitude'], widget.lanLat[0]['longitude']),
        LatLng(widget.lanLat[1]['latitude'], widget.lanLat[1]['longitude']),
        LatLng(widget.lanLat[2]['latitude'], widget.lanLat[2]['longitude'])
      ],
    );
  }

  @override
  void initState() {
    getPosition();
    _initBackgroundLocation();
    getPolyline();
    addStopMarker();
    super.initState();
  }

  @override
  void dispose() {
    // Stop background location service when the app is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _kGooglePlex != null
                  ? GoogleMap(
                      polylines: _polyline != null
                          ? Set<Polyline>.from([_polyline!])
                          : {},
                      markers: marker,
                      mapType: MapType.normal,
                      initialCameraPosition: _kGooglePlex!,
                      onMapCreated: (GoogleMapController controller) {},
                      onTap: (argument) {
                        // Handle marker tap or removal here
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),

          ],
        ),
      ),
    );
  }
}
