// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:wanderlust_new/database/database_helper.dart';
import '../../models/trip_model.dart';

class NoteEditingPad extends StatelessWidget {
  const NoteEditingPad(
      {super.key, required this.controller, required this.trip});
  final TextEditingController controller;
  final Trips trip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,

      //appbar
      appBar: appBar(context),

      //Body
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                ' Note',
                style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              ),
              const SizedBox(height: 10),
              TextFormField(
                maxLines: 10,
                maxLength: 500,
                controller: controller,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.onSecondaryContainer,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          DatabaseHelper.instance.addNote(trip, controller.text);
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.done),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Add Your Notes',
        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      actions: [
        Icon(
          Icons.edit,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        const SizedBox(width: 15)
      ],
      shadowColor: Colors.grey.shade100,
    );
  }
}
