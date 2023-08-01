import 'package:hive_flutter/hive_flutter.dart';

part 'transactions.g.dart';

@HiveType(typeId: 1)
enum TransactionType {
  @HiveField(0)
  income,
  @HiveField(1)
  outcome
}

@HiveType(typeId: 2)
class Transactions {
  @HiveField(0)
  double price;

  @HiveField(1)
  TransactionType type;

  @HiveField(2)
  String desc;

  @HiveField(3)
  String category;

  Transactions({
    required this.desc,
    required this.price,
    required this.type,
    required this.category,
  });
}
