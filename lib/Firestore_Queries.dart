import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Map<String, dynamic>>> getUserTrips(String userId) async {
  QuerySnapshot<Map<String, dynamic>> requestsSnapshot = await FirebaseFirestore
      .instance
      .collection('requests')
      .where('userId', isEqualTo: userId)
      .get();

  List tripIds = requestsSnapshot.docs.map((doc) => doc['tripId']).toList();
  if (tripIds.isEmpty) {
    print("############################################");
    List<Map<String, dynamic>> empty = [];
    return empty;
  }

  QuerySnapshot<Map<String, dynamic>> tripsSnapshot = await FirebaseFirestore
      .instance
      .collection('trips')
      .where(FieldPath.documentId, whereIn: tripIds)
      .get();

  List<Map<String, dynamic>> userTrips = tripsSnapshot.docs.map((tripDoc) {
    var tripDetails = tripDoc.data();
    var requestId =
        requestsSnapshot.docs.firstWhere((doc) => doc['tripId'] == tripDoc.id);

    var status = requestId['status'];

    return {'details': tripDetails, 'status': status};
  }).toList();

  return userTrips;
}

Stream<List<Map<String, dynamic>>> getUserTripsStream(String userId) {
  StreamController<List<Map<String, dynamic>>> controller =
  StreamController<List<Map<String, dynamic>>>();

  FirebaseFirestore.instance
      .collection('requests')
      .where('userId', isEqualTo: userId)
      .snapshots()
      .listen((requestsSnapshot) async {
    List tripIds = requestsSnapshot.docs.map((doc) => doc['tripId']).toList();

    if (tripIds.isEmpty) {
      print("############################################");
      controller.add([]); // Add an empty list to the stream
      return;
    }

    FirebaseFirestore.instance
        .collection('trips')
        .where(FieldPath.documentId, whereIn: tripIds)
        .snapshots()
        .listen((tripsSnapshot) {
      List<Map<String, dynamic>> userTrips = tripsSnapshot.docs.map((tripDoc) {
        var tripDetails = tripDoc.data();
        var requestId = requestsSnapshot.docs
            .firstWhere((doc) => doc['tripId'] == tripDoc.id);

        var status = requestId['status'];

        return {'details': tripDetails, 'status': status};
      }).toList();

      controller.add(userTrips); // Add the userTrips list to the stream
    });
  });

  return controller.stream;
}