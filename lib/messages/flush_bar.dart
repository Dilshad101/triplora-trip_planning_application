import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

customToast({required Color bgcolor, required String msg}) {
  return Fluttertoast.showToast(
    msg: msg,
    fontSize: 16,
    gravity: ToastGravity.TOP,
    textColor: Colors.white,
    backgroundColor: bgcolor,
  );
}
