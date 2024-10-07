import 'package:flutter/material.dart';

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
  String _selectedDosage = '1 pill';
  DateTime? _selectedDate;
  String _selectedSchedule = 'Day 1';
  String _selectedDuration = '3 days';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'New medication',
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
                    buildDropdownField(
                      'Dosage',
                      _selectedDosage,
                      List.generate(10, (index) => '${index + 1} pill${index > 0 ? 's' : ''}'),
                          (value) {
                        setState(() {
                          _selectedDosage = value!;
                        });
                      },
                    ),
                    buildDatePickerField('Begin taking', _selectedDate, (pickedDate) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }),
                    buildDropdownField(
                      'Schedule',
                      _selectedSchedule,
                      List.generate(7, (index) => 'Day ${index + 1}'),
                          (value) {
                        setState(() {
                          _selectedSchedule = value!;
                        });
                      },
                    ),
                    buildDropdownField(
                      'Duration',
                      _selectedDuration,
                      ['3 days', '1 week', '2 weeks', '3 weeks', '1 month'],
                          (value) {
                        setState(() {
                          _selectedDuration = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle add medication action here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6936F5),
                minimumSize: Size(double.infinity, 50),
              ),
              child: const Text(
                'Add medication',
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

  Widget buildInputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFF4F3F3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }

  Widget buildDropdownField(String label, String currentValue, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Color(0xFFF4F3F3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: currentValue,
            isExpanded: true,
            underline: SizedBox(),
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }

  Widget buildDatePickerField(String label, DateTime? selectedDate, Function(DateTime) onDateSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null) {
              onDateSelected(pickedDate);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFFF4F3F3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              selectedDate != null
                  ? "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"
                  : 'Select Date',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
