import 'package:flutter/material.dart';

const List<Color> chartColors = [
  Color(0xFF2E7D32),
  Color(0xFFEF6C00),
  Color(0xFF1565C0),
  Color(0xFFC62828),
  Color(0xFF6A1B9A),
  Color(0xFF00838F),
  Color(0xFF9E9D24),
  Color(0xFFAD1457),
  Color(0xFF4E342E),
  Color(0xFF546E7A),
];

Color chartColorAt(int index) => chartColors[index % chartColors.length];
