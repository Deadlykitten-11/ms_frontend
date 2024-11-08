import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  void _showAccountList(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.centerRight,
          child: Material(
            elevation: 16,
            child: Container(
              width: 300,
              color: Colors.white,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text(
                        'Name: John Doe'), // Example data, replace with server data
                  ),
                  ListTile(
                    leading: Icon(Icons.work),
                    title: Text(
                        'Position: Developer'), // Example data, replace with server data
                  ),
                  ListTile(
                    leading: Icon(Icons.email),
                    title: Text(
                        'Account: johndoe@example.com'), // Example data, replace with server data
                  ),
                  ListTile(
                    leading: Icon(Icons.lock),
                    title: Text(
                        'Secure Level: High'), // Example data, replace with server data
                  ),
                ],
              ),
            ),
          ),
        );
      },
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

// Access to the backend server to catch the information
  Future<void> _fetchPersonalDetails() async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost:3000/api/auth/users')); // Modified the URL to match the new endpoint
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _selectedContent = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '用户信息:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
      setState(() {
        _selectedContent = Text('Error: ${e.toString()}');
      });
    }
  }

  void _showEditRoleDialog(BuildContext context, dynamic user) {
    String selectedRole = user['role'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Edit Role for ${user['username']}'),
              content: DropdownButton<String>(
                value: selectedRole,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedRole = newValue!;
                  });
                },
                items: <String>[
                  'admin',
                  'finance-1',
                  'finance-2',
                  'HR-1',
                  'HR-2',
                  'engi-1',
                  'engi-2',
                  'new-user'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    // Attempt to update the user role
                    bool success =
                        await _updateUserRole(user['username'], selectedRole);
                    if (mounted) {
                      if (success) {
                        if (Navigator.canPop(context)) {
                          Navigator.of(context).pop(); // Close the dialog box
                        }
                        _fetchPersonalDetails(); // Refresh user data after updating the role
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to update user role'),
                          ),
                        );
                      }
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<bool> _updateUserRole(String username, String newRole) async {
    try {
      print(
          'Starting user role update for username: $username with role: $newRole');

      // Update the request to use username instead of id
      final response = await http.put(
        Uri.parse(
            'http://localhost:3000/api/auth/users/$username'), // Use the username in the URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'role': newRole}),
      );

      if (response.statusCode == 200) {
        print('User role successfully updated');
        return true;
      } else {
        print('Failed to update user role: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error updating user role: $e');
      return false;
    }
  }

  void _createProject(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController nameController = TextEditingController();
        TextEditingController timeController = TextEditingController();
        TextEditingController contentController = TextEditingController();
        return AlertDialog(
          title: Text('创建项目'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: '项目名称'),
              ),
              TextField(
                controller: timeController,
                decoration: InputDecoration(labelText: '时间'),
              ),
              TextField(
                controller: contentController,
                decoration: InputDecoration(labelText: '项目内容'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  Widget newProject = ListTile(
                    leading: Icon(Icons.folder),
                    title: Text(nameController.text),
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
                Navigator.of(context).pop();
              },
              child: Text('创建'),
            ),
          ],
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
          Container(
            width: 200,
            color: Colors.deepPurple[100],
            child: ListView(
              padding: EdgeInsets.all(8.0),
              children: [
                ListTile(
                  leading: Icon(Icons.terminal),
                  title: Text('项目概览'),
                  onTap: () {
                    _updateContent(Text('项目内容'), [
                      ListTile(
                        leading: Icon(Icons.create_new_folder),
                        title: Text('创建项目'),
                        onTap: () {
                          _createProject(context);
                        },
                      ),
                      ..._persistentProjects,
                    ]);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.science),
                  title: Text('材料管理'),
                  onTap: () {
                    _updateContent(Text('材料管理内容'), [
                      ListTile(
                        leading: Icon(Icons.shopping_cart),
                        title: Text('采购'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.local_shipping),
                        title: Text('运输'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.home_work),
                        title: Text('入库'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.check_circle),
                        title: Text('查验'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.outbox),
                        title: Text('出库'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.inventory),
                        title: Text('库存'),
                        onTap: () {},
                      ),
                    ]);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.compress),
                  title: Text('施工管理'),
                  onTap: () {
                    _updateContent(Text('施工管理内容'), [
                      ListTile(
                        leading: Icon(Icons.timeline),
                        title: Text('施工进度'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.shield),
                        title: Text('安全风险'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.assignment),
                        title: Text('项目要求'),
                        onTap: () {},
                      ),
                    ]);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.money),
                  title: Text('财务管理'),
                  onTap: () {
                    _updateContent(Text('财务管理内容'), [
                      ListTile(
                        leading: Icon(Icons.attach_money),
                        title: Text('预算'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.receipt),
                        title: Text('开支'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.account_balance),
                        title: Text('收入'),
                        onTap: () {},
                      ),
                    ]);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.build),
                  title: Text('用户信息及权限'),
                  onTap: () {
                    _updateContent(Text('Components Content'), [
                      ListTile(
                        leading: Icon(Icons.attach_money),
                        title: Text('用户信息'),
                        onTap: _fetchPersonalDetails,
                      ),
                      ListTile(
                        leading: Icon(Icons.receipt),
                        title: Text('权限管理'),
                        onTap: () {},
                      ),
                    ]);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.build),
                  title: Text('Components2'),
                  onTap: () {
                    _updateContent(Text('Components2 Content'), []);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('设置'),
                  onTap: () {
                    _updateContent(Text('设置内容'), []);
                  },
                ),
              ],
            ),
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

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}
