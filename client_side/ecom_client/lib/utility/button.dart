import 'package:flutter/material.dart';

final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.blueAccent, // Primary color
  foregroundColor: Colors.white, // Text color
  padding: const EdgeInsets.symmetric(vertical: 16),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  textStyle: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
  ),
);
