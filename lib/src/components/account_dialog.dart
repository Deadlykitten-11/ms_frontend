// File: lib/src/components/account_dialog.dart
import 'package:flutter/material.dart';

class AccountDialog extends StatelessWidget {
  const AccountDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                title: Text('Name: John Doe'),
              ),
              ListTile(
                leading: Icon(Icons.work),
                title: Text('Position: Developer'),
              ),
              ListTile(
                leading: Icon(Icons.email),
                title: Text('Account: johndoe@example.com'),
              ),
              ListTile(
                leading: Icon(Icons.lock),
                title: Text('Secure Level: High'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

