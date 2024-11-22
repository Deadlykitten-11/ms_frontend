import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:io' as io;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Dio? _dio;
  CookieJar? _cookieJar;
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _initDio();
  }

  Future<void> _initDio() async {
    if (_dio != null && _cookieJar != null) {
      return;
    }
    _dio = Dio();

    // Use PersistCookieJar for non-web environments
    if (io.Platform.isAndroid || io.Platform.isIOS || io.Platform.isLinux || io.Platform.isMacOS || io.Platform.isWindows) {
      _cookieJar = PersistCookieJar();
    } else {
      // Use in-memory CookieJar for web or other unsupported platforms
      _cookieJar = CookieJar();
    }

    _dio!.interceptors.add(CookieManager(_cookieJar!));
    print('Dio initialized with CookieManager for LoginScreen');
  }

  Future<void> _login() async {
    const String url = "http://localhost:3000/api/auth/login";

    try {
      print('Logging in with username: ${usernameController.text}');
      final response = await _dio!.post(
        url,
        data: jsonEncode({
          "username": usernameController.text,
          "password": passwordController.text,
        }),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print('Login response: ${response.statusCode}');
      if (response.statusCode == 200) {
        // Save JWT token to secure storage for later use
        String token = response.data['token'];
        await storage.write(key: 'jwt_token', value: token);

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        final responseData = response.data;
        String errorMessage = responseData['message'] ?? 'Login failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      print('Error during login: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDE7F6), // Light purple background
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'MTMS',
                    style: TextStyle(
                        fontSize: 36,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Multiple Tasks Matching System - Management Portal',
                    style: TextStyle(fontSize: 20, color: Colors.deepPurple),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '未蓝建工工程管理系统',
                    style: TextStyle(fontSize: 24, color: Colors.deepPurple),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Form(
                key: _formKey,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Color(0xFFF8BBD0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextFormField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            border: InputBorder.none,
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Color(0xFFF8BBD0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: InputBorder.none,
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _login();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              '© 2024 MTMS - Longjun Dong, 董泷骏. All rights reserved.',
              style: TextStyle(color: Colors.deepPurple, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
