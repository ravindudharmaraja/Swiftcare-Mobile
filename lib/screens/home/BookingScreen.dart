import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/Services/BookingService.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text('Emergency Bookings'),
        backgroundColor: const Color(0xfffe9721),  // Set the AppBar color to orange
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: BookingService().fetchEmergencyBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final emergencyBookings = snapshot.data!;
            return ListView.builder(
              itemCount: emergencyBookings.length,
              itemBuilder: (context, index) {
                final booking = emergencyBookings[index];
                DateTime parsedDate = DateTime.parse(booking['created_at']);
                String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    width: double.infinity, // Ensure full width
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                          leading: CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            child: Text(
                              booking['name'][0],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(booking['name'],
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                formattedDate,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            booking['status'],
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {
                              // Handle more options
                            },
                          ),
                          onTap: () {
                            // Handle tapping on booking
                          },
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15.0), // Adjust left and right margins
                          height: 1.0, // Set divider height
                          color: Colors.grey[300], // Set divider color
                        ),
                      ],
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
