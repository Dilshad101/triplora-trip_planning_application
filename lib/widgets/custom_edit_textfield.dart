// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomEditField extends StatefulWidget {
  CustomEditField(
      {super.key,
      required this.isEdit,
      required this.onTap,
      required this.controller,
      required this.icon});

  TextEditingController controller;
  bool isEdit;
  IconData icon;
  Function() onTap;

  @override
  State<CustomEditField> createState() => _CustomEditFieldState();
}

class _CustomEditFieldState extends State<CustomEditField> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 54,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
              width: 1,
              color: widget.isEdit == true ? Colors.transparent : Colors.grey)),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              textInputAction: TextInputAction.done,
              readOnly: widget.isEdit,
              onTap:widget.onTap,
              onEditingComplete: () {
                setState(() {
                  widget.isEdit = true;
                });
              },
              decoration: InputDecoration(
                prefixIcon: Icon(widget.icon),
                constraints: const BoxConstraints(maxHeight: 54),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  widget.isEdit = !widget.isEdit;
                  widget.onTap;
                });
              },
              icon: const Icon(
                Icons.edit_outlined,
                color: Colors.grey,
                size: 23,
              )),
        ],
      ),
    );
  }
}
