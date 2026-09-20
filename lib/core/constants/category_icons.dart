import 'package:flutter/material.dart';

/// Ícones referenciados aqui como `Icons.xxx` (não via `IconData(codePoint)`
/// dinâmico) para que o tree-shaking de fontes do build de release não
/// remova os glifos usados pelas categorias vindas do banco.
const Map<String, IconData> categoryIcons = {
  'restaurant': Icons.restaurant,
  'directions_car': Icons.directions_car,
  'home': Icons.home,
  'sports_esports': Icons.sports_esports,
  'shopping_bag': Icons.shopping_bag,
  'local_hospital': Icons.local_hospital,
  'school': Icons.school,
  'subscriptions': Icons.subscriptions,
  'category': Icons.category,
  'payments': Icons.payments,
  'laptop_mac': Icons.laptop_mac,
  'trending_up': Icons.trending_up,
};

IconData iconForKey(String key) => categoryIcons[key] ?? Icons.category;
