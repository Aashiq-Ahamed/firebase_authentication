import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {

  final controller;
  final String hinttext;
  final bool isPassword;

  const MyTextfield({
    super.key,
    required this.controller,
    required this.hinttext,
    required this.isPassword
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: controller,
                obscureText: isPassword,
                decoration : InputDecoration(
                  hintText: hinttext,
                  hintStyle: TextStyle(color : Colors.grey[500]),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder:OutlineInputBorder(
                    borderSide: BorderSide(color:Colors.grey.shade400),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled:true
                )
              )
            );
  }
}