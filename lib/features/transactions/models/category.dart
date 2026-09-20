import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';

enum CategoryType { income, expense }

@freezed
abstract class Category with _$Category {
  const factory Category({
    required int id,
    required String name,
    required IconData icon,
    required CategoryType type,
  }) = _Category;
}
