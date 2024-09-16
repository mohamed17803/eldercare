import 'package:flutter/material.dart';

class MedicationdetScreen extends StatefulWidget {
  const MedicationdetScreen({super.key});

  @override
  _MedicationdetScreenState createState() => _MedicationdetScreenState();
}

class _MedicationdetScreenState extends State<MedicationdetScreen> {
  final String medicationName = "Vitamin C";
  final String dosage = "1 pill";
  final String schedule = "every day at 08:00";
  final String description = "Vitamin C helps the body form and maintain connective tissue.";
  int daysDone = 4;
  final int totalDays = 14;
  List<String> dosageHistory = [];
  DateTime? _expirationDate;

  void _handleDone() {
    setState(() {
      if (daysDone < totalDays) {
        daysDone++;
        dosageHistory.add('Taken on ${DateTime.now().toLocal()}');
      }
    });
  }

  void _handleSkip() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dose skipped for today')),
    );
  }

  void _handleDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Medication"),
          content: const Text("Are you sure you want to delete this medication?"),
          actions: [
            TextButton(
              onPressed: () {
                // Handle deletion logic
                Navigator.of(context).pop();
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }

  void _handleEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditMedicationScreen()),
    );
  }

  Future<void> _selectExpirationDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _expirationDate) {
      setState(() {
        _expirationDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _handleEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _handleDelete,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/vitamin_c.png', height: 100), // Ensure the image is in the specified path
            const SizedBox(height: 16),
            Text(
              medicationName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
            ),
            const SizedBox(height: 8),
            Text('Dosage: $dosage', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Schedule: $schedule', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Description: $description', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: (daysDone / totalDays).clamp(0.0, 1.0),
              color: Theme.of(context).primaryColor,
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(height: 8),
            Text('$daysDone/$totalDays days done'),
            const SizedBox(height: 16),
            const Text('Side Effects: Possible nausea and headache.', style: TextStyle(fontSize: 16)),
            const Text('Tips: Take with food for better absorption.', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text('Dosage History:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: dosageHistory.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(dosageHistory[index]),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text('Storage Instructions:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('Store in a cool, dry place away from direct sunlight.', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            // Expiration Date Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Expiration Date:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () => _selectExpirationDate(context),
                  child: Text(
                    _expirationDate != null
                        ? '${_expirationDate!.toLocal()}'.split(' ')[0]
                        : 'Select Date',
                    style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _handleSkip,
                  child: const Text('Skip', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
                ElevatedButton(
                  onPressed: _handleDone,
                  child: const Text('Done', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EditMedicationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Medication'),
      ),
      body: const Center(
        child: Text('Edit medication details here.'),
      ),
    );
  }
}
