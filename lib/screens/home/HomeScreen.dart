import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/components/glowing_button.dart';
import 'package:flutter_application_1/screens/Tracking/tracking_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_application_1/Services/HospitalService.dart';
import 'package:flutter_application_1/components/drawer/custom_drawer.dart';
import 'package:flutter_application_1/services/AuthService.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController mapController;
  LatLng? _currentPosition;
  BitmapDescriptor? customMarkerIcon;
  bool _isMapLoading = true;
  bool _areHospitalsLoading = true;
  String _userName = '';
  String _userMobile = '';
  int _userId = 0;
  int progress = 0;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadCustomMarker();
    _getUserData(); // Call method to fetch user data
    Future.microtask(() {
      Provider.of<HospitalService>(context, listen: false)
          .fetchHospitals()
          .then((_) {
        setState(() {
          _areHospitalsLoading = false;
        });
      });
    });
  }

  Future<void> _getUserData() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    Map<String, dynamic>? userData = await authService.getUserSpecificData();
    setState(() {
      _userName = userData?['name'] ?? '';
      _userMobile = userData?['contact_number'] ?? '';
      _userId = userData?['id'] ?? 0;
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isMapLoading = false;
      });
    } catch (e) {
      print("Error getting current location: $e");
      setState(() {
        _isMapLoading = false;
      });
    }
  }

  Future<void> _loadCustomMarker() async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/emergency.png', 100);
    customMarkerIcon = BitmapDescriptor.fromBytes(markerIcon);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    final FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<void> _createEmergencyBooking() async {
    if (_currentPosition == null) {
      print("Current position is null");
      return;
    }

    String name = _userName;
    String mobile = _userMobile;
    int userId = _userId;
    int hospitalId = 1;

    final url = Uri.parse('http://172.20.10.10:8000/api/emergency-booking');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'mobile': mobile,
        'latitude': _currentPosition!.latitude,
        'longitude': _currentPosition!.longitude,
        'hospital_id': hospitalId,
        'user_id': userId,
        'progress': 0,
      }),
    );

    if (response.statusCode == 201) {
      print('Emergency booking created successfully');
      // Assuming the response body contains the created booking data
      jsonDecode(response.body);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TrackingPage(),
        ),
      );
    } else {
      print('Failed to create booking. Error: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthService>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      drawer: const CustomDrawer(),
      body: Stack(
        children: [
          Consumer<HospitalService>(
            builder: (context, hospitalService, child) {
              if (_isMapLoading || _areHospitalsLoading) {
                return const Center(
                  child:
                      CircularProgressIndicator(), // Show a loading indicator
                );
              } else if (hospitalService.hospitals.isEmpty) {
                return const Center(
                  child: Text(
                      'No hospitals available'), // Show a message when no data
                );
              } else {
                return GoogleMap(
                  initialCameraPosition: _currentPosition != null
                      ? CameraPosition(
                          target: _currentPosition!,
                          zoom: 12,
                        )
                      : const CameraPosition(
                          target: LatLng(0, 0),
                          zoom: 12,
                        ),
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                  },
                  markers: {
                    ...hospitalService.hospitals.map((hospital) => Marker(
                          markerId: MarkerId(hospital.id.toString()),
                          position:
                              LatLng(hospital.latitude, hospital.longitude),
                          infoWindow: InfoWindow(
                            title: hospital.name,
                            snippet:
                                hospital.location ?? 'No address available',
                          ),
                        )),
                    if (_currentPosition != null)
                      Marker(
                        markerId: const MarkerId('currentLocation'),
                        position: _currentPosition!,
                        icon: customMarkerIcon!,
                        infoWindow: const InfoWindow(title: 'Your Location'),
                      ),
                  },
                );
              }
            },
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: SizedBox(
              width: double.infinity,
              child: GlowingButton(
                color1: Colors.orange,
                color2: Colors.red,
                onTap: _createEmergencyBooking,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
