import 'package:final_year_project/Screens/car_parks.dart';
import 'package:final_year_project/Screens/home_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image(
                image: AssetImage('images/parking-logo.png'),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 30),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CarParks()),
                  );
                },
                child: Text(
                  'See Parking Lots >>',
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color(0xff00AAFF),
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
