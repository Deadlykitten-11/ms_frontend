// File: lib/src/screens/homescreen.dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../components/account_dialog.dart';
import '../components/edit_role_dialog.dart';
import '../components/create_project_dialog.dart';
import '../components/sidebar.dart';
import '../services/user_service.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget? _selectedContent = Text('Welcome to the Dashboard!');
  bool _showSecondSidebar = false;
  List<Widget> _secondSidebarItems = [];
  List<Widget> _persistentProjects = [];
  final UserService _userService = UserService();
  String? _userRole;
  Dio? _dio;
  CookieJar? _cookieJar;
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _initDio();
    _loadUserRole();
  }

  Future<void> _initDio() async {
    if (_dio != null && _cookieJar != null) {
      return;
    }
    _dio = Dio();
    _cookieJar = CookieJar();
    _dio!.interceptors.add(CookieManager(_cookieJar!));
    print('Dio initialized with CookieManager for HomeScreen');
  }

  Future<void> _loadUserRole() async {
    try {
      print('Fetching user role');
      final response = await _dio!.get(
        'http://localhost:3000/api/auth/userinfo',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      print('User role response: ${response.statusCode}');
      if (response.statusCode == 200) {
        setState(() {
          _userRole = response.data['role'] ?? 'guest';
        });
      } else {
        print('Failed to fetch user role: ${response.statusCode}');
        setState(() {
          _userRole = 'guest';
        });
      }
    } catch (e) {
      print('Error fetching user role: $e');
      setState(() {
        _userRole = 'guest';
      });
    }
  }

  void _showAccountList(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AccountDialog(),
    );
  }

  void _updateContent(Widget content, List<Widget> secondSidebarItems) {
    setState(() {
      _selectedContent = content;
      _secondSidebarItems = secondSidebarItems;
      _showSecondSidebar = true;
    });
  }

  void _hideSecondSidebar() {
    setState(() {
      _showSecondSidebar = false;
    });
  }

  Future<void> _fetchPersonalDetails() async {
    try {
      print('Fetching personal details');
      final response = await _dio!.get(
        'http://localhost:3000/api/auth/users',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      print('Fetch personal details response: ${response.statusCode}');

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        setState(() {
          _selectedContent = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '用户信息:', // "User Information" in Chinese
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              for (var user in data)
                ListTile(
                  title: Text('Name: ${user['username']}'),
                  subtitle: Text('Position: ${user['role']}'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      _showEditRoleDialog(context, user);
                    },
                    child: Text('Edit'),
                  ),
                ),
            ],
          );
        });
      } else {
        setState(() {
          _selectedContent = Text('Failed to load user information');
        });
      }
    } catch (e) {
      print('Error fetching personal details: $e');
      setState(() {
        _selectedContent = Text('Error: $e');
      });
    }
  }

  void _showEditRoleDialog(BuildContext context, dynamic user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditRoleDialog(
          user: user,
          onSave: (newRole) async {
            try {
              print('Updating role for user: ${user['username']} to $newRole');
              final response = await _dio!.put(
                'http://localhost:3000/api/auth/users/${user['username']}',
                data: jsonEncode({'role': newRole}),
                options: Options(headers: {'Content-Type': 'application/json'}),
              );
              print('Update role response: ${response.statusCode}');
              if (response.statusCode == 200) {
                _fetchPersonalDetails();
              } else {
                print('Failed to update user role: ${response.statusCode}');
              }
            } catch (e) {
              print('Error updating user role: $e');
            }
          },
        );
      },
    );
  }

  void _createProject(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateProjectDialog(
          onCreate: (name, time, content) {
            setState(() {
              Widget newProject = ListTile(
                leading: Icon(Icons.folder),
                title: Text(name),
                onTap: () {},
              );
              _persistentProjects.add(newProject);
              _secondSidebarItems = [
                ListTile(
                  leading: Icon(Icons.create_new_folder),
                  title: Text('创建项目'),
                  onTap: () {
                    _createProject(context);
                  },
                ),
                ..._persistentProjects,
              ];
              _updateContent(Text('项目内容'), _secondSidebarItems);
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDE7F6), // Light purple background
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              '未蓝建工',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 10),
            Text(
              '主页', // Changed to Chinese "Home Page"
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple, // Deep purple app bar color
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              _showAccountList(context);
            },
          ),
        ],
      ),
      body: Row(
        children: [
          Sidebar(
            updateContent: _updateContent,
            createProject: () => _createProject(context),
            fetchPersonalDetails: _fetchPersonalDetails,
            userRole: _userRole,
          ),
          if (_showSecondSidebar)
            MouseRegion(
              onExit: (_) => _hideSecondSidebar(),
              child: Container(
                width: 200,
                color: Colors.deepPurple[200],
                child: ListView(
                  padding: EdgeInsets.all(8.0),
                  children: _secondSidebarItems,
                ),
              ),
            ),
          Expanded(
            child: Center(
              child: _selectedContent ?? Text('No content available'),
            ),
          ),
        ],
      ),
    );
  }
}
