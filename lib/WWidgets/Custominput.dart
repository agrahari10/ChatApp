import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final Function(String) onSaved;
  final String regEx;
  final String hintText;
  final bool obscureText;

  CustomTextField(
      {required this.hintText,
      required this.obscureText,
      required this.onSaved,
      required this.regEx});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: (_value) => onSaved(_value!),
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white),
      obscureText: obscureText,
      validator: (_value) {
        return RegExp(regEx).hasMatch(_value!) ? null : 'Enter a valid Input';
      },
      decoration: InputDecoration(
          fillColor: Color.fromRGBO(3, 2, 7, 0.1),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white)),
    );
  }
}

class CustomTextField2 extends StatelessWidget {
  final Function(String) onEditingComplete;
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  IconData? icon;

  CustomTextField2(
      {required this.controller,
      required this.hintText,
      this.icon,
      required this.obscureText,
      required this.onEditingComplete,});

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        onEditingComplete: () => onEditingComplete(controller.value.text),
        cursorColor:  Colors.white,
        style: TextStyle(color: Colors.white),
        obscureText: obscureText,
        decoration: InputDecoration(
          fillColor: Color.fromRGBO(30, 29, 37, 1.0),
          filled: true,
          border: OutlineInputBorder(
            borderRadius:BorderRadius.circular(10.0),
            borderSide: BorderSide.none
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon,color: Colors.white54)
    ),
    );
  }
}
