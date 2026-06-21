import 'package:flutter/material.dart';

class DriverProfileScreen extends StatefulWidget {
  const DriverProfileScreen({super.key});

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  bool isOnline = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Driver Profile"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),

            const SizedBox(height: 10),

            const Text(
              "Driver Name",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const Text(
              "driver@email.com",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // ONLINE / OFFLINE TOGGLE
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isOnline ? Colors.green : Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    isOnline ? Icons.online_prediction : Icons.offline_bolt,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    isOnline ? "Online" : "Offline",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const Spacer(),
                  Switch(
                    value: isOnline,
                    onChanged: (val) {
                      setState(() {
                        isOnline = val;
                      });
                    },
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // DRIVER STATS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _StatBox(title: "Rides", value: "48"),
                _StatBox(title: "Rating", value: "4.8"),
                _StatBox(title: "Earnings", value: "PKR 12K"),
              ],
            ),

            const SizedBox(height: 30),

            _buildTile(Icons.history, "Ride History"),
            _buildTile(Icons.account_balance_wallet, "Earnings Details"),
            _buildTile(Icons.star, "Ratings"),
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

// Stat widget
class _StatBox extends StatelessWidget {
  final String title;
  final String value;

  const _StatBox({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(title, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}