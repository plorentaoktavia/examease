import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testgo/app/controllers/auth_controller.dart';
import 'package:testgo/app/modules/pendaftaran/controllers/pendaftaran_controller.dart';
import 'package:testgo/app/routes/app_pages.dart';
import 'package:testgo/app/utils/Loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:testgo/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MaterialApp(
      title: 'Your App Title',
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final CAuth = Get.put(AuthController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 3)),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder<User?>(
            stream: CAuth.streamAuthStatus,
            initialData: null,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.data != null && snapshot.data!.emailVerified == true) {
                  changeScreen(context); // Call the changeScreen function for navigation
                  return Container(); // Placeholder widget; actual UI is in changeScreen function
                } else {
                  return GetMaterialApp(
                    title: "Application",
                    initialRoute: Routes.LOGIN,
                    getPages: AppPages.routes,
                  );
                }
              }
              return SplashScreen();
            },
          );
        }
        return SplashScreen();
      },
    );
  }

  void changeScreen(BuildContext context) {
    Future(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GetMaterialApp(
            title: "Application",
            initialRoute: Routes.HOME,
            getPages: AppPages.routes,
          ),
        ),
      );
    });
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centers children vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Centers children horizontally
          children: [
            Image.asset(
              'assets/images/examease.png',
              width: 200,
              height: 200,
            ),
            // SizedBox(height: 16),
            // Text(
            //   'Test Go',
            //   textAlign: TextAlign.center, // Centers text within the Text widget
            //   style: TextStyle(
            //     fontSize: 22,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.red,
            //   ),
            // ),
             SizedBox(height: 20),
            // Circular progress indicator
            CircularProgressIndicator(
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}