import 'package:flutter/material.dart';
class MedicationdetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medication Details',
      theme: ThemeData(
        primaryColor: Color(0xFF6936F5),
        primarySwatch: Colors.blue,
      ),
      home: MedicationDetailScreen(),
    );
  }
}

class MedicationDetailScreen extends StatefulWidget {
  @override
  _MedicationDetailScreenState createState() => _MedicationDetailScreenState();
}

class _MedicationDetailScreenState extends State<MedicationDetailScreen> {
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
      SnackBar(content: Text('Dose skipped for today')),
    );
  }

  void _handleDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Medication"),
          content: Text("Are you sure you want to delete this medication?"),
          actions: [
            TextButton(
              onPressed: () {
                // Handle deletion logic
                Navigator.of(context).pop();
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("No"),
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
        title: Text('Medication Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _handleEdit,
          ),
          IconButton(
            icon: Icon(Icons.delete),
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
            SizedBox(height: 16),
            Text(
              medicationName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
            ),
            SizedBox(height: 8),
            Text('Dosage: $dosage', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Schedule: $schedule', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Description: $description', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            LinearProgressIndicator(
              value: (daysDone / totalDays).clamp(0.0, 1.0),
              color: Theme.of(context).primaryColor,
              backgroundColor: Colors.grey[300],
            ),
            SizedBox(height: 8),
            Text('$daysDone/$totalDays days done'),
            SizedBox(height: 16),
            Text('Side Effects: Possible nausea and headache.', style: TextStyle(fontSize: 16)),
            Text('Tips: Take with food for better absorption.', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('Dosage History:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
            SizedBox(height: 16),
            Text('Storage Instructions:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Store in a cool, dry place away from direct sunlight.', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            // Expiration Date Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Expiration Date:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _handleSkip,
                  child: Text('Skip', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
                ElevatedButton(
                  onPressed: _handleDone,
                  child: Text('Done', style: TextStyle(color: Colors.white)),
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
        title: Text('Edit Medication'),
      ),
      body: Center(
        child: Text('Edit medication details here.'),
      ),
    );
  }
}