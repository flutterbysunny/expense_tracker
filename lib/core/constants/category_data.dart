import 'package:flutter/material.dart';
import 'app_colors.dart';

class CategoryData {
  static const List<String> expenseCategories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Entertainment',
    'Health',
    'Other',
  ];

  static const List<String> incomeCategories = [
    'Salary',
    'Freelance',
    'Investment',
    'Gift',
    'Other',
  ];

  // Backward-compatible alias used by older widgets
  static const List<String> categories = expenseCategories;

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
      case 'Salary':
        return Icons.account_balance_wallet;
      case 'Freelance':
        return Icons.laptop_mac;
      case 'Investment':
        return Icons.trending_up;
      case 'Gift':
        return Icons.card_giftcard;
      default:
        return Icons.category;
    }
  }

  static Color getColor(String category) {
    switch (category) {
      case 'Food':
        return AppColors.catFood;
      case 'Transport':
        return AppColors.catTransport;
      case 'Shopping':
        return AppColors.catShopping;
      case 'Bills':
        return AppColors.catBills;
      case 'Entertainment':
        return AppColors.catEntertainment;
      case 'Health':
        return AppColors.catHealth;
      case 'Salary':
      case 'Freelance':
      case 'Investment':
      case 'Gift':
        return AppColors.income;
      default:
        return AppColors.catOther;
    }
  }
}