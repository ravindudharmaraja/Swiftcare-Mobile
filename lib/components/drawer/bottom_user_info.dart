import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/services/AuthService.dart';

class BottomUserInfo extends StatelessWidget {
  final bool isCollapsed;
  final bool isLoggedIn;

  const BottomUserInfo({
    Key? key,
    required this.isCollapsed,
    required this.isLoggedIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of<AuthService>(context);
    return FutureBuilder<Map<String, dynamic>?>(
      future: authService.getUserSpecificData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Text('No user data available');
        } else {
          final userData = snapshot.data!;
          return Column(
            children: [
              if (isCollapsed)
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/users');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300], // Gray color
                      borderRadius:
                          BorderRadius.circular(30), // Rounded corners
                    ),
                    padding: EdgeInsets.all(8), // Add some padding
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Text(
                            userData['name'][0] ?? 'User Name',
                            style: const TextStyle(color: Color.fromARGB(255, 15, 15, 15)),
                          ),
                        ),
                        SizedBox(width: 8), // Add some spacing
                        Text(
                          userData['name'] ?? 'User Name',
                          style: TextStyle(color: const Color.fromARGB(255, 12, 12, 12)),
                        ),
                      ],
                    ),
                  ),
                )
              else
                CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Text(
                    userData['name'][0] ?? 'User Name',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
            ],
          );
        }
      },
    );
  }
}
