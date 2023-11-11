import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:background_location/background_location.dart';
import 'package:permission_handler/permission_handler.dart';

class MapTScreen extends StatefulWidget {
  const MapTScreen({super.key});

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
        icon: '@mipmap/ic_launcher',
      );

      BackgroundLocation.getLocationUpdates((location) {
        print('Location: ${location.latitude}, ${location.longitude}');
        // Handle the location updates here.
      });

      // Start background location tracking
      BackgroundLocation.startLocationService();
    } else {
      // Permission denied. Handle accordingly.
      print('Location permission denied.');
    }
  }

  late Position cl;
  late CameraPosition _kGooglePlex ;

  // Initialize an empty marker set
  Set<Marker> marker = {};

  Future<void> getPosition() async {
    bool service;
    service = await Geolocator.isLocationServiceEnabled();
    LocationPermission per = LocationPermission.denied; // Initialize with a default value

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
      marker.add(
        Marker(
          draggable: true,
          markerId: MarkerId('1'),
          position: LatLng(cl.latitude, cl.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      );
      // Move the camera to the current location
      _kGooglePlex = CameraPosition(
        zoom: 14.5,
        target: LatLng(cl.latitude, cl.longitude),
      );
    }

    setState(() {});
  }

  @override
  void initState() {
    getPosition();
    _initBackgroundLocation();
    super.initState();
  }

  void dispose() {
    // Stop background location service when the app is disposed
    BackgroundLocation.stopLocationService();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 750,
              width: double.infinity,
              child: GoogleMap(
                markers: marker,
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {},
                onTap: (argument) {
                  // Handle marker tap or removal here
                },
              ),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
