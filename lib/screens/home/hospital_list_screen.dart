import 'package:flutter/material.dart';
import 'package:flutter_application_1/Services/HospitalService.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HospitalsScreen extends StatefulWidget {
  const HospitalsScreen({Key? key}) : super(key: key);

  @override
  _HospitalsScreenState createState() => _HospitalsScreenState();
}

class _HospitalsScreenState extends State<HospitalsScreen> {
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    // Fetch hospitals when the screen is initialized
    Future.microtask(() {
      Provider.of<HospitalService>(context, listen: false).fetchHospitals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospitals'),
      ),
      body: Consumer<HospitalService>(
        builder: (context, hospitalService, child) {
          if (hospitalService.isLoading) {
            return const Center(
              child: CircularProgressIndicator(), // Show a loading indicator
            );
          } else if (hospitalService.hospitals.isEmpty) {
            return const Center(
              child: Text('No hospitals available'), // Show a message when no data
            );
          } else {
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  hospitalService.hospitals[0].latitude,
                  hospitalService.hospitals[0].longitude,
                ),
                zoom: 12,
              ),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              markers: Set<Marker>.of(
                hospitalService.hospitals.map((hospital) => Marker(
                  markerId: MarkerId(hospital.id.toString()),
                  position: LatLng(hospital.latitude, hospital.longitude),
                  infoWindow: InfoWindow(
                    title: hospital.name,
                    snippet: hospital.location ?? 'No address available',
                  ),
                )),
              ),
            );
          }
        },
      ),
    );
  }
}
