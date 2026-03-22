import 'package:flutter/material.dart';

import '../providers/transaction_providers.dart';

class FilterChipSelector extends StatelessWidget {
  const FilterChipSelector({
    super.key,
    required this.value,
    required this.onSelected,
    required this.labels,
  });

  final TransactionFilterPeriod value;
  final ValueChanged<TransactionFilterPeriod> onSelected;
  final Map<TransactionFilterPeriod, String> labels;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final entry in labels.entries)
          ChoiceChip(
            label: Text(entry.value),
            selected: value == entry.key,
            onSelected: (_) => onSelected(entry.key),
          ),
      ],
    );
  }
}
