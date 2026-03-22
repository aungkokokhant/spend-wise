import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled/l10n/app_localizations.dart';

import '../../../core/utils/app_date_utils.dart';
import '../models/finance_transaction.dart';
import '../providers/transaction_providers.dart';
import '../widgets/async_value_view.dart';
import '../widgets/empty_state_card.dart';
import '../widgets/filter_chip_selector.dart';
import '../widgets/transaction_tile.dart';

class TransactionsView extends ConsumerStatefulWidget {
  const TransactionsView({super.key});

  @override
  ConsumerState<TransactionsView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends ConsumerState<TransactionsView> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: ref.read(transactionSearchQueryProvider),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final transactionsValue = ref.watch(transactionListProvider);
    final filter = ref.watch(transactionFilterProvider);

    return SafeArea(
      child: AsyncValueView<List<FinanceTransaction>>(
        value: transactionsValue,
        data: (_) {
          final grouped = ref.watch(groupedTransactionsProvider);

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Text(
                      l10n.transactionsHeadline,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.transactionsSubhead,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _searchController,
                      onChanged: (value) =>
                          ref
                                  .read(transactionSearchQueryProvider.notifier)
                                  .state =
                              value,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search_rounded),
                        hintText: l10n.searchTransactions,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilterChipSelector(
                      value: filter,
                      onSelected: (value) {
                        ref.read(transactionFilterProvider.notifier).state =
                            value;
                      },
                      labels: {
                        TransactionFilterPeriod.all: l10n.all,
                        TransactionFilterPeriod.daily: l10n.daily,
                        TransactionFilterPeriod.weekly: l10n.weekly,
                        TransactionFilterPeriod.monthly: l10n.monthly,
                      },
                    ),
                    const SizedBox(height: 20),
                    if (grouped.isEmpty)
                      EmptyStateCard(
                        icon: Icons.search_off_rounded,
                        title: l10n.noTransactionsFound,
                        message: l10n.adjustSearchOrAdd,
                      )
                    else
                      ...grouped.entries.expand((entry) {
                        final dateLabel = AppDateUtils.sectionDate(
                          entry.key,
                          Localizations.localeOf(context).languageCode,
                        );
                        return [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12, top: 8),
                            child: Text(
                              dateLabel,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          ...entry.value.map(
                            (transaction) => TransactionTile(
                              transaction: transaction,
                              onDelete: () => ref
                                  .read(transactionListProvider.notifier)
                                  .deleteTransaction(transaction.id),
                            ),
                          ),
                        ];
                      }),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
