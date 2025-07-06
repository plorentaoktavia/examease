import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testgo/app/controllers/auth_controller.dart';

import '../../login/views/login_view.dart';
import '../controllers/signup_controller.dart';

// Extract a common TextStyle variable for consistency
final TextStyle commonTextStyle = TextStyle(
  fontSize: 18,
  color: Colors.redAccent,
);

final TextStyle blueTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.blue, // Set the color to blue
);

// Updated style for the "Register" text
final TextStyle registerTextStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.redAccent,
);

class SignupView extends GetView<SignupController> {
  final cAuth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.redAccent.withOpacity(0.1), // Set the background color
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/examease.png', // Replace with the correct path
                      height: 200,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Register',
                      style: registerTextStyle, // Apply the updated style
                    ),
                    SizedBox(height: 20),
                    buildInputField(
                      controller: controller.cEmail,
                      label: "Email",
                      icon: Icons.email,
                    ),
                    SizedBox(height: 20),
                    buildInputField(
                      controller: controller.cPass,
                      label: "Password",
                      icon: Icons.lock,
                      obscureText: true,
                    ),
                    SizedBox(height: 30),
                    buildSignupButton(),
                    SizedBox(height: 20),
                    buildAlreadyHaveAccountText(context), // Pass the context
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: commonTextStyle, // Use commonTextStyle
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.redAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget buildSignupButton() {
    return ElevatedButton.icon(
      onPressed: () => cAuth.signup(
        controller.cEmail.text,
        controller.cPass.text,
      ),
      icon: Icon(Icons.person_add, size: 24, color: Colors.white), // Set icon color to white
      label: Text(
        "Sign Up",
        style: TextStyle(fontSize: 18, color: Colors.white), // Set text color to white
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  Widget buildAlreadyHaveAccountText(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the login page
        Get.to(() => LoginView());
      },
      child: RichText(
        text: TextSpan(
          text: "Already have an account? ",
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          children: [
            TextSpan(
              text: "Sign In",
              style: blueTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
