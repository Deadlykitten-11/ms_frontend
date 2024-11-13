// File: lib/src/components/create_project_dialog.dart
import 'package:flutter/material.dart';

class CreateProjectDialog extends StatelessWidget {
  final Function(String, String, String) onCreate;

  CreateProjectDialog({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController timeController = TextEditingController();
    TextEditingController contentController = TextEditingController();

    return AlertDialog(
      title: Text('创建项目'), // 'Create Project' in Chinese
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: '项目名称'), // 'Project Name'
          ),
          TextField(
            controller: timeController,
            decoration: InputDecoration(labelText: '时间'), // 'Time'
          ),
          TextField(
            controller: contentController,
            decoration: InputDecoration(labelText: '项目内容'), // 'Project Content'
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('取消'), // 'Cancel' in Chinese
        ),
        TextButton(
          onPressed: () {
            onCreate(nameController.text, timeController.text, contentController.text);
            Navigator.of(context).pop();
          },
          child: Text('创建'), // 'Create' in Chinese
        ),
      ],
    );
  }
}
