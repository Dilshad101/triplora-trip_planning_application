// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

//custom textfield

class CustomTextField extends StatefulWidget {
  CustomTextField(
      {super.key,
      required this.controller,
      required this.validator,
      this.inputType,
      this.prefix = false,
      this.icon,
      this.onTap,
      this.isreadOnly = false,
      required this.label});

  TextEditingController controller;

  final FormFieldValidator<String> validator;

  final String label;

  TextInputType? inputType;

  Function()? onTap;

  bool prefix;

  bool isreadOnly;

  final IconData? icon;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onEditingComplete: () {
        FocusScope.of(context).unfocus();
      },
      controller: widget.controller,
      keyboardType: widget.inputType ?? TextInputType.name,
      validator: widget.validator,
      onTap: widget.onTap,
      readOnly: widget.isreadOnly,
      textInputAction: TextInputAction.done,
      style: TextStyle(
          color: widget.isreadOnly == true ? Colors.grey : Theme.of(context).colorScheme.onBackground),
      decoration: InputDecoration(
          prefixIcon: widget.prefix == true ? Icon(widget.icon) : null,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4))),
          labelText: widget.label,
          focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(
                  color: Theme.of(context).primaryColor, width: 1)),
          disabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(color: Colors.grey))),
    );
  }
}

// custom password class
class CustomPasswordField extends StatefulWidget {
  CustomPasswordField(
      {super.key,
      required this.label,
      this.hintText,
      required this.passcontroller,
      required this.validator});
  String label;
  String? hintText;
  TextEditingController passcontroller;
  final FormFieldValidator<String> validator;

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool _isobscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: widget.passcontroller,
        keyboardType: TextInputType.visiblePassword,
        obscureText: _isobscure,
        textInputAction: TextInputAction.next,
        onEditingComplete: () {
          FocusScope.of(context).unfocus();
        },
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hintText ?? '',
          suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  _isobscure = !_isobscure;
                });
              },
              child: Icon(_isobscure == true
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined)),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4))),
        ),
        validator: widget.validator);
  }
}

class CustomTripInputField extends StatelessWidget {
  CustomTripInputField(
      {super.key,
      required this.text,
      this.icon,
      this.controller,
      this.keyboardType});

  String text;

  IconData? icon;
  TextEditingController? controller;
  TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType ?? keyboardType,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          labelText: text,
          prefixIcon:
              icon != null ? const Icon(Icons.calendar_today_outlined) : null),
    );
  }
}
