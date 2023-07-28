import 'package:flutter/material.dart';


Future<dynamic> popUpMessenger(BuildContext context,
    {required String title,
    required VoidCallback onProceed,
    required VoidCallback onCancel,
    Color? titleColor,
    Color? optionOneColor,
    Color? optionTwoColor,
    required optionOne,
    required optionTwo}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title,
          style: TextStyle(color: titleColor ?? Colors.grey),
        ),
        
        actions: [
          TextButton(
            onPressed: onCancel,
            child: Text(
              optionTwo,
              style: TextStyle(color: optionTwoColor ?? Colors.blue),
            ),
          ),
          TextButton(
            onPressed: onProceed,
            child: Text(
              optionOne,
              style: TextStyle(color: optionOneColor ?? Colors.red),
            ),
          )
        ],
      );
    },
  );
}

// popUpTwo
Future<dynamic> popUpAlert({
  required BuildContext context,
  required String title,
  required VoidCallback optionOne,
  required VoidCallback optionTwo,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return SimpleDialog(
        backgroundColor: Colors.grey.shade800,
        title:  Text(title,
            style: const TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.w500)),
        
        children: [
          const SizedBox(
            height: 10,
          ),
          TextButton(
              onPressed: optionOne,
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              )),
          TextButton(
              onPressed: optionTwo,
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.blue),
              ))
        ],
      );
    },
  );
}
