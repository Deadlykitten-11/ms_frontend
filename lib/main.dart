import 'package:flutter/material.dart';
import 'src/screens/login_screen.dart'; // Replace with the correct path
import 'src/screens/signup_screen.dart'; // Replace with the correct path
import 'src/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor:
            Color.fromARGB(255, 42, 198, 15), // Custom color for theme
      ),
      home: LoginScreen(), // Set the initial screen to be the login page
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
