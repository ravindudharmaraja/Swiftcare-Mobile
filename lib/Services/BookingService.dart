import 'dart:convert';
import 'package:flutter/foundation.dart'; // Import foundation for ChangeNotifier
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BookingService extends ChangeNotifier {
  // Extend ChangeNotifier
  final String baseUrl = 'http://172.20.10.10:8000/api';

  Future<String?> get token async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<Map<String, dynamic>>> fetchEmergencyBookings() async {
    final response = await http.get(
      Uri.parse('$baseUrl/user-emergency-bookings'),
      headers: <String, String>{
        'Authorization': 'Bearer ${await token}',
      },
    );

    if (response.statusCode == 200) {
      // Parse the JSON response
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load emergency bookings');
    }
  }
}
