import 'package:flutter/material.dart';

// Custom widget for detail chips
// ignore: unused_element
class DetailChip extends StatelessWidget {
  

  DetailChip({super.key, required this.label, required this.value, required this.icon, required this.fontSize});

  final String label;
  final String value;
  final Icon icon;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Wraps content tightly
      children: [
        icon, // Display the icon
        const SizedBox(width: 4.0), // Add a small space between icon and text
        Text(
          '${label.isNotEmpty ? '$label: ' : ''}$value LKR',
          style: TextStyle(
            color: Colors.black, // Customize text color
            fontSize: fontSize, 
            fontWeight: FontWeight.bold// Customize font size
          ),
        ),

      ],
    );
  }
}
