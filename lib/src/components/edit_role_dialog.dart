// File: lib/src/components/edit_role_dialog.dart
import 'package:flutter/material.dart';

class EditRoleDialog extends StatefulWidget {
  final dynamic user;
  final Function(String) onSave;

  const EditRoleDialog({required this.user, required this.onSave, Key? key}) : super(key: key);

  @override
  _EditRoleDialogState createState() => _EditRoleDialogState();
}

class _EditRoleDialogState extends State<EditRoleDialog> {
  late String selectedRole;

  @override
  void initState() {
    super.initState();
    selectedRole = widget.user['role'];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Role for ${widget.user['username']}'),
      content: DropdownButton<String>(
        value: selectedRole,
        onChanged: (String? newValue) {
          setState(() {
            selectedRole = newValue!;
          });
        },
        items: <String>[
          'admin', 'finance-1', 'finance-2', 'HR-1', 'HR-2', 'engi-1', 'engi-2', 'new-user'
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
          onPressed: () {
            widget.onSave(selectedRole);
            Navigator.of(context).pop();
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
