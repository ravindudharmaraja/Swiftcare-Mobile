import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserService extends ChangeNotifier {
  User? user;
  bool isLoading = false;

  Future<void> fetchUser() async {
    isLoading = true;
    notifyListeners();

    try {
      final response =
          await http.get(Uri.parse('http://172.20.10.10:8000/api/user'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('API Response: $data'); // Debugging statement
        if (data.isNotEmpty) {
          user = User.fromJson(data[0]); // Fetch the first user from the list
          print('Parsed User: $user'); // Debugging statement
        } else {
          print('No user data available in the response');
        }
      } else {
        print('Failed to load user with status code: ${response.statusCode}');
        throw Exception('Failed to load user');
      }
    } catch (e) {
      // Handle any errors here
      print('Error fetching user: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String contactNumber;
  final String address;
  final String? profile; // Make profile nullable

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.contactNumber,
    required this.address,
    this.profile, // Make profile nullable
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      contactNumber: json['contact_number'],
      address: json['address'],
      profile: json['profile'], // Handle null value
    );
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email}'; // Simplified for debugging
  }
}
