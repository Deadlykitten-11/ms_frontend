import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  // Define TextEditingControllers for each field
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers when the widget is destroyed
    usernameController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    positionController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> submitSignupForm(
    String username,
    String password,
    String name,
    String phone,
    String position,
    String email,
  ) async {
    const String url =
        "http://localhost:3000/signup"; // Replace with your backend endpoint

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "username": username,
          "password": password,
          "name": name,
          "phone": phone,
          "position": position,
          "email": email,
        }),
      );

      if (response.statusCode == 201) {
        // Success: Navigate to the login page
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        // Handle failure
        final responseData = jsonDecode(response.body);
        String errorMessage = 'Failed to sign up';
        
        if (responseData['errors'] != null) {
          List<dynamic> errors = responseData['errors'];
          errorMessage = errors.map((e) => e['msg']).join('\n');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      // Handle any exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: usernameController, // Attach the controller
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController, // Attach the controller
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: nameController, // Attach the controller
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: phoneController, // Attach the controller
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: positionController, // Attach the controller
                decoration: InputDecoration(labelText: 'Position'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your position';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: emailController, // Attach the controller
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Submit form data to the backend
                    submitSignupForm(
                      usernameController.text,
                      passwordController.text,
                      nameController.text,
                      phoneController.text,
                      positionController.text,
                      emailController.text,
                    );
                  }
                },
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
