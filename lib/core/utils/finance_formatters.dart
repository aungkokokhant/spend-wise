import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled/l10n/app_localizations.dart';

import '../constants/finance_categories.dart';

class FinanceFormatters {
  static String currency(BuildContext context, double amount) {
    final locale = Localizations.localeOf(context).languageCode;
    final symbol = locale == 'my' ? 'Ks' : '\$';
    return NumberFormat.currency(
      locale: locale,
      symbol: '$symbol ',
      decimalDigits: 2,
    ).format(amount);
  }

  static String categoryLabel(AppLocalizations l10n, String category) {
    return switch (category) {
      FinanceCategories.salary => l10n.categorySalary,
      FinanceCategories.food => l10n.categoryFood,
      FinanceCategories.transport => l10n.categoryTransport,
      FinanceCategories.shopping => l10n.categoryShopping,
      FinanceCategories.bills => l10n.categoryBills,
      FinanceCategories.health => l10n.categoryHealth,
      FinanceCategories.entertainment => l10n.categoryEntertainment,
      FinanceCategories.travel => l10n.categoryTravel,
      FinanceCategories.investment => l10n.categoryInvestment,
      FinanceCategories.education => l10n.categoryEducation,
      FinanceCategories.gifts => l10n.categoryGifts,
      _ => l10n.categoryOther,
    };
  }
}
