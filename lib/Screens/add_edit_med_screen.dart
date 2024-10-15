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
  final TextEditingController _durationController = TextEditingController(); // New controller for duration
  String _selectedDosageValue = '1'; // Stores the dosage amount
  String _selectedDosageUnit = 'pill'; // Stores the dosage unit
  DateTime? _selectedStartDate; // Stores the start date of medication
  List<String> _timesPerDay = []; // Changed to start empty
  bool _isLoading = false; // Tracks if the form is being submitted

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _timesPerDay.add('08:00 AM'); // Add default time to the list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6936F5), // Set the full background color
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'New Medication',
          style: TextStyle(
            color: Color(0xFF6936F5), // Set the text title color
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
                    buildDurationField(), // Updated field for duration
                    buildTimePickerField(), // Field to select times per day
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _addMedication, // Handle medication submission
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Set button background color to white
                minimumSize: const Size(double.infinity, 50),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Color(0xFF6936F5))
                  : const Text(
                'Add Medication',
                style: TextStyle(
                  color: Color(0xFF6936F5), // Set button text color
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
        Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white, // Set field color to white
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(color: Color(0xFF6936F5)), // Set text color
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

  // New method for duration input field
  Widget buildDurationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Duration (1-60 days)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 8),
        TextField(
          controller: _durationController,
          keyboardType: TextInputType.number, // Only accept numbers
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white, // Set field color to white
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(color: Color(0xFF6936F5)), // Set text color
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  // Builds the field to allow selecting times per day for the medication
  Widget buildTimePickerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Times Per Day', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
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
                  color: Colors.white, // Set field color to white
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(time, style: const TextStyle(fontSize: 16, color: Color(0xFF6936F5))),
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
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
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
              color: Colors.white, // Set field color to white
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              selectedDate != null
                  ? DateFormat('dd/MM/yyyy').format(selectedDate)
                  : 'Select Date',
              style: const TextStyle(fontSize: 16, color: Color(0xFF6936F5)),
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
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white, // Set field color to white
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: currentValue,
            isExpanded: true,
            underline: const SizedBox(),
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: const TextStyle(color: Color(0xFF6936F5))), // Set text color
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  // Function to handle adding a new medication
  Future<void> _addMedication() async {
    if (_medicineController.text.isEmpty ||
        _durationController.text.isEmpty ||
        _selectedStartDate == null) {
      // Ensure all fields are filled
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final duration = int.tryParse(_durationController.text);
    if (duration == null || duration < 1 || duration > 60) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Duration must be a number between 1 and 60')),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      // Prepare the medication data to save in Firestore
      List<Map<String, dynamic>> schedule = _timesPerDay.map((time) {
        // Calculate the alarm trigger time for each time per day
        DateTime alarmTriggerTime = DateTime(
          _selectedStartDate!.year,
          _selectedStartDate!.month,
          _selectedStartDate!.day,
          int.parse(time.split(':')[0]) + (time.contains('PM') ? 12 : 0),
          int.parse(time.split(':')[1].split(' ')[0]),
        );

        return {
          'date': Timestamp.fromDate(_selectedStartDate!), // Start date for the medication
          'alarm_trigger_time': Timestamp.fromDate(alarmTriggerTime), // Alarm time for the medication
          'taken': false, // Initially set to not taken
        };
      }).toList();

      int totalDosages = duration * _timesPerDay.length; // Calculate total dosages

      await _firestore.collection('medications').add({
        'medicine': _medicineController.text,
        'dosage': {
          'value': int.parse(_selectedDosageValue),
          'unit': _selectedDosageUnit,
        },
        'start_date': Timestamp.fromDate(_selectedStartDate!), // Use Timestamp
        'duration': duration,
        'times_per_day': _timesPerDay,
        'schedule': schedule, // Ensure schedule field is populated
        'total_dosages': totalDosages, // Store total dosages
        'user_id': FirebaseAuth.instance.currentUser?.uid, // Store user ID
      });

      // Reset the fields after adding medication
      _medicineController.clear();
      _durationController.clear();
      _selectedStartDate = null;
      _timesPerDay = ['08:00 AM']; // Reset to default time
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Medication added successfully')),
      );

      // Navigate to the home screen after adding medication
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add medication')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  // Function to select a time for medication
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

  // Function to add another time to the medication schedule
  void _addTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
    );

    if (pickedTime != null) {
      setState(() {
        String formattedTime = pickedTime.format(context);
        if (!_timesPerDay.contains(formattedTime)) {
          _timesPerDay.add(formattedTime); // Add the selected time
        }
      });
    }
  }
}
