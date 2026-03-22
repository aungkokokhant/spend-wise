import 'package:flutter/material.dart';

class FinanceCategories {
  static const salary = 'salary';
  static const food = 'food';
  static const transport = 'transport';
  static const shopping = 'shopping';
  static const bills = 'bills';
  static const health = 'health';
  static const entertainment = 'entertainment';
  static const travel = 'travel';
  static const investment = 'investment';
  static const education = 'education';
  static const gifts = 'gifts';
  static const other = 'other';

  static const values = <String>[
    salary,
    food,
    transport,
    shopping,
    bills,
    health,
    entertainment,
    travel,
    investment,
    education,
    gifts,
    other,
  ];

  static const icons = <String, IconData>{
    salary: Icons.payments_rounded,
    food: Icons.restaurant_rounded,
    transport: Icons.directions_bus_rounded,
    shopping: Icons.shopping_bag_rounded,
    bills: Icons.receipt_long_rounded,
    health: Icons.favorite_rounded,
    entertainment: Icons.movie_creation_rounded,
    travel: Icons.luggage_rounded,
    investment: Icons.trending_up_rounded,
    education: Icons.menu_book_rounded,
    gifts: Icons.card_giftcard_rounded,
    other: Icons.widgets_rounded,
  };
}
