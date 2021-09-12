import 'package:flutter/material.dart';

Future<void> showAlertDialog({required BuildContext context, required String title, required String description}) => showDialog<void>(
  context: context,
  barrierDismissible: true,
  builder: (context) => AlertDialog(
    title: Text(title),
    content: SingleChildScrollView(
      child: Text(description),
    ),
    actions: <Widget>[
      TextButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  )
);

Future<void> showEditTextDialog({required BuildContext context, required String title, required String description, required TextEditingController controller, required onPressed, textFieldLabel = '', onChanged}) {
  bool isValid = false;
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(title),
        content: TextField(
          decoration: InputDecoration(hintText: textFieldLabel),
          controller: controller,
          onChanged: (text) {
            setState(() {
              isValid = text.isNotEmpty;
            });
          },
        ),
        actions: <Widget>[
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              controller.clear();
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text("Save"),
            onPressed: isValid ? onPressed : null,
          ),
        ],
      )
    )
  );
}