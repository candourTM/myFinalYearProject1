import 'package:final_year_project/Screens/booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const LatLng _center = const LatLng(6.188474, 5.655497);

  MapType _currentMapType = MapType.satellite;

  void toBookingScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: _center, zoom: 17.5),
          mapType: _currentMapType,
          buildingsEnabled: true,
          markers: {engineering, sciences, hostel},
        ),
        Positioned(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookingScreen()),
              );
            },
            child: Text('Proceed To Booking'),
          ),
          bottom: 20,
          left: 100,
          width: 180,
          height: 50,
        ),
      ],
    );
  }

  Marker engineering = Marker(
    markerId: MarkerId('engineering'),
    position: LatLng(6.187089, 5.654196),
    infoWindow:
        InfoWindow(title: 'Faculty of Engineering', snippet: 'Park Here'),
    icon: BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueViolet,
    ),
  );
  Marker sciences = Marker(
    markerId: MarkerId('sciences'),
    position: LatLng(6.189254, 5.655247),
    infoWindow: InfoWindow(title: 'Faculty of Science'),
    icon: BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueViolet,
    ),
  );

  Marker hostel = Marker(
    markerId: MarkerId('hostel'),
    position: LatLng(6.189348, 5.656465),
    infoWindow: InfoWindow(title: 'Faculty of Science'),
    icon: BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueViolet,
    ),
  );
}
