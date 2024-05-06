import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class loginPage extends StatelessWidget {
  static const routeName = '/login-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to',
              style: GoogleFonts.bebasNeue(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellowAccent),
            ),
            Text(
              'QuickTask Manager',
              style: GoogleFonts.bebasNeue(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellowAccent),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showSignUpModal(context);
                  },
                  child: Text('Sign Up'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showLoginModal(context);
                  },
                  child: Text('Log In'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSignUpModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => Container(
        padding: const EdgeInsets.all(10.0),
        color: Colors.blue[100],
        constraints: BoxConstraints(
          maxHeight:
              MediaQuery.of(context).size.height * 0.7, // Set maximum height
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sign Up',
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
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 1.2,
              color: Colors.blue[900],
            ),
            SizedBox(height: 20),
            // Add your sign up fields here
            TextField(
              decoration: InputDecoration(
                labelText: 'User ID',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Full Name',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email ID',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Phone Number',
              ),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(Icons.visibility),
                  onPressed: () {
                    // Toggle password visibility
                  },
                ),
              ),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                suffixIcon: IconButton(
                  icon: Icon(Icons.visibility),
                  onPressed: () {
                    // Toggle password visibility
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement sign up logic
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

  void _showLoginModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Container(
        padding: const EdgeInsets.all(10.0),
        height: 300,
        color: Colors.blue[100],
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Log In',
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
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 1.2,
              color: Colors.blue[900],
            ),
            SizedBox(height: 20),
            // Add your login fields here
            TextField(
              decoration: InputDecoration(
                labelText: 'Email, User ID, or Phone Number',
              ),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(Icons.visibility),
                  onPressed: () {
                    // Toggle password visibility
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement login logic
              },
              child: Text('Log In'),
            ),
          ],
        ),
      ),
    );
  }
}
