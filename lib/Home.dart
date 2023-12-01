import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Trip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Trip> trips = [];

  @override
  void initState() {
    super.initState();
    trips.add(Trip(
        from: "Madinaty Gate 1",
        to: "ASUFE Gate 3",
        time: "7:30 AM",
        price: 70));
    trips.add(Trip(
        from: "Rehab Gate 5", to: "ASUFE Gate 4", time: "7:30 AM", price: 60));
    trips.add(Trip(
        from: "Downtown Mall", to: "ASUFE Gate 3", time: "7:30 AM", price: 50));
    trips.add(Trip(
        from: "Triumph Square",
        to: "ASUFE Gate 4",
        time: "7:30 AM",
        price: 40));

    trips.add(Trip(
        from: "ASUFE Gate 3",
        to: "Madinaty Gate 1",
        time: "5:30 PM",
        price: 70));
    trips.add(Trip(
        from: "ASUFE Gate 4", to: "Rehab Gate 5", time: "5:30 PM", price: 60));
    trips.add(Trip(
        from: "ASUFE Gate 3", to: "Downtown Mall", time: "5:30 PM", price: 50));
    trips.add(Trip(
        from: "ASUFE Gate 4",
        to: "Triumph Square",
        time: "5:30 PM",
        price: 40));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[600],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[700],
        title: const Text(
          "Book a Ride",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ListView.builder(
          itemCount: trips.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(3),
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 4,
                child: ListTile(
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on, color: Colors.blueGrey[700]),
                      // Starting point icon
                      const SizedBox(height: 4),
                      Container(
                        height: 16,
                        width: 1, // Vertical bar width
                        color: Colors.blueGrey[700], // Vertical bar color
                      ),
                    ],
                  ),
                  title: Row(
                    children: [
                      Text(
                        '${trips[index].from}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Icon(Icons.arrow_right_alt),
                      Text(
                        '${trips[index].to}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.blueGrey[700]),
                          // Destination icon
                          const SizedBox(width: 4),
                          Text('Destination: ${trips[index].to}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_filled,
                                color: Colors.blueGrey[700],
                              ),
                              Text(' Time: ${trips[index].time}'),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.attach_money,
                                color: Colors.green,
                              ),
                              Text(
                                ' Price: ${trips[index].price}',
                                style: const TextStyle(color: Colors.green),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/tripdetails',
                        arguments: {'trip': trips[index]});
                  },
                ),
              ),
            );
          },
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.blueGrey[700]),
                currentAccountPicture: const CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://media.licdn.com/dms/image/C4D03AQGFxldRxlU7Xg/profile-displayphoto-shrink_800_800/0/1661131775382?e=2147483647&v=beta&t=A1qCwqFSQT44KYD1geoOwQlFP9uqBBNMUgN4NFtyfK8"),
                ),
                accountName: GestureDetector(
                  child: const Text(
                    "Omar Elbanna",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {},
                ),
                accountEmail: const Text("19P3904@eng.asu.edu.eg")),
            ListTile(
              title: const Text("Account"),
              leading: const Icon(Icons.account_circle_rounded),
              onTap: () {
                Navigator.pop(context);
                Timer(const Duration(milliseconds: 500), () {
                  Navigator.pushNamed(context, '/account');
                });
              },
            ),
            const Divider(
              thickness: 1,
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
              thickness: 1,
            ),
            ListTile(
              title: const Text("Logout"),
              leading: const Icon(Icons.logout_outlined),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
