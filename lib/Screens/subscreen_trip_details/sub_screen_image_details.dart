import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wanderlust_new/database/database_helper.dart';

import '../../utils/messages/popup.dart';

class ScreenImageView extends StatelessWidget {
  const ScreenImageView({super.key, required this.imagepath, required this.id});
  final String imagepath;
  final int id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        elevation: 2,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              popUpAlert(
                context: context,
                title: 'Delete photo',
                optionOne: () {
                  DatabaseHelper.instance.deleteImage(id);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(true);
                },
                optionTwo: () => Navigator.of(context).pop(),
              );
            },
            icon: Icon(Icons.delete, color: Colors.grey.shade400),
          ),
        ],
      ),
      body: Center(child: Image(image: FileImage(File(imagepath)))),
    );
  }
}
