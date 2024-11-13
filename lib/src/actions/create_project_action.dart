import 'package:flutter/material.dart';
import '../components/create_project_dialog.dart';

class CreateProjectAction {
  static void showCreateProjectDialog({
    required BuildContext context,
    required Function(String name, String time, String content) onCreate,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateProjectDialog(
          onCreate: onCreate,
        );
      },
    );
  }
}
