import 'package:expenses_app/screens/expenses/widgets/bottom_sheet_widget.dart';
import 'package:expenses_app/screens/expenses/expenses_bloc.dart';
import 'package:expenses_app/models/transactions.dart';
import 'package:expenses_app/screens/expenses/widgets/wallet.dart';

import 'package:flutter/material.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  ExpensesBloc bloc = ExpensesBloc();

  @override
  void initState() {
    bloc.myExpenses = bloc.transactionsBox.values.toList();

    bloc.fillFilterdList();

    setState(() {});

    super.initState();
  }

  Map<String, double> getCategoryOccurrences(List<Transactions> transactions) {
    final List<Transactions> myExpenses = bloc.transactionsBox.values.toList();
    Map<String, double> dataMap = {};

    for (Transactions transaction in myExpenses) {
      String category = transaction.category;
      dataMap[category] = (dataMap[category] ?? 0) + 1;
    }

    return dataMap;
  }

  Future _deleteAlert(int index) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete'),
            content: const SingleChildScrollView(
              child: Column(
                children: [
                  Text('Are you sure you want to delete this item?'),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    bloc.myExpenses = bloc.transactionsBox.values.toList();

                    for (int i = 0; i < bloc.myExpenses.length; i++) {
                      if (bloc.myExpenses[i].uniqueId ==
                          bloc.filteredList[index].uniqueId) {
                        bloc.transactionsBox
                            .delete(bloc.myExpenses[i].uniqueId);
                        bloc.myExpenses[i].delete();
                      }
                    }
                    bloc.myExpenses = bloc.transactionsBox.values.toList();
                    bloc.fillFilterdList();
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: const Text(
                    'Confirm',
                    style: TextStyle(color: Colors.teal),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.teal)))
            ],
          );
        });
  }

  _showBottomSheet({
    required BuildContext ctx,
    final Transactions? trans,
    required Function(Transactions) onClicked,
  }) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        isScrollControlled: true,
        elevation: 10,
        backgroundColor: Colors.white,
        context: context,
        builder: (ctx) {
          return BottomSheetWidget(
              trans: trans,
              onClicked: (value) {
                onClicked(value);
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    bloc.myExpenses = bloc.transactionsBox.values.toList();

    bloc.fillFilterdList();
    setState(() {});
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 213, 235, 233),
      floatingActionButton: IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          _showBottomSheet(
              ctx: context,
              trans: null,
              onClicked: (value) {
                bloc.transactionsBox.put(value.uniqueId, value);
                bloc.myExpenses = bloc.transactionsBox.values.toList();

                bloc.fillFilterdList();
                setState(() {});
              });
        },
      ),
      appBar: AppBar(
        title: const Text('Wallet'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Wallet(
            income: bloc.calculateIncomeOutcome(TransactionType.income),
            outcome: bloc.calculateIncomeOutcome(TransactionType.outcome),
            pieMap: getCategoryOccurrences(bloc.myExpenses),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
                itemCount: bloc.categoryList.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return ElevatedButton.icon(
                      icon: Icon(
                        bloc.categoryList[index].categoryIcon,
                        color: (bloc.selectedCategory ==
                                bloc.categoryList[index].category
                            ? Colors.white
                            : Colors.teal),
                      ),
                      label: Text(
                        bloc.categoryList[index].category,
                        style: TextStyle(
                          color: (bloc.selectedCategory ==
                                  bloc.categoryList[index].category
                              ? Colors.white
                              : Colors.teal),
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: (bloc.selectedCategory ==
                                bloc.categoryList[index].category
                            ? MaterialStateProperty.all(Colors.teal)
                            : MaterialStateProperty.all(Colors.white)),
                      ),
                      onPressed: () {
                        bloc.selectedCategory =
                            bloc.categoryList[index].category;
                        bloc.fillFilterdList();

                        setState(() {});
                      });
                }),
          ),
          bloc.filteredList.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(90.0),
                  child: Text('No items to show!'),
                )
              : Flexible(
                  child: ListView.builder(
                      itemCount: bloc.filteredList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color.fromARGB(50, 0, 150, 135)),
                            child: Row(
                              children: [
                                bloc.filteredList[index].type ==
                                        TransactionType.outcome
                                    ? const Icon(Icons.arrow_upward)
                                    : const Icon(Icons.arrow_downward),
                                bloc.filteredList[index].type ==
                                        TransactionType.income
                                    ? Text(
                                        'Income ${bloc.filteredList[index].price}')
                                    : Text(
                                        'Outcome ${bloc.filteredList[index].price}'),
                                const SizedBox(width: 25),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        textAlign: TextAlign.center,
                                        bloc.filteredList[index].category,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        textAlign: TextAlign.center,
                                        bloc.filteredList[index].desc,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                    iconSize: 15,
                                    onPressed: () {
<<<<<<< eliana
=======
                                      // final transactionsBox =
                                      //     Hive.box<Transactions>('wallet_data');

                                      // final List<Transactions> myExpenses =
                                      //     transactionsBox.values.toList();
                                      print(bloc.filteredList[index].uniqueId);

>>>>>>> main
                                      _showBottomSheet(
                                        ctx: context,
                                        trans: bloc.myExpenses[index],
                                        onClicked: (value) {
<<<<<<< eliana
                                          for (int i = 0;
                                              i < bloc.myExpenses.length;
                                              i++) {
                                            if (bloc.myExpenses[i].uniqueId ==
                                                bloc.filteredList[index]
                                                    .uniqueId) {
                                              bloc.myExpenses[i].delete();
                                              bloc.transactionsBox.put(
                                                  bloc.myExpenses[i].uniqueId,
                                                  value);
=======

>>>>>>> main

                                              value.save();
                                            }
                                          }


                                          bloc.fillFilterdList();
                                          setState(() {});
                                        },
                                      );
                                      print(bloc.filteredList[index].uniqueId);
                                    },
                                    icon: const Icon(Icons.edit)),
                                IconButton(
                                    iconSize: 15,
                                    onPressed: () {
                                      _deleteAlert(index);
                                    },
                                    icon: const Icon(Icons.delete))
                              ],
                            ),
                          ),
                        );
                      }),
                ),
        ],
      ),
    );
  }
}
