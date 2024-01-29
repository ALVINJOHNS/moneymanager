import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:moneymanager/models/transaction/transaction_model.dart';

const transactionDBName = 'transaction-DB';

abstract class TransactionDBFunctions {
  Future<void> addTransaction(TransactionModel model);
  Future<List<TransactionModel>> getAllTransactions();
  Future<void> refreshUITransactions();
  Future<void> deleteTransaction(String id);
}

class TransactionDB implements TransactionDBFunctions {
  TransactionDB._internal();

  static TransactionDB instance = TransactionDB._internal();

  factory TransactionDB() {
    return instance;
  }

  ValueNotifier<List<TransactionModel>> transactionList = ValueNotifier([]);

  @override
  Future<void> addTransaction(TransactionModel model) async {
    final _transactionDB =
        await Hive.openBox<TransactionModel>(transactionDBName);
    await _transactionDB.put(model.id, model);
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    final _transactionDB =
        await Hive.openBox<TransactionModel>(transactionDBName);
    return _transactionDB.values.toList();
  }

  @override
  Future<void> refreshUITransactions() async {
    transactionList.value.clear();
    final _allTransactions = await getAllTransactions();
    _allTransactions.sort(
      (a, b) {
        return b.transactionDate.compareTo(a.transactionDate);
      },
    );
    transactionList.value.addAll(_allTransactions);
    transactionList.notifyListeners();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final _transactionDB =
        await Hive.openBox<TransactionModel>(transactionDBName);
    _transactionDB.delete(id);
    refreshUITransactions();
  }
}
