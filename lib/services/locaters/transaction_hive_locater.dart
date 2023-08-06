import 'package:hive_flutter/hive_flutter.dart';

import '../../models/transactions.dart';

class TransactionHiveLocater {
  static final TransactionHiveLocater _instance =
      TransactionHiveLocater._internal();

  factory TransactionHiveLocater() {
    return _instance;
  }

  TransactionHiveLocater._internal();

  Box<Transactions>? _transactionsBox;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TransactionsAdapter());
    _transactionsBox = await Hive.openBox<Transactions>('wallet_data');
  }

  Future<void> closeBox() async {
    if (_transactionsBox != null && _transactionsBox!.isOpen) {
      await _transactionsBox!.close();
    }
  }

  Future<void> addTransaction(Transactions transaction) async {
    _transactionsBox?.put(transaction.uniqueId, transaction);
    await transaction.save();
  }

  Future<void> updateTransaction(
      String uniqueId, Transactions updatedTransaction) async {
    _transactionsBox?.put(uniqueId, updatedTransaction);
    await updatedTransaction.save();
  }

  Future<void> deleteTransaction(String uniqueId) async {
    _transactionsBox?.delete(uniqueId);
  }
}
