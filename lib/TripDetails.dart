import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripDetailsScreen extends StatefulWidget {
  const TripDetailsScreen({super.key});

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[700],
        title: const Text(
          "Confirm Booking",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Expanded(
              flex: 8,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(30.064691251883925, 31.279170289931916),
                  zoom: 17.0,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 4,
                child: ListTile(
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on, color: Colors.blueGrey[700]),
                      // Starting point icon
                      const SizedBox(height: 4),
                      Container(
                        height: 16,
                        width: 1,
                        color: Colors.blueGrey[700],
                      ),
                    ],
                  ),
                  title: Row(
                    children: [
                      Text(
                        '${data['trip'].from}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Icon(Icons.arrow_right_alt),
                      Text(
                        '${data['trip'].to}',
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
                          Text('Destination: ${data['trip'].to}'),
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
                              Text(' Time: ${data['trip'].time}'),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.attach_money,
                                color: Colors.green,
                              ),
                              Text(
                                ' Price: ${data['trip'].price}',
                                style: const TextStyle(color: Colors.green),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            MaterialButton(
              color: Colors.blueGrey[700],
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Booking Successful'),
                        content: const Text(
                            'Your trip has been booked successfully!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'OK',
                              style: TextStyle(color: Colors.blueGrey[700]),
                            ),
                          ),
                        ],
                      );
                    });
              },
              child: const Text(
                'Book',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
