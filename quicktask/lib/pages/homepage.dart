import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class homePage extends StatefulWidget {
  static const routeName = '/home-page';

  const homePage({super.key});

  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  String _selectedPriority = 'Low'; // Default priority
  DateTime selectedDate = DateTime.now();
  final TextEditingController _taskNameController = TextEditingController();
  bool _isOverdue = false; // Initialize overdue checkbox value

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        // Automatically set the "Overdue?" checkbox if the selectedDate is in the past
        _isOverdue = picked.isBefore(DateTime.now());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.lightBlue[100],
        title: Text(
          'QuickTask Manager',
          style: GoogleFonts.teko(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[700],
      ),
      body: GestureDetector(
        onTap: () {
          _clearFields();
          Navigator.of(context).pop();
        },
        child: Center(
          child: Text('No tasks yet', style: GoogleFonts.roboto(fontSize: 20)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[700],
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (BuildContext context) => Container(
            padding: const EdgeInsets.all(10.0),
            height: 500,
            color: Colors.blue[100],
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Create a task',
                      style: GoogleFonts.openSans(
                        color: Colors.blue[700],
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _clearFields();
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                Divider(
                  thickness: 1.2,
                  color: Colors.blue[900],
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: _taskNameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Task Name',
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  child: Row(
                    children: [
                      SizedBox(
                        width: (MediaQuery.of(context).size.width / 2 - 20),
                        child: Text(
                          "${selectedDate.toLocal()}".split(' ')[0],
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width / 2 - 30),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber[300]),
                          onPressed: () => _selectDate(context),
                          child: Text(
                            'Select Due Date',
                            style: GoogleFonts.aBeeZee(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    hintText: 'Select Priority',
                  ),
                  value: _selectedPriority,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPriority = newValue!;
                    });
                  },
                  items: <String>['Low', 'Medium', 'High']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    const Text(
                      'Overdue?',
                      style: TextStyle(color: Colors.black),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      // decoration: BoxDecoration(
                      //   border: Border.all(color: Colors.red),
                      //   shape: BoxShape.circle,
                      // ),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Checkbox(
                          value: _isOverdue,
                          onChanged: null, // Make the checkbox not editable
                          checkColor: Colors.red,
                          activeColor: Colors.yellow,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  child: Row(
                    children: [
                      SizedBox(
                        width: (MediaQuery.of(context).size.width / 2) - 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[300],
                          ),
                          onPressed: () {
                            print('Task Created');
                            _clearFields();
                          },
                          child: Text(
                            'Create',
                            style: GoogleFonts.openSans(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width / 2) - 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[300],
                          ),
                          onPressed: () {
                            _clearFields();
                          },
                          child: Text(
                            'Reset',
                            style: GoogleFonts.openSans(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        child: Icon(
          Icons.add,
          color: Colors.lightBlue[100],
        ),
      ),
    );
  }

  void _clearFields() {
    setState(() {
      _taskNameController.clear();
      _selectedPriority = 'Low'; // Reset the priority
      selectedDate = DateTime.now(); // Reset the date
      _isOverdue = false;
    });
  }
}
