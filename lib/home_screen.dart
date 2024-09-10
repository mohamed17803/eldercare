import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s plan',
            style: TextStyle(
              fontSize: 22,
                fontWeight: FontWeight.bold
            )),
        backgroundColor: Colors.white,

      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Mon, 23 Nov',
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          _buildMedicationItem('08:00', 'Omega 3', '1 pill once per day'),
          _buildMedicationItem('12:00', 'Vitamin D', '2 pills once per week'),
          _buildMedicationItem('12:00', 'Vitamin C', '1 pill once per day'),
          _buildMedicationItem('19:00', 'Aspirin', '1 pill once per day'),
          _buildMedicationItem('19:00', 'Aspirin', '1 pill once per day'),
          _buildMedicationItem('19:00', 'Aspirin', '1 pill once per day'),

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Add medication'),
          BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: 'Medications'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  // Widget to display each medication item
  _buildMedicationItem(String time, String name, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          time,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: const Icon(Icons.medication, size: 40, color: Colors.blue),
            title: Text(name, style: const TextStyle(fontSize: 18)),
            subtitle: Text(description),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
