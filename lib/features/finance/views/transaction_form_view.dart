import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled/l10n/app_localizations.dart';

import '../../../core/constants/finance_categories.dart';
import '../../../core/utils/app_date_utils.dart';
import '../../../core/utils/finance_formatters.dart';
import '../models/finance_transaction.dart';
import '../models/transaction_type.dart';
import '../providers/transaction_providers.dart';

class TransactionFormView extends ConsumerStatefulWidget {
  const TransactionFormView({super.key, this.transactionId});

  final String? transactionId;

  @override
  ConsumerState<TransactionFormView> createState() =>
      _TransactionFormViewState();
}

class _TransactionFormViewState extends ConsumerState<TransactionFormView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;

  late TransactionType _type;
  late String _category;
  late DateTime _selectedDate;
  bool _initialized = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _amountController = TextEditingController();
    _noteController = TextEditingController();
    _type = TransactionType.expense;
    _category = FinanceCategories.food;
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _hydrateForm(FinanceTransaction? transaction) {
    if (_initialized) {
      return;
    }

    if (transaction == null) {
      if (widget.transactionId == null) {
        _initialized = true;
      }
      return;
    }

    _initialized = true;
    _titleController.text = transaction.title;
    _amountController.text = transaction.amount.toStringAsFixed(2);
    _noteController.text = transaction.note ?? '';
    _type = transaction.type;
    _category = transaction.category;
    _selectedDate = transaction.date;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final existingTransaction = widget.transactionId == null
        ? null
        : ref.watch(transactionByIdProvider(widget.transactionId!));
    _hydrateForm(existingTransaction);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.transactionId == null
              ? l10n.addTransaction
              : l10n.editTransaction,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'transaction-fab',
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(
                        widget.transactionId == null
                            ? Icons.add_card_rounded
                            : Icons.edit_note_rounded,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        size: 34,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.transactionId == null
                      ? l10n.addTransactionSubhead
                      : l10n.editTransactionSubhead,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),
                SegmentedButton<TransactionType>(
                  segments: [
                    ButtonSegment(
                      value: TransactionType.expense,
                      label: Text(l10n.expense),
                      icon: const Icon(Icons.arrow_upward_rounded),
                    ),
                    ButtonSegment(
                      value: TransactionType.income,
                      label: Text(l10n.income),
                      icon: const Icon(Icons.arrow_downward_rounded),
                    ),
                  ],
                  selected: {_type},
                  onSelectionChanged: (selection) {
                    setState(() {
                      _type = selection.first;
                      if (_type == TransactionType.income &&
                          _category == FinanceCategories.food) {
                        _category = FinanceCategories.salary;
                      }
                    });
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: l10n.title,
                    hintText: l10n.titleHint,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.fieldRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.amount,
                    hintText: '0.00',
                  ),
                  validator: (value) {
                    final amount = double.tryParse(value ?? '');
                    if (amount == null || amount <= 0) {
                      return l10n.amountValidation;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _category,
                  items: FinanceCategories.values
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(
                            FinanceFormatters.categoryLabel(l10n, category),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _category = value;
                    });
                  },
                  decoration: InputDecoration(labelText: l10n.category),
                ),
                const SizedBox(height: 16),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(labelText: l10n.date),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 18),
                        const SizedBox(width: 12),
                        Text(
                          AppDateUtils.sectionDate(
                            _selectedDate,
                            Localizations.localeOf(context).languageCode,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _noteController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: l10n.note,
                    hintText: l10n.noteHint,
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _isSaving
                        ? null
                        : () async {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }

                            setState(() {
                              _isSaving = true;
                            });

                            final transaction = FinanceTransaction(
                              id:
                                  existingTransaction?.id ??
                                  DateTime.now().microsecondsSinceEpoch
                                      .toString(),
                              title: _titleController.text.trim(),
                              amount: double.parse(_amountController.text),
                              type: _type,
                              category: _category,
                              date: _selectedDate,
                              note: _noteController.text.trim().isEmpty
                                  ? null
                                  : _noteController.text.trim(),
                            );

                            if (existingTransaction == null) {
                              await ref
                                  .read(transactionListProvider.notifier)
                                  .addTransaction(transaction);
                            } else {
                              await ref
                                  .read(transactionListProvider.notifier)
                                  .updateTransaction(transaction);
                            }

                            if (!context.mounted) {
                              return;
                            }

                            final navigator = Navigator.of(context);
                            setState(() {
                              _isSaving = false;
                            });
                            navigator.pop();
                          },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        _isSaving ? l10n.saving : l10n.saveTransaction,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
