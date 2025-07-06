import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testgo/app/routes/app_pages.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  Stream<User?> get streamAuthStatus => auth.authStateChanges();

  void signup(String emailAddress, String password) async {
    try {
      if (emailAddress.isEmpty || password.isEmpty) {
        // Show notification for empty email or password
        Get.snackbar(
          "Error",
          "Email dan password tidak boleh kosong.",
          backgroundColor: Colors.amber,
          colorText: Colors.black,
        );
        return;
      }

      UserCredential myUser = await auth.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      await myUser.user!.sendEmailVerification();

      Get.snackbar(
        "Verifikasi email",
        "Kami telah mengirimkan verifikasi ke email $emailAddress.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
        snackPosition: SnackPosition.TOP,
      );

      Get.defaultDialog(
        title: "Verifikasi email",
        middleText: "Kami telah mengirimkan verifikasi ke email $emailAddress.",
        onConfirm: () {
          Get.back(); // Close dialog
          Get.back(); // Navigate back to login
        },
        textConfirm: "OK",
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar(
          "Error",
          "Password terlalu lemah. Gunakan password yang lebih kuat.",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar(
          "Error",
          "Akun sudah ada dengan email tersebut.",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      } else if (e.code == 'invalid-email') {
        Get.snackbar(
          "Error",
          "Format email tidak valid.",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      } else {
        // Handle other FirebaseAuthException cases
        Get.snackbar(
          "Error",
          "Terjadi kesalahan: ${e.message}",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
  print("Signup Error Type: ${e.runtimeType}");
  print("Signup Error: $e");
  Get.snackbar(
    "Error",
    "Terjadi kesalahan: $e",
    backgroundColor: Colors.redAccent,
    colorText: Colors.white,
  );
}

  }

  void login(String email, String pass) async {
    try {
      if (email.isEmpty || pass.isEmpty) {
        // Show notification for empty email or password
        Get.snackbar(
          "Error",
          "Email dan password tidak boleh kosong.",
          backgroundColor: Colors.amber,
          colorText: Colors.black,
        );
        return;
      }

      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );

      // If successful, navigate to the home screen
      Get.offAllNamed(Routes.HOME);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar(
          "Proses Gagal",
          "No user found for that email.",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      } else if (e.code == 'wrong-password') {
        Get.snackbar(
          "Proses Gagal",
          "Wrong password provided for that user.",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Proses Gagal",
          "Terjadi kesalahan saat proses autentikasi: ${e.message}",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Proses Gagal",
        "Terjadi kesalahan yang tidak terduga: $e",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  void logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAllNamed(Routes
          .LOGIN); // Replace 'LOGIN' with the route name of your login screen
    } catch (e) {
      print('Logout Error: $e');
      Get.defaultDialog(
        title: "Proses Gagal",
        middleText: "Terjadi kesalahan saat proses logout.",
      );
    }
  }

  void resetPassword(String email) async {
    if (email.isNotEmpty && GetUtils.isEmail(email)) {
      try {
        await auth.sendPasswordResetEmail(email: email);
        Get.snackbar(
          "Berhasil",
          "Kami telah mengirimkan reset password ke $email",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 5),
          snackPosition: SnackPosition.TOP,
        );
      } catch (e) {
        Get.snackbar(
          "Terjadi kesalahan",
          "Tidak dapat melakukan reset password.",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        "Terjadi kesalahan",
        "Email tidak valid",
        backgroundColor: Colors.amber,
        colorText: Colors.black,
      );
    }
  }
}
