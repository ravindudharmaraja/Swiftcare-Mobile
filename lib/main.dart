import 'package:flutter/material.dart';
import 'package:flutter_application_1/Services/HospitalService.dart';
import 'package:flutter_application_1/Services/UserService.dart';
import 'package:flutter_application_1/Services/VehicleService.dart';
import 'package:flutter_application_1/screens/Ambulance/search_screen.dart';
import 'package:flutter_application_1/screens/Auth/login/Login.dart';
import 'package:flutter_application_1/screens/Tracking/tracking_screen.dart';
import 'package:flutter_application_1/screens/home/BookingScreen.dart';
import 'package:flutter_application_1/screens/home/UserScreen.dart';
import 'package:flutter_application_1/screens/home/VehicleScreen.dart';
import 'package:flutter_application_1/screens/home/HomeScreen.dart';
import 'package:flutter_application_1/screens/home/hospital_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/services/AuthService.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => HospitalService()),
        ChangeNotifierProvider(create: (_) => UserService()),
        ChangeNotifierProvider(create: (_) => VehicleService()),
        
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Collapsible Drawer',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 214, 16, 16),
        primarySwatch: Colors.blue,
        fontFamily: 'Urbanist',
      ),
      initialRoute: '/login', // Set initial route
      routes: {
        '/': (context) => const HomeScreen(), // Define route for HomeScreen
        '/login': (context) => LoginScreen(), // Define route for LoginScreen
        // Define route for BookingScreen
        '/tracking': (context) =>
            const TrackingPage(), // Define route for TrackingScreen
        '/search': (context) => SearchScreen(), // Define route for SearchScreen
        // '/searchResult': (context) =>
        //     ResultsScreen(), // Define route for SearchResultScreen
        '/hospitals': (context) => const HospitalsScreen(),
        '/users': (context) => UserScreen(),
        '/vehicle': (context) => const VehicleScreen(),
        '/booking': (context) => const BookingScreen(),
      },
    );
  }
}
