import 'package:flutter/material.dart';
import 'package:ride_app/passenger_profile_screen.dart';
import 'driver_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userType; // "Passenger" or "Driver"

  const ProfileScreen({super.key, required this.userType});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return widget.userType == "Driver"
        ? const DriverProfileScreen()
        : const PassengerProfileScreen();
  }
}