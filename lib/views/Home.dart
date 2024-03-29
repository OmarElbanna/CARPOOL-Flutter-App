import 'dart:async';

import 'package:carpool/views/my%20account/Account.dart';
import 'package:carpool/models/Database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/Trip.dart';
import 'reservation/TripDetails.dart';
import 'package:carpool/services/Database/Sqflite_Queries.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Trip> trips = [];
  late User user;

  void updateUser() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Book a Ride",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
          child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('trips')
            .where('time', isGreaterThan: DateTime.now())
            .snapshots(),
        builder: (con, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Text(
              'No available upcoming trips',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          }

          final firebaseTrips = snapshot.data!.docs;

          return ListView.builder(
            itemCount: firebaseTrips.length,
            itemBuilder: (context, index) {
              DateTime date = firebaseTrips[index]['time'].toDate();
              String dateToShow = "${date.day}/${date.month}/${date.year}";
              String timeToShow = "${date.hour}:${date.minute}";
              return Padding(
                padding: const EdgeInsets.all(3),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 4,
                  child: ListTile(
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                        ),
                        // Starting point icon
                        const SizedBox(height: 4),
                        Container(
                          height: 16,
                          width: 1, // Vertical bar width
                          // Vertical bar color
                        ),
                      ],
                    ),
                    title: Row(
                      children: [
                        Text(
                          '${firebaseTrips[index]['from']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Icon(Icons.arrow_right_alt),
                        Text(
                          '${firebaseTrips[index]['to']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                            ),
                            // Destination icon
                            const SizedBox(width: 4),
                            Text('Date: $dateToShow'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time_filled,
                                ),
                                Text(' Time: $timeToShow'),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.attach_money,
                                  color: Colors.green,
                                ),
                                Text(
                                  ' Price: ${firebaseTrips[index]['price']}',
                                  style: const TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () async {
                      String driverId = firebaseTrips[index]['driverId'];
                      final driverDoc = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(driverId)
                          .get();
                      final driverInfo = driverDoc.data();
                      Trip trip = Trip(
                          from: firebaseTrips[index]['from'],
                          to: firebaseTrips[index]['to'],
                          price: firebaseTrips[index]['price'],
                          time: firebaseTrips[index]['time'].toDate(),
                          from_lat: firebaseTrips[index]['from_lat'],
                          from_lng: firebaseTrips[index]['from_lng'],
                          to_lat: firebaseTrips[index]['to_lat'],
                          to_lng: firebaseTrips[index]['to_lng'],
                          id: firebaseTrips[index].id,
                          driverName:
                              "${driverInfo!['firstName']} ${driverInfo['lastName']}",
                          carModel: driverInfo['carModel'],
                          carColor: driverInfo['carColor']);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TripDetailsScreen(
                            data: trip,
                            isBooking: true,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      )),
      drawer: Drawer(
          child: FutureBuilder(
              future: getUserData(user.uid),
              builder: (con, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final userData = snapshot.data![0] as Map<String, dynamic>;
                return Column(
                  children: [
                    UserAccountsDrawerHeader(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ))), // Set the thickness of the bottom border
                        currentAccountPicture: const CircleAvatar(
                          radius: 200,
                          backgroundImage: AssetImage("images/download.png"),
                        ),
                        accountName: GestureDetector(
                          child: Text(
                            "${userData['firstName']} ${userData['lastName']}",
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          onTap: () {},
                        ),
                        accountEmail: Text(
                          userData['email'],
                          style: TextStyle(color: Colors.white),
                        )),
                    ListTile(
                      title: const Text("Account"),
                      leading: const Icon(Icons.account_circle_rounded),
                      onTap: () {
                        Navigator.pop(context);
                        Timer(const Duration(milliseconds: 500), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AccountScreen(updateCallback: updateUser),
                            ),
                          );
                        });
                      },
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                    ListTile(
                        title: const Text("My Trips"),
                        leading: const Icon(Icons.history),
                        onTap: () {
                          Navigator.pop(context);
                          Timer(const Duration(milliseconds: 500), () {
                            Navigator.pushNamed(context, '/mytrips');
                          });
                        }),
                    const Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                    ListTile(
                      title: const Text("Logout"),
                      leading: const Icon(Icons.logout_outlined),
                      onTap: () async {
                        await deleteUser();
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/login', (route) => false);
                      },
                    ),
                  ],
                );
              })),
    );
  }
}
