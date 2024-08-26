import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VehicleService extends ChangeNotifier {
  List<Vehicle> vehicles = [];
  bool isLoading = false;

  Future<void> fetchVehicles() async {
    isLoading = true;
    notifyListeners();

    try {
      final response =
          await http.get(Uri.parse('http://172.20.10.10:8000/api/ambulance'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('API Response: $data'); // Debugging statement
        vehicles = data.map((json) => Vehicle.fromJson(json)).toList();
        print('Parsed Vehicles: $vehicles'); // Debugging statement
      } else {
        print(
            'Failed to load vehicles with status code: ${response.statusCode}');
        throw Exception('Failed to load vehicles');
      }
    } catch (e) {
      // Handle any errors here
      print('Error fetching vehicles: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

class Vehicle {
  final int id;
  final int hospitalId;
  final String title;
  final String brand;
  final String overview;
  final double price;
  final String? year;
  final String plateNumber;
  final String fuel;
  final int capacity;
  final String image1;
  final String? image2;
  final String? image3;
  final String? image4;
  final int? seatingCapacity;
  final int airConditioner;
  final int powerDoorLocks;
  final int antiLockBrakingSystem;
  final int brakeAssist;
  final int powerSteering;
  final int driverAirbag;
  final int passengerAirbag;
  final int powerWindows;
  final int cdPlayer;
  final int centralLocking;
  final int crashSensor;
  final int leatherSeats;
  final String? regDate;
  final String? updationDate;
  final String createdAt;
  final String updatedAt;
  final String? status;

  Vehicle({
    required this.id,
    required this.hospitalId,
    required this.title,
    required this.brand,
    required this.overview,
    required this.price,
    required this.year,
    required this.plateNumber,
    required this.fuel,
    required this.capacity,
    required this.image1,
    required this.image2,
    required this.image3,
    required this.image4,
    required this.seatingCapacity,
    required this.airConditioner,
    required this.powerDoorLocks,
    required this.antiLockBrakingSystem,
    required this.brakeAssist,
    required this.powerSteering,
    required this.driverAirbag,
    required this.passengerAirbag,
    required this.powerWindows,
    required this.cdPlayer,
    required this.centralLocking,
    required this.crashSensor,
    required this.leatherSeats,
    required this.regDate,
    required this.updationDate,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      hospitalId: json['hospital_id'],
      title: json['title'],
      brand: json['brand'],
      overview: json['overview'],
      price: json['price'].toDouble(), // Parse price as double
      year: json['year'],
      plateNumber: json['plate_number']
          .toString(), // Ensure plateNumber is always a string
      fuel: json['fuel'],
      capacity: json['capacity'],
      image1: json['image1'],
      image2: json['image2'],
      image3: json['image3'],
      image4: json['image4'],
      seatingCapacity: json['seatingcapacity'],
      airConditioner: json['airconditioner'],
      powerDoorLocks: json['powerdoorlocks'],
      antiLockBrakingSystem: json['antilockbrakingsystem'],
      brakeAssist: json['brakeassist'],
      powerSteering: json['powersteering'],
      driverAirbag: json['driverairbag'],
      passengerAirbag: json['passengerairbag'],
      powerWindows: json['powerwindows'],
      cdPlayer: json['cdplayer'],
      centralLocking: json['centrallocking'],
      crashSensor: json['crashsensor'],
      leatherSeats: json['leatherseats'],
      regDate: json['regdate'],
      updationDate: json['updationdate'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      status: json['status'],
    );
  }

  @override
  String toString() {
    return 'Vehicle(id: $id, title: $title, brand: $brand)'; // Simplified for debugging
  }
}
