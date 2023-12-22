import 'dart:async';
import 'dart:convert';

import 'package:background/Data/apiURLs.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:background_location/background_location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MapTScreen extends StatefulWidget {
  List lanLat;
  List latLanStop;

  MapTScreen({super.key, required this.lanLat, required this.latLanStop});

  @override
  State<MapTScreen> createState() => _MapTScreenState();
}

class _MapTScreenState extends State<MapTScreen> {
  Future<void> _initBackgroundLocation() async {
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
          const Duration interval = Duration(seconds: 30);
          locationTimer = Timer.periodic(interval, (Timer timer) {
            // sendDelegateStatusApi(location);

            // Handle the location updates here.
          });
        }
      });

      // Start background location tracking
      BackgroundLocation.startLocationService();
    } else {
      // Permission denied. Handle accordingly.
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
        markerId: const MarkerId('1'),
        position: LatLng(cl.latitude, cl.longitude),
        icon: await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(size: Size(12, 12)),
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token,
    };

    dynamic body = jsonEncode({
      'Latitude': locationDto.latitude,
      'Longitude': locationDto.longitude,
    });


    final response =
        await http.post(ApiURLs.postBusLocation, headers: headers, body: body);
    if (response.statusCode == 200) {
      return true;
    } else {
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
    //getPolyline();
    //addStopMarker();
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
