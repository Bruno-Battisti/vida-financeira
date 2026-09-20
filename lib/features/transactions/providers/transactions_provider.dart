import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/mock/mock_data.dart';
import '../models/transaction.dart';

part 'transactions_provider.g.dart';

@riverpod
class TransactionsNotifier extends _$TransactionsNotifier {
  @override
  List<Transaction> build() {
    final seed = [...MockData.transactions];
    seed.sort((a, b) => b.date.compareTo(a.date));
    return seed;
  }

  void add(Transaction transaction) {
    state = [...state, transaction]..sort((a, b) => b.date.compareTo(a.date));
  }

  void update(Transaction transaction) {
    state = [
      for (final t in state)
        if (t.id == transaction.id) transaction else t,
    ]..sort((a, b) => b.date.compareTo(a.date));
  }

  void remove(int id) {
    state = state.where((t) => t.id != id).toList();
  }
}

@riverpod
Transaction transactionById(Ref ref, int id) {
  final transactions = ref.watch(transactionsProvider);
  return transactions.firstWhere((t) => t.id == id);
}
