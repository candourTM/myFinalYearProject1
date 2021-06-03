import 'package:final_year_project/Screens/booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class CarParks extends StatefulWidget {
  @override
  _CarParksState createState() => _CarParksState();
}

class _CarParksState extends State<CarParks> {
  void initState() {
    _refresh().then((value){
      print('Async done');
    });
    super.initState();
  }
  final dbRef = FirebaseDatabase.instance.reference();

  int freeSlots;
  String totalslots;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
          child: Column(
            children: [
              Text('Available Slots'),
              GestureDetector(
                child: ListTile(
                  leading: Icon(Icons.electric_car_outlined),
                  title: Text("Faculty of Science"),
                  trailing: Text("$freeSlots"),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookingScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.electric_car_outlined),
                title: Text("Faculty of Engineering"),
                trailing: Text(""),
              ),
              ListTile(
                leading: Icon(Icons.electric_car_outlined),
                title: Text("Student Hostel"),
                trailing: Text(""),
              ),
              ElevatedButton(
                onPressed: () {
                  _refresh();
                },
                child: Text("Refresh"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    dbRef
        .child('CarPark')
        .child('open slots')
        .once()
        .then((DataSnapshot dataSnapShot) {
      totalslots = dataSnapShot.value.toString();
      setState(() {
        freeSlots = int.parse(totalslots);
      });
    });
  }
}
