import 'package:flutter/material.dart';
import '../components/account_dialog.dart';
import '../components/edit_role_dialog.dart';
import '../components/create_project_dialog.dart';
import '../components/sidebar.dart';
import '../services/user_service.dart';

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

  // Introduce the account information on the top right side
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
    final userService = UserService();

    try {
      List<dynamic>? data = await userService.fetchPersonalDetails();

      if (data != null) {
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
      setState(() {
        _selectedContent = Text('Error: ${e.toString()}');
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
            bool success =
                await _userService.updateUserRole(user['username'], newRole);
            if (success) {
              _fetchPersonalDetails();
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
