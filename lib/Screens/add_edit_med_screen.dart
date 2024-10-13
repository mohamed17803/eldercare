import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore integration
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication
import 'package:intl/intl.dart'; // For date formatting
import 'home_screen.dart'; // Import the HomeScreen to navigate after adding medication

class EditScreen extends StatelessWidget {
  const EditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NewMedicationScreen();
  }
}

class NewMedicationScreen extends StatefulWidget {
  const NewMedicationScreen({super.key});

  @override
  _NewMedicationScreenState createState() => _NewMedicationScreenState();
}

class _NewMedicationScreenState extends State<NewMedicationScreen> {
  final TextEditingController _medicineController = TextEditingController();
  String _selectedDosageValue = '1'; // Stores the dosage amount
  String _selectedDosageUnit = 'pill'; // Stores the dosage unit
  DateTime? _selectedStartDate; // Stores the start date of medication
  String _selectedDuration = '3 days'; // Stores the duration of medication
  List<String> _timesPerDay = ['08:00 AM']; // Allows the user to select multiple times per day
  bool _isLoading = false; // Tracks if the form is being submitted

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'New Medication',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 27,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildInputField('Medicine', _medicineController),
                    buildDosageField(),
                    buildDatePickerField('Start Date', _selectedStartDate, (pickedDate) {
                      setState(() {
                        _selectedStartDate = pickedDate; // Set the selected start date
                      });
                    }),
                    buildDropdownField(
                      'Duration',
                      _selectedDuration,
                      ['3 days', '1 week', '2 weeks', '3 weeks', '1 month'],
                          (value) {
                        setState(() {
                          _selectedDuration = value!; // Update selected duration
                        });
                      },
                    ),
                    buildTimePickerField(), // Field to select times per day
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _addMedication, // Handle medication submission
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6936F5),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                'Add Medication',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builds the input field for medicine name
  Widget buildInputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF4F3F3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  // Builds the dosage selection with value and unit
  Widget buildDosageField() {
    return Row(
      children: [
        Expanded(
          child: buildDropdownField(
            'Dosage Amount',
            _selectedDosageValue,
            List.generate(10, (index) => '${index + 1}'),
                (value) {
              setState(() {
                _selectedDosageValue = value!; // Update dosage value
              });
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: buildDropdownField(
            'Dosage Unit',
            _selectedDosageUnit,
            ['pill', 'mg', 'ml', 'drops'],
                (value) {
              setState(() {
                _selectedDosageUnit = value!; // Update dosage unit
              });
            },
          ),
        ),
      ],
    );
  }

  // Builds the field to allow selecting times per day for the medication
  Widget buildTimePickerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Times Per Day', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Column(
          children: _timesPerDay
              .map((time) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: () => _selectTime(time),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F3F3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(time, style: const TextStyle(fontSize: 16)),
              ),
            ),
          ))
              .toList(),
        ),
        // Button to add another time if the user wants to take medication multiple times per day
        TextButton(
          onPressed: _addTime,
          child: const Text('+ Add Another Time', style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }

  // Date picker field for selecting the start date
  Widget buildDatePickerField(String label, DateTime? selectedDate, Function(DateTime) onDateSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null) {
              onDateSelected(pickedDate); // Update selected date
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F3F3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              selectedDate != null
                  ? DateFormat('dd/MM/yyyy').format(selectedDate)
                  : 'Select Date',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  // Builds dropdown fields (used for dosage, duration, etc.)
  Widget buildDropdownField(String label, String currentValue, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F3F3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: currentValue,
            isExpanded: true,
            underline: const SizedBox(),
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  // Adds another time slot for medication
  void _addTime() {
    setState(() {
      _timesPerDay.add('08:00 AM'); // Default time added, can be changed by user
    });
  }

  // Allows user to select the time for taking the medication
  Future<void> _selectTime(String currentTime) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
    );
    if (pickedTime != null) {
      setState(() {
        int index = _timesPerDay.indexOf(currentTime);
        _timesPerDay[index] = pickedTime.format(context); // Updates the selected time
      });
    }
  }

  // Handles the "Add Medication" button press to save medication details to Firestore
  Future<void> _addMedication() async {
    if (_medicineController.text.isEmpty || _selectedStartDate == null) {
      // Show an error message if required fields are empty
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill out all fields')));
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      // Retrieve the current user's UID
      User? user = FirebaseAuth.instance.currentUser; // Get the logged-in user
      String userId = user!.uid; // Extract the user's ID

      // Generate the Firestore document
      await _firestore.collection('medications').add({
        'medication_name': _medicineController.text,
        'medication_type': _selectedDosageUnit,
        'dosage': {
          'value': int.parse(_selectedDosageValue),
          'unit': _selectedDosageUnit,
        },
        'schedule': _generateSchedule(), // Generates the medication schedule
        'user_id': userId, // Use the authenticated user's ID
        'progress_count': 0,
        'total_dosages': _timesPerDay.length * _getDurationInDays(),
        'progress_line': '0/${_timesPerDay.length * _getDurationInDays()}',
        'start_date': _selectedStartDate,
        'duration': _getDurationInDays(),
        'created_at': DateTime.now(), // Ensure created_at is set
        'notes': 'Take with food if needed.', // Allow users to edit this
      });

      // Show a SnackBar to inform the user that the medication has been added
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Medication added and alarm set!'),
          duration: Duration(seconds: 3), // Set the SnackBar to appear for 3 seconds
        ),
      );

      // Navigate to the HomeScreen after medication is added
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      // Show error message if something went wrong
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to add medication')));
    } finally {
      setState(() {
        _isLoading = false; // Stop loading indicator
      });
    }
  }

  // Helper function to calculate the duration in days from the selected duration
  int _getDurationInDays() {
    if (_selectedDuration == '3 days') return 3;
    if (_selectedDuration == '1 week') return 7;
    if (_selectedDuration == '2 weeks') return 14;
    if (_selectedDuration == '3 weeks') return 21;
    if (_selectedDuration == '1 month') return 30;
    return 0;
  }

  // Generates a schedule for the medication based on the times per day and start date
  List<Map<String, dynamic>> _generateSchedule() {
    List<Map<String, dynamic>> schedule = [];
    for (int i = 0; i < _getDurationInDays(); i++) {
      for (String time in _timesPerDay) {
        schedule.add({
          'date': _selectedStartDate!.add(Duration(days: i)),
          'time': time,
          'taken': false, // Mark the medication as not yet taken
        });
      }
    }
    return schedule;
  }
}
