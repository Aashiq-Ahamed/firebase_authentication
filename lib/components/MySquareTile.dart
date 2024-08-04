import 'package:flutter/material.dart';

class Mysquaretile extends StatelessWidget {

  final String imagePath;
  final double height;

  const Mysquaretile({
    super.key,
    required this.imagePath,
    required this.height
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      
      child: Image.asset(
        imagePath,
        height: height
      ),
    );
  }
}