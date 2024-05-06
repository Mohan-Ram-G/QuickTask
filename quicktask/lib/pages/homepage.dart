import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class homePage extends StatelessWidget {
  static const routeName = '/home-page';

  const homePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.lightBlue[100],
        title: Text(
          'Home',
          style: GoogleFonts.teko(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[700],
      ),
      body: Center(
        child: Text('No tasks yet', style: GoogleFonts.roboto(fontSize: 20)),
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
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(
                          Icons.close,
                          color: Colors.red,
                        )),
                  ],
                ),
                Divider(
                  thickness: 1.2,
                  color: Colors.blue[900],
                ),
                SizedBox(height: 20.0),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.blue)),
                      fillColor: Colors.white54,
                      filled: true,
                      hintText: 'Enter Task Name'),
                ),
                SizedBox(height: 20.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  child: Row(
                    children: [
                      Container(
                        width: (MediaQuery.of(context).size.width / 2) - 40,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[300]),
                            onPressed: () => print('Input Added'),
                            child: Text(
                              'Create',
                              style: GoogleFonts.openSans(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                      Container(
                        width: (MediaQuery.of(context).size.width / 2) - 40,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[300]),
                            onPressed: () => print('Input Cleared'),
                            child: Text(
                              'Reset',
                              style: GoogleFonts.openSans(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            )),
                      )
                    ],
                  ),
                )
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
}
