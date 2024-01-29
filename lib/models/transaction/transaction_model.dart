import 'package:hive_flutter/adapters.dart';
import 'package:moneymanager/models/category/category_model.dart';
part 'transaction_model.g.dart';

@HiveType(typeId: 3)
class TransactionModel {
  @HiveField(0)
  String? id;

  @HiveField(1)
  final String transactionName;

  @HiveField(2)
  final double transactionAmount;

  @HiveField(3)
  final DateTime transactionDate;

  @HiveField(4)
  final CategoryType transactionType;

  @HiveField(5)
  final CategoryModel transactionCategory;

  TransactionModel({
    required this.transactionName,
    required this.transactionAmount,
    required this.transactionDate,
    required this.transactionType,
    required this.transactionCategory,
  }) {
    id = DateTime.now().microsecondsSinceEpoch.toString();
  }
}
