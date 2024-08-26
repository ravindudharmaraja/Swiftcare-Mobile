
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/drawer/custom_drawer.dart';
import 'package:flutter_application_1/screens/Ambulance/searchResult_screen.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl/intl.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController locationValue = TextEditingController();
  TextEditingController dateValue = TextEditingController();
  TextEditingController pickupTimeValue = TextEditingController(text: availableTimes[0]);
  TextEditingController returnTimeValue = TextEditingController(text: availableTimes[0]);
  double latitude = 0.0;
  double longitude = 0.0;
  DateFormat displayDateFormat = DateFormat('MMM dd, yyyy');
  DateFormat otaDateFormat = DateFormat('yyyy-MM-dd');
  String pickupDate = '';
  String returnDate = '';

  // Add your Google Maps API key here
  static const kGoogleMapsKey = 'YOUR_API_KEY_HERE';
  
  // Sample times for picker
  static const List<String> availableTimes = ['08:00', '09:00', '10:00', '11:00', '12:00'];

  

  // Get geo coordinates from places API prediction
  void _getLatLng(Prediction prediction) async {
    GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleMapsKey);
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(prediction.placeId!);

    if (prediction.types!.contains('airport')) {
      print('is airport');
    }
    setState(() {
      latitude = detail.result.geometry!.location.lat;
      longitude = detail.result.geometry!.location.lng;
    });
  }

  // Show date range picker
  Future<void> _showDateRangePicker(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    // Update text form field
    if (picked != null) {
      setState(() {
        pickupDate = otaDateFormat.format(picked.start);
        returnDate = otaDateFormat.format(picked.end);
        dateValue.text = "${displayDateFormat.format(picked.start)} to ${displayDateFormat.format(picked.end)}";
      });
    }
  }

 

  // Time Select - Show material time picker widget on Android
  TimeOfDay androidPickupTime = TimeOfDay(hour: 10, minute: 0);
  Future<void> _selectTime(int type) async {
    final TimeOfDay? picked_s = await showTimePicker(
      context: context,
      initialTime: androidPickupTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked_s != null) {
      setState(() {
        if (type == 0) {
          pickupTimeValue.text = picked_s.format(context).replaceAll(' AM', "").replaceAll(' PM', "");
        } else {
          returnTimeValue.text = picked_s.format(context).replaceAll(' AM', "").replaceAll(' PM', "");
        }
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: SafeArea(
          
          
          child: ListView(
            padding: EdgeInsets.all(20.0),
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Main heading
                    Text(
                      'Search for an ambulance',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'We search over 1,600 suppliers to find you the lowest price!',
                    ),
                    // Location Search Field
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: locationValue,
                      decoration: InputDecoration(
                        hintText: 'Enter a Pickup location',
                        labelText: 'Enter a Pickup location',
                        prefixIcon: Icon(Icons.location_pin),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      onTap: () {
                        
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a pick-up location';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: dateValue,
                      onTap: () {
                        _showDateRangePicker(context);
                      },
                      decoration: InputDecoration(
                        hintText: 'Select dates',
                        labelText: 'Select dates',
                        prefixIcon: Icon(Icons.calendar_today),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please select dates';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            
                            controller: pickupTimeValue,
                            decoration: InputDecoration(
                              hintText: 'Pick up time',
                              labelText: 'Pick up time',
                              prefixIcon: Icon(Icons.access_time_rounded),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: TextFormField(
                            
                            controller: returnTimeValue,
                            decoration: InputDecoration(
                              hintText: 'Drop off time',
                              labelText: 'Drop off time',
                              prefixIcon: Icon(Icons.access_time_rounded),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Create a new SearchData object
                            var searchData = SearchData(
                              locationName: locationValue.text,
                              latitude: latitude,
                              longitude: longitude,
                              pickupDate: pickupDate,
                              returnDate: returnDate,
                              pickupTime: pickupTimeValue.text,
                              returnTime: returnTimeValue.text,
                            );
                            // Update global search
                            gSearchData = searchData;
                            // If the form is valid, navigate to the results screen
                            // Navigator.push(context, MaterialPageRoute(builder: (context) {
                            //   return ResultsScreen(
                            //     searchData: searchData,
                            //   );
                            // }));
                          }
                        },
                        child: Text(
                          'Search Ambulance',
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchData {
  final String locationName;
  final double latitude;
  final double longitude;
  final String pickupDate;
  final String returnDate;
  final String pickupTime;
  final String returnTime;

  SearchData({
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.pickupDate,
    required this.returnDate,
    required this.pickupTime,
    required this.returnTime,
  });
}

SearchData gSearchData = SearchData(
  locationName: '',
  latitude: 0.0,
  longitude: 0.0,
  pickupDate: '',
  returnDate: '',
  pickupTime: '',
  returnTime: '',
);

class SearchResultsScreen extends StatelessWidget {
  final SearchData searchData;

  SearchResultsScreen({required this.searchData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: Center(
        child: Text(
          'Location: ${searchData.locationName}\n'
          'Latitude: ${searchData.latitude}\n'
          'Longitude: ${searchData.longitude}\n'
          'Pickup Date: ${searchData.pickupDate}\n'
          'Return Date: ${searchData.returnDate}\n'
          'Pickup Time: ${searchData.pickupTime}\n'
          'Return Time: ${searchData.returnTime}',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
