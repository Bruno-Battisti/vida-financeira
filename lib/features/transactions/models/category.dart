import 'package:flutter/material.dart';

enum CategoryType { income, expense }

class Category {
  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.type,
  });

  final int id;
  final String name;
  final IconData icon;
  final CategoryType type;
}
