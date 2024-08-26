import 'package:flutter/material.dart';
import 'package:flutter_application_1/Services/BookingService.dart';
import 'package:timelines/timelines.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  _TrackingPageState createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  int currentStep = 0;
  BookingService bookingService = BookingService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBookingProgress();
  }

  Future<void> _fetchBookingProgress() async {
    try {
      List<Map<String, dynamic>> bookings =
          await bookingService.fetchEmergencyBookings();
      if (bookings.isNotEmpty) {
        var lastBooking = bookings.last;
        var progressValue = lastBooking['progress'];
        int fetchedProgress = (progressValue is int) ? progressValue : 1;
        // Adjust the fetched progress to start from 1
        fetchedProgress -= 1;
        // Print the entire booking data for verification
        print('Fetched booking data: $lastBooking');
        // Print the fetched progress for verification
        print('Fetched progress: $fetchedProgress');
        setState(() {
          currentStep = fetchedProgress;
          isLoading = false;
        });
      } else {
        print('No bookings found');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error
      print('Error fetching progress: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text('Track Bookings'),
        backgroundColor:
            const Color(0xfffe9721), // Set the AppBar color to orange
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: _OrderTitle(orderInfo: _data(1)),
                  ),
                  const Divider(height: 0.0),
                  _DeliveryProcesses(
                    processes: _data(1).deliveryProcesses,
                    currentStep: currentStep,
                  ),
                  const Divider(height: 10.0),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity, // Set the button to full width
                    child: ElevatedButton(
                      onPressed: _recentbooking,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(
                            0xfffe9721), // Set the button text color to white
                      ),
                      child: const Text('Show History'),
                    ),
                  ),
                 const SizedBox(height: 50.0),
                  Text(
                 'The hospital will contact you for confirmation. Please wait for it.',
                 textAlign: TextAlign.center,
                 style: TextStyle(
                   color: Colors.grey[600],
                   fontStyle: FontStyle.italic,
                   fontSize: 10,
                 ),
               ),
                ],
              ),
               
            ),
    );
  }

  void _recentbooking() {}
}

class _OrderTitle extends StatelessWidget {
  const _OrderTitle({Key? key, required this.orderInfo}) : super(key: key);

  final _OrderInfo orderInfo;

  @override
  Widget build(BuildContext context) {
    // Format the date and time
    String formattedDateTime =
        DateFormat('yyyy-MM-dd – kk:mm').format(orderInfo.date);

    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        children: [
          Text(
            'Booking  ${orderInfo.id}', // Accessing booking ID from orderInfo
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(
            formattedDateTime, // Display formatted date and time
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class _DeliveryProcesses extends StatelessWidget {
  const _DeliveryProcesses({
    Key? key,
    required this.processes,
    required this.currentStep,
  }) : super(key: key);

  final List<_DeliveryProcess> processes;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(color: Colors.black, fontSize: 12.5),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FixedTimeline.tileBuilder(
          theme: TimelineThemeData(
            nodePosition: 0.0, // Adjust the position of the nodes
            color: Colors.grey,
            indicatorTheme: const IndicatorThemeData(
              position: 0,
              size: 10.0,
            ),
            connectorTheme: const ConnectorThemeData(thickness: .5),
          ),
          builder: TimelineTileBuilder.connected(
            connectionDirection: ConnectionDirection.before,
            itemCount: processes.length,
            contentsBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      processes[index].name,
                      style: DefaultTextStyle.of(context)
                          .style
                          .copyWith(fontSize: 18.0),
                    ),
                    if (index <= currentStep)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: processes[index]
                              .messages
                              .map((message) => Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 0.0),
                                    child: Text(message.message),
                                  ))
                              .toList(),
                        ),
                      ),
                  ],
                ),
              );
            },
            indicatorBuilder: (_, index) {
              return index <= currentStep
                  ? Icon(Icons.check_circle,
                      color: const Color(0xfffe9721), size: 30.0)
                  : Icon(Icons.radio_button_unchecked,
                      color: Colors.grey, size: 30.0);
            },
            connectorBuilder: (_, index, __) => SolidLineConnector(
              color:
                  index < currentStep ? const Color(0xfffe9721) : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

_OrderInfo _data(int id) => _OrderInfo(
      id: id,
      date: DateTime.now(),
      deliveryProcesses: [
        _DeliveryProcess(
          'Booking Process',
          1,
          messages: [
            _DeliveryMessage('Booking accepted by Hospital'),
            _DeliveryMessage('Ready to transit'),
          ],
          isActive: true,
        ),
        _DeliveryProcess(
          'Assign Driver',
          2,
          messages: [
            _DeliveryMessage('Request received by driver'),
          ],
          isActive: true,
        ),
        _DeliveryProcess(
          'In Transit',
          3,
          messages: [
            _DeliveryMessage('Driver arrived at destination'),
          ],
          isActive: true,
        ),
        _DeliveryProcess(
          'Done',
          4,
          messages: [
            _DeliveryMessage('Booking completed'),
          ],
          isActive: false,
        ),
      ],
    );

class _OrderInfo {
  const _OrderInfo({
    required this.id,
    required this.date,
    required this.deliveryProcesses,
  });

  final int id;
  final DateTime date;
  final List<_DeliveryProcess> deliveryProcesses;
}

class _DeliveryProcess {
  final String name;
  final List<_DeliveryMessage> messages;
  final int state;
  final bool isActive;

  _DeliveryProcess(
    this.name,
    this.state, {
    this.messages = const [],
    this.isActive = false,
  });

  bool get isCompleted => state == 3;
}

class _DeliveryMessage {
  const _DeliveryMessage(this.message);

  final String message;

  @override
  String toString() {
    return message;
  }
}
