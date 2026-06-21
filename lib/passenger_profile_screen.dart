import 'package:flutter/material.dart';

class PassengerProfileScreen extends StatelessWidget {
  const PassengerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Passenger Profile"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Avatar
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),

            const SizedBox(height: 10),

            const Text(
              "Passenger Name",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const Text(
              "passenger@email.com",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            // Options
            _buildTile(Icons.history, "Ride History"),
            _buildTile(Icons.payment, "Payment Methods"),
            _buildTile(Icons.location_on, "Saved Places"),
            _buildTile(Icons.support, "Support"),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {},
    );
  }
}