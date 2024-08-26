import 'package:flutter/material.dart';
import 'package:flutter_application_1/Services/VehicleService.dart'; // Correct import path
import 'package:provider/provider.dart';


class VehicleScreen extends StatefulWidget {
  const VehicleScreen({Key? key}) : super(key: key);

  @override
  _VehicleScreenState createState() => _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch vehicles when the screen is initialized
    Future.microtask(() {
      Provider.of<VehicleService>(context, listen: false).fetchVehicles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text('Ambulance'),
        backgroundColor: const Color(0xfffe9721),  // Set the AppBar color to orange
      ),
      body: Consumer<VehicleService>(
        builder: (context, vehicleService, child) {
          if (vehicleService.isLoading) {
            return const Center(
              child: CircularProgressIndicator(), // Show a loading indicator
            );
          } else if (vehicleService.vehicles.isEmpty) {
            return const Center(
              child: Text('No vehicle data available'), // Show a message when no data
            );
          } else {
            return ListView.builder(
              itemCount: vehicleService.vehicles.length,
              itemBuilder: (context, index) {
                final vehicle = vehicleService.vehicles[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: vehicle.image1.isNotEmpty
                          ? Image.network(
                              vehicle.image1,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.directions_car, size: 100),
                      title: Text(
                        vehicle.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Brand: ${vehicle.brand}'),
                          Text('Price: LKR ${vehicle.price.toStringAsFixed(2)}'),
                        ],
                      ),
                      onTap: () {
                        // Handle tapping on a vehicle item
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

