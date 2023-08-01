enum TransactionType { income, outcome }

class Transactions {
  double price;
  TransactionType type;
  String desc;
  String category;

  Transactions(
      {required this.desc,
      required this.price,
      required this.type,
      required this.category});
}
