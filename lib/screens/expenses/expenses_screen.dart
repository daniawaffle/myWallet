import 'package:expenses_app/models/categories.dart';
import 'package:flutter/material.dart';
import 'package:expenses_app/mixins/widget_mixins.dart';
import 'package:expenses_app/screens/expenses/expenses_bloc.dart';
import 'package:expenses_app/models/transactions.dart';
import 'package:expenses_app/screens/expenses/widgets/wallet.dart';
import '../settings/settings_screen.dart';

class ExpensesScreen extends StatefulWidget with WidgetsMixin {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> with WidgetsMixin {
  ExpensesBloc bloc = ExpensesBloc();

  @override
  void initState() {
    bloc.fillCategoryList();
    bloc.myExpenses = bloc.transactionsBox.values.toList();
    bloc.fillFilterdList();
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

// Future<void> _navigateAndDisplaySelection(BuildContext context) async {
//     // Navigator.push returns a Future that completes after calling
//     // Navigator.pop on the Selection Screen.
//     final result = await Navigator.push(
//       context,
//       // Create the SelectionScreen in the next step.
//       MaterialPageRoute(builder: (context) =>   SettingsScreen(
//                           themeModeOptionList: bloc.themeModeOptionList,
//                         )),
//     );
//   }
  @override
  Widget build(BuildContext context) {
    bloc.myExpenses = bloc.transactionsBox.values.toList();
    // bloc.fillFilterdList();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromARGB(255, 213, 235, 233),
        floatingActionButton: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            showBottomSheetMethod(
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
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SettingsScreen(
                          themeModeOptionList: bloc.themeModeOptionList,
                          expensesBloc: bloc,
                        )));
              },
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Wallet(
              income: bloc.calculateIncomeOutcome(TransactionType.income),
              outcome: bloc.calculateIncomeOutcome(TransactionType.outcome),
              pieMap: getCategoryOccurrences(bloc.myExpenses),
            ),
            StreamBuilder<List<Categories>>(
                stream: bloc.categoriesStream,
                builder: (context, snapshot) {
                  return SizedBox(
                      height: 50,
                      child: ListView.builder(
                          itemCount:
                              snapshot.data?.length ?? bloc.categoryList.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            if (snapshot.data != null) {
                              return ElevatedButton.icon(
                                  icon: Icon(
                                    Icons.abc,
                                    // bloc.categoryList[index].categoryIcon,
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
                                        : MaterialStateProperty.all(
                                            Colors.white)),
                                  ),
                                  onPressed: () {
                                    bloc.selectedCategory =
                                        bloc.categoryList[index].category;
                                    bloc.fillFilterdList();
                                    setState(() {});
                                  });
                            } else {
                              return Container();
                            }
                          }));
                }),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                        showBottomSheetMethod(
                                          ctx: context,
                                          trans: bloc.myExpenses[index],
                                          onClicked: (value) {
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

                                                value.save();
                                              }
                                            }

                                            bloc.fillFilterdList();
                                            setState(() {});
                                          },
                                        );
                                        setState(() {});
                                      },
                                      icon: const Icon(Icons.edit)),
                                  IconButton(
                                      iconSize: 15,
                                      onPressed: () async {
                                        await deleteAlert(index, context, bloc);
                                        setState(() {});
                                      },
                                      icon: const Icon(Icons.delete))
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
          ],
        ));
  }
}
