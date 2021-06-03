import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  void initState() {
    _refresh().then((value) {
      print('Async done');
    });
    digitCode = getRandomString(4);
    super.initState();
  }

  final dbRef = FirebaseDatabase.instance.reference();

  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) {
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => _chars.codeUnitAt(
          _rnd.nextInt(_chars.length),
        ),
      ),
    );
  }

  int freeSlots;
  String totalslots, numbPlate, capPark;
  String digitCode = '';

  getNumberPlate(numberplate) {
    this.numbPlate = numberplate;
  }

  bool isCreated;

  bookButton() {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("Fac of sci")
        .doc(digitCode);

    Map<String, dynamic> bookings = {
      "parkID": 'Faculty of Science',
      "plateID": numbPlate,
      "id" : digitCode
    };

    documentReference.set(bookings).whenComplete(() {
      setState(() {
        digitCode = bookings["id"];
      });

      showDialog(context: context, builder: (_) => AlertDialog(
        title: Text('Slot Booked!'),
        content: Text('Proceed to the parking lot'),
        actions: [
          TextButton(onPressed: (){
            setState(() {
              digitCode = getRandomString(4);
            });
            Navigator.of(context).pop();
            slotCounter();
            _refresh();
          }, child: Text('Ok'),
          ),
        ],
      ),);

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.teal,
          padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
          child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    iconSize: 30,
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Number of Free Spaces: $freeSlots/10',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      SizedBox(width: 15),
                      IconButton(
                          icon: Icon(Icons.refresh),
                          onPressed: () {
                            _refresh();
                          }),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    maxLength: 8,
                    decoration: InputDecoration(
                      labelText: "Number Plate",
                      labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.5),
                      ),
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                    onChanged: (String numberplate) {
                      getNumberPlate(numberplate);
                    },
                  ),
                  ElevatedButton(
                    child: Text(
                      'Book Slot!',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      _refresh();
                       if (freeSlots >= 1) {
                        bookButton();
                      } else {
                        return showDialog(context: context, builder: (_) => AlertDialog(
                          title: Text('Unable to Book!'),
                          content: Text('No more free spaces, please refresh and try again later'),
                          actions: [
                            TextButton(onPressed: (){
                              Navigator.of(context).pop();
                              _refresh();
                            }, child: Text('Ok'),
                            ),
                          ],
                        ),);
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  Container(child: Center(child: Text('4-Digit Parking Code: $digitCode', textAlign: TextAlign.center, style: TextStyle(fontSize: 40, color: Colors.white),),),),
                ],
              ),
        ),
      ),
    );
  }

  void slotCounter() {
    dbRef
        .child('CarPark')
        .child('open slots')
        .once()
        .then((DataSnapshot dataSnapShot) {
      totalslots = dataSnapShot.value.toString();
      freeSlots = int.parse(totalslots);
      setState(() {
        freeSlots--;
      });
      dbRef.child('CarPark').set({'open slots': '$freeSlots'});
    });
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
