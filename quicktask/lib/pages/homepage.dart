// ignore_for_file: camel_case_types, library_private_types_in_public_api, non_constant_identifier_names, use_build_context_synchronously, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:intl/intl.dart';

class homePage extends StatefulWidget {
  static const routeName = '/home-page';
  final String userid;

  const homePage({super.key, required this.userid});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<homePage> {
  String selectedPriority = 'Low';
  DateTime selectedDate = DateTime.now();
  final TextEditingController taskNameController = TextEditingController();
  bool isOverdue = false;
  bool isCompleted = false;
  List<ParseObject> tasks = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDialog(context, 'Signed In as "${widget.userid}"');
      _fetchTaskList(context);
    });
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
      body: tasks.isEmpty
          ? Center(
              child:
                  Text('No tasks yet', style: GoogleFonts.roboto(fontSize: 20)),
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                ParseObject task = tasks[index];
                String objectid = task.get('objectId');
                String taskName = task.get('TaskName');
                DateTime dueDate = task.get('DueDate');
                String priority = task.get('Priority');
                bool completed = task.get('Completed');
                bool overdue = dueDate.isBefore(DateTime.now());
                String status = 'Open';
                if (completed) {
                  status = 'Completed';
                } else if (overdue) {
                  status = 'Overdue';
                }

                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  color: getColorByTasks(priority, overdue, completed),
                  child: ListTile(
                    title: Text(
                      taskName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      'Due by ${DateFormat('dd/MMM/yyyy').format(dueDate)}  |  $status',
                      style: const TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) => Container(
                          padding: const EdgeInsets.all(10.0),
                          color: Colors.blue[100],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Task Details',
                                style: GoogleFonts.openSans(
                                  color: Colors.blue[700],
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Divider(
                                thickness: 1.2,
                                color: Colors.blue[900],
                              ),
                              _buildTaskDetailRow('Task Name', taskName),
                              _buildTaskDetailRow('Due Date',
                                  DateFormat('dd/MMM/yyyy').format(dueDate)),
                              _buildTaskDetailRow('Priority', priority),
                              _buildTaskDetailRow('Status', status),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green[300]),
                                    onPressed: () async {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          String initialTaskName = taskName;
                                          String initialPriority = priority;
                                          bool initialIsCompleted = completed;
                                          DateTime initialDueDate = dueDate;
                                          bool initialIsOverdue =
                                              dueDate.isBefore(DateTime
                                                  .now());
                                          TextEditingController
                                              editTaskNameController =
                                              TextEditingController(
                                                  text: initialTaskName);
                                          TextEditingController
                                              editDueDateController =
                                              TextEditingController(
                                                  text: DateFormat(
                                                          'dd/MMM/yyyy')
                                                      .format(initialDueDate));

                                          return StatefulBuilder(
                                            builder: (BuildContext context,
                                                StateSetter setState) {
                                              return Container(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                color: Colors.blue[100],
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Task Details',
                                                      style:
                                                          GoogleFonts.openSans(
                                                        color: Colors.blue[700],
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Divider(
                                                      thickness: 1.2,
                                                      color: Colors.blue[900],
                                                    ),
                                                    _buildEditableTaskDetailRow(
                                                        'Task Name',
                                                        editTaskNameController),
                                                    TextField(
                                                      controller:
                                                          editDueDateController,
                                                      readOnly:
                                                          true,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText:
                                                            'Select Due Date',
                                                      ),
                                                      onTap: () async {
                                                        final DateTime? picked =
                                                            await showDatePicker(
                                                          context: context,
                                                          initialDate:
                                                              initialDueDate,
                                                          firstDate:
                                                              DateTime(2015, 8),
                                                          lastDate:
                                                              DateTime(2101),
                                                        );
                                                        if (picked != null &&
                                                            picked !=
                                                                initialDueDate) {
                                                          setState(() {
                                                            initialDueDate =
                                                                picked;
                                                            initialIsOverdue =
                                                                picked.isBefore(
                                                                    DateTime
                                                                        .now());
                                                            editDueDateController
                                                                .text = DateFormat(
                                                                    'dd/MMM/yyyy')
                                                                .format(
                                                                    picked);
                                                          });
                                                        }
                                                      },
                                                    ),
                                                    DropdownButtonFormField<
                                                        String>(
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText:
                                                            'Select Priority',
                                                      ),
                                                      value: initialPriority,
                                                      onChanged:
                                                          (String? newValue) {
                                                        setState(() {
                                                          initialPriority =
                                                              newValue!;
                                                        });
                                                      },
                                                      items: <String>[
                                                        'Low',
                                                        'Medium',
                                                        'High'
                                                      ].map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
                                                    ),
                                                    const SizedBox(
                                                        height: 20.0),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          'Overdue?',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        const SizedBox(
                                                            width: 20),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3.0),
                                                          child: Checkbox(
                                                            value:
                                                                initialIsOverdue,
                                                            onChanged:
                                                                null,
                                                            checkColor:
                                                                Colors.red,
                                                            activeColor:
                                                                Colors.yellow,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                        height: 20.0),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          'Completed?',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        const SizedBox(
                                                            width: 20),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3.0),
                                                          child: Checkbox(
                                                            value:
                                                                initialIsCompleted,
                                                            onChanged: (bool?
                                                                newValue) {
                                                              setState(() {
                                                                initialIsCompleted =
                                                                    newValue ??
                                                                        false;
                                                              });
                                                            },
                                                            checkColor: Colors
                                                                .green,
                                                            activeColor: Colors
                                                                .white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                        height: 20.0),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      Colors.green[
                                                                          300]),
                                                          onPressed: () async {                                                            
                                                            bool updated = await updateTask(
                                                                objectid,
                                                                editTaskNameController
                                                                    .text,
                                                                initialDueDate,
                                                                initialPriority,
                                                                initialIsCompleted);
                                                            if (updated) {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              _fetchTaskList(
                                                                  context);
                                                              _showDialog(
                                                                  context,
                                                                  'Task "${editTaskNameController.text}" updated successfully');
                                                            } else {
                                                              _showDialog(
                                                                  context,
                                                                  'Task "${taskName}" cannot be updated. Please try later');
                                                            }
                                                          },
                                                          child: const Text(
                                                              'Save',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black)),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      Colors.red[
                                                                          300]),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                              'Cancel',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black)),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                    child: const Text('Edit',
                                        style: TextStyle(color: Colors.black)),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red[300]),
                                    onPressed: () async {
                                      bool confirmDelete = await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:
                                                const Text("Confirm Deletion"),
                                            content: const Text(
                                                "Are you sure you want to delete this task?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(
                                                      false);
                                                },
                                                child: const Text("No"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(
                                                      true);
                                                },
                                                child: const Text("Yes"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      if (!confirmDelete) {
                                        return;
                                      }
                                      bool deleted = await deleteTask(objectid);
                                      if (deleted) {
                                        Navigator.of(context).pop();
                                        _fetchTaskList(context);
                                        _showDialog(context,
                                            'Task "$taskName" deleted successfully');
                                      } else {
                                        _showDialog(context,
                                            'Task "$taskName" cannot be deleted. Please try later');
                                      }
                                    },
                                    child: const Text('Delete',
                                        style: TextStyle(color: Colors.black)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[700],
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            String initialPriority = 'Low';
            DateTime initialDueDate = DateTime.now();
            bool initialIsOverdue = false;
            bool initialIsCompleted = false;
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  padding: const EdgeInsets.all(10.0),
                  color: Colors.blue[100],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                              String taskName = taskNameController.text;
                              if (taskName.isNotEmpty) {
                                taskNameController
                                    .clear();
                              }
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
                      _buildEditableTaskDetailRow(
                        'Task Name',
                        taskNameController,
                      ),
                      TextField(
                        controller: TextEditingController(
                          text:
                              DateFormat('dd/MMM/yyyy').format(initialDueDate),
                        ),
                        readOnly: true,
                        decoration: const InputDecoration(
                          hintText: 'Select Due Date',
                        ),
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: initialDueDate,
                            firstDate: DateTime(2015, 8),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null && picked != initialDueDate) {
                            setState(() {
                              initialDueDate = picked;
                              initialIsOverdue = picked.isBefore(
                                  DateTime.now());
                            });
                          }
                        },
                      ),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          hintText: 'Select Priority',
                        ),
                        value: initialPriority,
                        onChanged: (String? newValue) {
                          setState(() {
                            initialPriority = newValue!;
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
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Checkbox(
                              value: initialIsOverdue,
                              onChanged: null,
                              checkColor: Colors.red,
                              activeColor: Colors.yellow,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          const Text(
                            'Completed?',
                            style: TextStyle(color: Colors.black),
                          ),
                          const SizedBox(width: 20),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Checkbox(
                              value: initialIsCompleted,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  initialIsCompleted = newValue ?? false;
                                });
                              },
                              checkColor:
                                  Colors.green,
                              activeColor:
                                  Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[300],
                            ),
                            onPressed: () async {
                              String taskName = taskNameController.text;
                              if (taskName.isEmpty) {
                                _showDialog(
                                    context, "Task Name cannot be empty");
                                return;
                              }
                              String created = await createTask(
                                taskName,
                                initialDueDate,
                                initialPriority,
                                initialIsCompleted,
                              );
                              if (created.isEmpty) {
                                Navigator.of(context).pop();
                                _showDialog(
                                  context,
                                  'Task "$taskName" has been added',
                                );
                                taskNameController
                                    .clear();
                                _fetchTaskList(
                                  context,
                                );
                              } else {
                                _showDialog(
                                  context,
                                  'Task "$taskName" cannot be created right now. Please try again later',
                                );
                              }
                            },
                            child: const Text(
                              'Create',
                              style: TextStyle(
                                color: Color.fromARGB(137, 36, 31, 31),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[300],
                            ),
                            onPressed: () {
                              String taskName = taskNameController.text;
                              if (taskName.isNotEmpty) {
                                taskNameController.clear();
                              }
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Reset',
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        child: Icon(
          Icons.add,
          color: Colors.lightBlue[100],
        ),
      ),
    );
  }

  Future<void> _fetchTaskList(BuildContext context) async {
    try {
      QueryBuilder<ParseObject> querytasks =
          QueryBuilder<ParseObject>(ParseObject('TaskRecords'))
            ..whereEqualTo('UserId', widget.userid)
            ..orderByAscending('DueDate');
      final ParseResponse apiResponse = await querytasks.query();

      if (apiResponse.success && apiResponse.results != null) {
        setState(() {
          tasks = apiResponse.results as List<ParseObject>;
        });
      } else {
        setState(() {
          tasks = [];
        });
      }
    } catch (e) {
      _showDialog(context, "Error fetching tasks: $e");
    }
  }

  Future<String> createTask(String taskname, DateTime duedate, String priority,
      bool Completed) async {
    try {
      final query = ParseObject('TaskRecords')
        ..set('UserId', widget.userid)
        ..set('TaskName', taskname)
        ..set('Priority', priority)
        ..set('DueDate', duedate)
        ..set('Completed', Completed);

      final response = await query.save();

      if (response.success &&
          response.results != null &&
          response.results!.isNotEmpty) {
        return '';
      } else {
        return response.error!.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<bool> deleteTask(String id) async {
    try {
      var task = ParseObject('TaskRecords')..objectId = id;
      final response = await task.delete();
      if (response.success &&
          response.results != null &&
          response.results!.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateTask(String id, String taskname, DateTime duedate,
      String priority, bool Completed) async {
    try {
      var task = ParseObject('TaskRecords')
        ..objectId = id
        ..set('UserId', widget.userid)
        ..set('TaskName', taskname)
        ..set('Priority', priority)
        ..set('DueDate', duedate)
        ..set('Completed', Completed);
      final response = await task.save();
      if (response.success &&
          response.results != null &&
          response.results!.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Color getColorByTasks(String priority, bool overdue, bool completed) {
    if (completed == true) {
      return Colors.blue;
    } else if (overdue == true) {
      return Colors.orange;
    } else {
      switch (priority.toLowerCase()) {
        case 'low':
          return Colors.green;
        case 'medium':
          return Colors.yellow;
        case 'high':
          return Colors.red;
        default:
          return Colors.white;
      }
    }
  }

  void _showDialog(BuildContext context, String alertMsg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(""),
          content: Text(alertMsg),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTaskDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableTaskDetailRow(
      String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(
            width: 200,
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
