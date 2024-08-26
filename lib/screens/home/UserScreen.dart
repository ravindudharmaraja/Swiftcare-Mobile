import 'package:flutter/material.dart';
import 'package:flutter_application_1/Services/AuthService.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final AuthService authService = AuthService();
  Map<String, dynamic>? userData;
  
  var _logout;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    try {
      final data = await authService.getUserSpecificData();
      setState(() {
        userData = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user data: ${e.toString()}')),
      );
    }
  }

  // void _logout() async {
  //   try {
  //     await authService.logout();
  //     Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(builder: (context) => LoginScreen()),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to logout: ${e.toString()}')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text('User Profile'),
        backgroundColor: const Color(0xfffe9721),  // Set the AppBar color to orange
      ),
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    radius: 50,
                    child: Text(
                      userData!['name'][0],
                      style: const TextStyle(color: Colors.white),
                    ), // Adjust the size of the avatar
                  ),
                  const SizedBox(height: 20), // Add spacing between avatar and details
                  _buildDetailRow(Icons.person, 'Name', userData!['name']),
                  _buildDetailRow(Icons.email, 'Email', userData!['email']),
                  _buildDetailRow(Icons.phone, 'Contact No', userData!['contact_number']),
                  const SizedBox(height: 20), // Add spacing between details and buttons
                  SizedBox(
                    width: double.infinity, // Set the button to full width
                    child: ElevatedButton(
                      onPressed: _logout,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(
                            0xfffe9721), // Set the button text color to white
                      ),
                      child: const Text('Logout'),
                    ),
                  ),
                 const SizedBox(height: 50.0),
                ],
              ),
            ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String? value) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 10),
        Text('$label: ${value ?? ''}'),
      ],
    );
  }
}
