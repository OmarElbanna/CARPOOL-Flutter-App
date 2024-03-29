import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/Trip.dart';

class TripDetailsScreen extends StatefulWidget {
  final Trip data;
  final bool isBooking;

  const TripDetailsScreen(
      {super.key, required this.data, required this.isBooking});

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

Map<MarkerId, Marker> markers = {};
PolylinePoints polylinePoints = PolylinePoints();
Map<PolylineId, Polyline> polylines = {};

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  Completer<GoogleMapController> _controller = Completer();
  bool bypass = false;

  @override
  void initState() {
    super.initState();
    Trip data = widget.data;
    double originLatitude = data.from_lat!;
    double originLongitude = data.from_lng!;

    double destLatitude = data.to_lat!;
    double destLongitude = data.to_lng!;
    _addMarker(
      LatLng(originLatitude, originLongitude),
      "origin",
      BitmapDescriptor.defaultMarker,
    );

    // Add destination marker
    _addMarker(
      LatLng(destLatitude, destLongitude),
      "destination",
      BitmapDescriptor.defaultMarkerWithHue(90),
    );

    _getPolyline();
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = widget.data.time!;
    String dateToShow = "${date.day}/${date.month}/${date.year}";
    String timeToShow = "${date.hour}:${date.minute}";
    return Scaffold(
      appBar: AppBar(
        actions: widget.isBooking
            ? [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Switch(
                    value: bypass, // Set the initial value of the switch
                    onChanged: (bool value) {
                      setState(() {
                        bypass = value;
                      });
                    },
                    // activeColor: Colors.green,
                    activeTrackColor:
                        Colors.green, // Color when the switch is ON
                    // Color of the switch track when OFF
                  ),
                ),
              ]
            : null,
        title: widget.isBooking
            ? const Text(
                "Confirm Booking",
                style: TextStyle(
                  fontSize: 20,
                ),
              )
            : const Text(
                "Trip Details",
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
            Expanded(
              flex: 7,
              child: GoogleMap(
                markers: Set<Marker>.of(markers.values),
                polylines: Set<Polyline>.of(polylines.values),
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.data.from_lat!, widget.data.from_lng!),
                  zoom: 12,
                ),
                onMapCreated: (controller) {
                  _controller.complete(controller);
                },
              ),
            ),
            Expanded(
              flex: 3,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 4,
                child: ListTile(
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 25,
                        width: 1,
                      ),
                    ],
                  ),
                  title: Row(
                    children: [
                      Text(
                        '${widget.data.from}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Icon(Icons.arrow_right_alt),
                      Text(
                        '${widget.data.to}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on),
                          // Destination icon
                          const SizedBox(width: 4),
                          Text('Date: $dateToShow'),
                        ],
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_filled,
                              ),
                              Text(' Time: $timeToShow'),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                          ),
                          Text("Driver Name : ${widget.data.driverName!}"),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.car_rental),
                          Text("Car Model : ${widget.data.carModel!}"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.color_lens_rounded,
                              ),
                              Text("Car Color : ${widget.data.carColor!}"),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.attach_money,
                                color: Colors.green,
                              ),
                              Text(
                                ' Price: ${widget.data.price!}',
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
            widget.isBooking
                ? ElevatedButton(
                    onPressed: () async {
                      String userId = FirebaseAuth.instance.currentUser!.uid;
                      String tripId = widget.data.id!;
                      QuerySnapshot<Map<String, dynamic>> existingRequests =
                          await FirebaseFirestore.instance
                              .collection('requests')
                              .where('userId', isEqualTo: userId)
                              .where('tripId', isEqualTo: tripId)
                              .get();

                      if (existingRequests.docs.isEmpty) {
                        DateTime currentTime = DateTime.now();
                        DateTime reservationDeadline;
                        if (widget.data.time!.hour == 7) {
                          reservationDeadline = DateTime(
                            widget.data.time!.year,
                            widget.data.time!.month,
                            widget.data.time!.day - 1,
                            22, // 10:00 pm
                            0,
                          );
                        } else if (widget.data.time!.hour == 17) {
                          reservationDeadline = DateTime(
                            widget.data.time!.year,
                            widget.data.time!.month,
                            widget.data.time!.day,
                            13, // 10:00 pm
                            0,
                          );
                        } else {
                          reservationDeadline = DateTime.now();
                        }
                        if (currentTime.isBefore(reservationDeadline) ||
                            bypass) {
                          await FirebaseFirestore.instance
                              .collection('requests')
                              .add({
                            'userId': FirebaseAuth.instance.currentUser!.uid,
                            'tripId': widget.data.id,
                            'status': 'requested',
                          });
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.success,
                            animType: AnimType.rightSlide,
                            title: 'Success',
                            desc:
                            'Your trip has been booked successfully',
                            btnOkOnPress: () {
                            },
                          )..show();
                        } else {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Failed',
                            desc:
                            'Sorry, the reservation deadline for this trip has passed. For testing purposes toggle the switch in the app bar',
                            btnOkOnPress: () {
                            },
                          )..show();
                        }
                      } else {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.info,
                          animType: AnimType.rightSlide,
                          title: 'Alert',
                          desc:
                          'You have already booked this trip, check my trips page',
                          btnOkOnPress: () {
                          },
                        )..show();
                      }
                    },
                    child: const Text(
                      'Book',
                    ),
                  )
                : Text(
                    "Status : ${widget.data.status}",
                    style: TextStyle(
                        color: widget.data.status == 'accepted'
                            ? Colors.green
                            : widget.data.status == 'rejected'
                                ? Colors.red
                                : null,
                        fontSize: 25),
                  ),
          ],
        ),
      ),
    );
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        points: polylineCoordinates,
        width: 6,
        color: Colors.blue);
    polylines[id] = polyline;
    setState(() {});
  }

  void _getPolyline() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyC-baBp8s3PqyYlA51eEXUjXE1tKC9OvvI",
      PointLatLng(widget.data.from_lat!, widget.data.from_lng!),
      PointLatLng(widget.data.to_lat!, widget.data.to_lng!),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    _addPolyLine(polylineCoordinates);
  }
}
