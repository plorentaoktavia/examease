import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testgo/app/controllers/auth_controller.dart';
import 'package:testgo/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
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
                  children: [
                    SizedBox(height: 30),
                    // Animated logo for a playful touch
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: Duration(seconds: 1),
                      builder: (_, double value, __) {
                        return Opacity(
                          opacity: value,
                          child: Transform.scale(
                            scale: value,
                            child: Image.asset(
                              'assets/images/examease.png',
                              height: 200,
                            ),
                          ),
                        );
                      },
                    ),
                    // SizedBox(height: 10),
                    // // Updated text with a custom font and style
                    // Text(
                    //   'Exam Ease',
                    //   style: TextStyle(
                    //     fontSize: 25,
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.redAccent,
                    //   ),
                    //   textAlign: TextAlign.center,
                    // ),
                    Text(
                      'Daftar dan ambil ujian dengan cepat dan mudah.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    // Animated input fields for a dynamic appearance
                    buildInputField(
                      controller: controller.cEmail,
                      label: "Email",
                      icon: Icons.email,
                    ),
                    SizedBox(height: 15),
                    buildInputField(
                      controller: controller.cPass,
                      label: "Password",
                      icon: Icons.lock,
                      obscureText: true,
                    ),
                    SizedBox(height: 30),
                    // Animated login button with a bounce effect
                    buildLoginButton(),
                    SizedBox(height: 20),
                    // Styled and animated forgot password button
                    buildForgotPasswordButton(),
                    SizedBox(height: 20),
                    // Creative sign-up section with a pulsing effect
                    buildSignUpSection(),
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
      style: TextStyle(color: Colors.redAccent),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.redAccent),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget buildLoginButton() {
    return InkWell(
      onTap: () => cAuth.login(controller.cEmail.text, controller.cPass.text),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.login, color: Colors.white),
            SizedBox(width: 10),
            Text(
              "Login",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildForgotPasswordButton() {
    return TextButton(
      onPressed: () => Get.toNamed(Routes.RESET_PASSWORD),
      child: AnimatedDefaultTextStyle(
        duration: Duration(milliseconds: 300),
        style: TextStyle(
          color: const Color.fromARGB(255, 248, 40, 40),
          fontStyle: FontStyle.italic,
        ),
        child: Text("Forgot Password?"),
      ),
    );
  }

  Widget buildSignUpSection() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 1, end: 1.1),
      duration: Duration(seconds: 1),
      builder: (_, double value, __) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account?",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(width: 5),
            InkWell(
              onTap: () => Get.toNamed(Routes.SIGNUP),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.redAccent,
                ),
                child: ScaleTransition(
                  scale: AlwaysStoppedAnimation(value),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
