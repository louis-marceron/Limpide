import 'package:flutter/material.dart';

Future<bool?> showConfirmationDeletionDialog(
    BuildContext context, String message, String toBeDeleted) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirmation'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pop(false); // Dismiss the dialog and return false
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pop(true); // Dismiss the dialog and return true
            },
            child: Text(
              'Delete ' + toBeDeleted,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}
