import 'package:flutter/material.dart';

import 'Account.dart';
import 'Home.dart';
import 'Login.dart';
import 'MyTrips.dart';
import 'Signup.dart';
import 'Splash.dart';
import 'TripDetails.dart';

void main() {
  runApp(MaterialApp(
    showSemanticsDebugger: false,
    debugShowCheckedModeBanner: false,
    initialRoute: '/splash',
    routes: {
      '/splash': (context) => const SplashScreen(),
      '/login': (context) => const LoginScreen(),
      '/signup_s': (context) => const SignupScreen(),
      '/home': (context) => const HomeScreen(),
      '/account': (context) => const AccountScreen(),
      '/mytrips': (context) => const TripsScreen(),
      '/tripdetails': (context) => const TripDetailsScreen()
    },
  ));
}
