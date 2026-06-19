import 'package:flutter/material.dart';

class CategoryData {
  static const List<String> categories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Entertainment',
    'Health',
    'Other',
  ];

  static IconData getIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.restaurant;
      case 'Transport':
        return Icons.directions_car;
      case 'Shopping':
        return Icons.shopping_bag;
      case 'Bills':
        return Icons.receipt_long;
      case 'Entertainment':
        return Icons.movie;
      case 'Health':
        return Icons.local_hospital;
      default:
        return Icons.category;
    }
  }

  static Color getColor(String category) {
    switch (category) {
      case 'Food':
        return Colors.orange;
      case 'Transport':
        return Colors.blue;
      case 'Shopping':
        return Colors.purple;
      case 'Bills':
        return Colors.red;
      case 'Entertainment':
        return Colors.pink;
      case 'Health':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}