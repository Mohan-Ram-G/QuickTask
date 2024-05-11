import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'homepage.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class loginPage extends StatelessWidget {
  static const routeName = '/login-page';

  const loginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      resizeToAvoidBottomInset: false,
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
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showSignUpModal(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreenAccent),
                  child: const Text('Sign Up',
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold)),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showSignInModal(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent),
                  child: const Text('Sign In',
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSignUpModal(BuildContext context) {
    final TextEditingController userIdController = TextEditingController();
    final TextEditingController fullNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: Colors.blue[100],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
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
              const SizedBox(height: 20),
              TextField(
                controller: userIdController,
                decoration: InputDecoration(
                  labelText: 'User ID',
                ),
              ),
              TextField(
                controller: fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                ),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email ID',
                ),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                ),
              ),
              PasswordTextField(
                controller: passwordController,
                labelText: 'Password',
              ),
              PasswordTextField(
                controller: confirmPasswordController,
                labelText: 'Confirm Password',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Implement sign up logic
                  String userId = userIdController.text.toUpperCase();
                  String fullName = fullNameController.text;
                  String email = emailController.text;
                  String phone = phoneController.text;
                  String password = passwordController.text;
                  String confirmPassword = confirmPasswordController.text;

                  // Check if passwords match
                  if (password != confirmPassword) {
                    // Passwords don't match, show error
                    _showDialog(context, 'Passwords do not match');
                    return;
                  }
                  bool userExists =
                      await getUser(userId, password, context, false);
                  if (userExists) {
                    _showDialog(
                        context, 'User already exists. Please sign in.');
                    return;
                  }

                  // Call createUser function
                  bool userCreated = await createUser(
                      fullName, userId, email, phone, password, context);
                  if (userCreated) {
                    // Close the bottom sheet and clear the text controllers
                    userIdController.clear();
                    fullNameController.clear();
                    emailController.clear();
                    phoneController.clear();
                    passwordController.clear();
                    confirmPasswordController.clear();
                    Navigator.of(context).pop();
                  } else {
                    return;
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreenAccent),
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showSignInModal(BuildContext context) {
    final TextEditingController loginController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: Colors.blue[100],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sign In',
                    style: GoogleFonts.openSans(
                      color: Colors.blue[700],
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
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
              const SizedBox(height: 20),
              TextField(
                controller: loginController,
                decoration: InputDecoration(
                  labelText: 'User ID',
                ),
              ),
              PasswordTextField(
                controller: passwordController,
                labelText: 'Password',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String userId = loginController.text.toUpperCase();
                  String password = passwordController.text;
                  bool userLoggedIn =
                      await getUser(userId, password, context, true);
                  if (userLoggedIn) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              homePage(userid: userId)),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent),
                child: const Text('Sign In'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> createUser(String fullName, String userId, String email,
      String phone, String password, BuildContext context) async {
    if (fullName.isEmpty || userId.isEmpty) return false;
    final user = ParseObject('UserRecords')
      ..set('UserName', fullName)
      ..set('UserId', userId)
      ..set('EmailId', email)
      ..set('MobileNo', int.parse(phone))
      ..set('Password', password);

    final response = await user.save();
    if (response.success) {
      _showDialog(
          context, 'User Signed Up Successfully. Please sign in to continue');
      return true;
    } else {
      _showDialog(context, 'Error signing up user: ${response.error!.message}');
      return false;
    }
  }

  Future<bool> getUser(
      String userId, String password, BuildContext context, bool dialog) async {
    try {
      final query = QueryBuilder(ParseObject('UserRecords'))
        ..whereEqualTo('UserId', userId)
        ..whereEqualTo("Password", password);

      final response = await query.query();

      if (response.success &&
          response.results != null &&
          response.results!.isNotEmpty) {
        if (dialog == true) {
          _showDialog(context, 'Success: Redirecting to Task List');
        }
        return true; // User exists
      } else {
        if (dialog == true) {
          _showDialog(context, 'Error: ${response.error!.message}');
        }
        return false; // User does not exist
      }
    } catch (e) {
      _showDialog(context, 'Error: $e');
      return false; // Assume user does not exist in case of any error
    }
  }
}

void _showDialog(BuildContext context, String alertMsg) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Alert"),
        content: Text(alertMsg),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text("OK"),
          ),
        ],
      );
    },
  );
}

class PasswordTextField extends StatefulWidget {
  final String labelText;
  final TextEditingController? controller;

  const PasswordTextField({Key? key, required this.labelText, this.controller})
      : super(key: key);

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: widget.labelText,
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
}
