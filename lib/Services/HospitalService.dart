import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HospitalService extends ChangeNotifier {
  List<Hospital> hospitals = [];
  bool isLoading = false;

  Future<void> fetchHospitals() async {
    isLoading = true;
    notifyListeners();

    try {
      final response =
          await http.get(Uri.parse('http://172.20.10.10:8000/api/hospitals'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('API Response: $data'); // Debugging statement
        hospitals = data.map((json) => Hospital.fromJson(json)).toList();
        print('Parsed Hospitals: $hospitals'); // Debugging statement
      } else {
        print(
            'Failed to load hospitals with status code: ${response.statusCode}');
        throw Exception('Failed to load hospitals');
      }
    } catch (e) {
      // Handle any errors here
      print('Error fetching hospitals: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

class Hospital {
  final int id;
  final String name;
  final String email;
  final String? location;
  final String? contactNumber;
  final String? capacity;
  final String? servicesOffered;
  final String? emailVerifiedAt;
  final String createdAt;
  final String updatedAt;
  final double longitude;
  final double latitude;
  final String? profile;

  Hospital({
    required this.id,
    required this.name,
    required this.email,
    this.location,
    this.contactNumber,
    this.capacity,
    this.servicesOffered,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.longitude,
    required this.latitude,
    this.profile,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      location: json['location'],
      contactNumber: json['contact_number'],
      capacity: json['capacity'],
      servicesOffered: json['services_offered'],
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      longitude: double.parse(json['longitude']),
      latitude: double.parse(json['latitude']),
      profile: json['profile'],
    );
  }

  @override
  String toString() {
    return 'Hospital{id: $id, name: $name, address: $location}'; // Simplified for debugging
  }
}
