import 'package:expenses_app/models/categories.dart';
import 'package:expenses_app/screens/expenses/expenses_bloc.dart';
import 'package:expenses_app/screens/settings/widgets/bottom_sheet_widget.dart';
import 'package:flutter/material.dart';

import 'package:expenses_app/models/transactions.dart';
import 'package:hive/hive.dart';
import 'categories_bloc.dart';

class CategoriesScreen extends StatefulWidget {
  final ExpensesBloc expensesBloc;
  const CategoriesScreen({super.key, required this.expensesBloc});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  CategoriesBloc bloc = CategoriesBloc();

  @override
  void initState() {
    bloc.myCategories = bloc.categoriesBox.values.toList();
    bloc.fillFilterdList();

    super.initState();
  }

  Map<String, double> getCategoryOccurrences(List<Transactions> transactions) {
    final List<Categories> myCategories = bloc.categoriesBox.values.toList();
    Map<String, double> dataMap = {};

    for (Categories categories in myCategories) {
      String category = categories.category;
      dataMap[category] = (dataMap[category] ?? 0) + 1;
    }

    return dataMap;
  }

  deleteAlert(int index, BuildContext context, CategoriesBloc bloc) {
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
                  onPressed: () async {
                    String deletedCategory = bloc.filteredList[index].category;
                    bloc.myCategories = bloc.categoriesBox.values.toList();
                    final transactionsBox =
                        await Hive.openBox<Transactions>('wallet_data');

                    for (int i = 0; i < bloc.myCategories.length; i++) {
                      if (bloc.myCategories[i].uniqueId ==
                          bloc.filteredList[index].uniqueId) {
                        bloc.myCategories[i].delete();
                        bloc.categoriesBox
                            .delete(bloc.myCategories[i].uniqueId);
                      }
                    }
                    bloc.myCategories = bloc.categoriesBox.values.toList();
                    bloc.fillFilterdList();

                    final transactionsToDelete =
                        transactionsBox.values.where((transaction) {
                      return transaction.category == deletedCategory;
                    });

                    for (final transaction in transactionsToDelete) {
                      transaction.category = "";
                      widget.expensesBloc.transactionsBox
                          .put(transaction.uniqueId, transaction);

                      transaction.save();
                    }

                    widget.expensesBloc.fillCategoryList();
                    widget.expensesBloc.fillFilterdList();
                    widget.expensesBloc.notifyUpdate();
                    if (context.mounted) Navigator.of(context).pop();
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

  showBottomSheetMethod({
    required BuildContext ctx,
    final Categories? cat,
    required Function(Categories) onClicked,
  }) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        isScrollControlled: true,
        elevation: 10,
        backgroundColor: Colors.white,
        context: ctx,
        builder: (ctx) {
          return BottomSheetWidget(
              category: cat,
              onClicked: (value) {
                onClicked(value);
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    bloc.myCategories = bloc.categoriesBox.values.toList();

    bloc.fillFilterdList();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 213, 235, 233),
      floatingActionButton: IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          showBottomSheetMethod(
              ctx: context,
              cat: null,
              onClicked: (value) {
                bloc.categoriesBox.put(value.uniqueId, value);
                bloc.myCategories = bloc.categoriesBox.values.toList();
                widget.expensesBloc.fillCategoryList();
                bloc.fillFilterdList();
              });
        },
      ),
      appBar: AppBar(
        title: const Text('Wallet'),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<List<Categories>>(
          stream: bloc.categoriessStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text("Loading..."));
            } else {
              bloc.filteredList = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
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
                                        color: const Color.fromARGB(
                                            50, 0, 150, 135)),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                textAlign: TextAlign.center,
                                                bloc.filteredList[index]
                                                    .category,
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Icon(
                                                bloc.filteredList[index]
                                                    .categoryIcon,
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                            iconSize: 15,
                                            onPressed: () {
                                              final String editedCategory = bloc
                                                  .myCategories[index].category;
                                              showBottomSheetMethod(
                                                ctx: context,
                                                cat: bloc.myCategories[index],
                                                onClicked: (value) async {
                                                  final transactionsBox =
                                                      await Hive.openBox<
                                                              Transactions>(
                                                          'wallet_data');

                                                  for (int i = 0;
                                                      i <
                                                          bloc.myCategories
                                                              .length;
                                                      i++) {
                                                    if (bloc.myCategories[i]
                                                            .uniqueId ==
                                                        bloc.filteredList[index]
                                                            .uniqueId) {
                                                      bloc.myCategories[i]
                                                          .delete();
                                                      bloc.categoriesBox.put(
                                                          bloc.myCategories[i]
                                                              .uniqueId,
                                                          value);

                                                      value.save();
                                                    }
                                                  }

                                                  final transactionsToDelete =
                                                      transactionsBox.values
                                                          .where((transaction) {
                                                    return transaction
                                                            .category ==
                                                        editedCategory;
                                                  });

                                                  for (final transaction
                                                      in transactionsToDelete) {
                                                    transaction.category =
                                                        value.category;
                                                    widget.expensesBloc
                                                        .transactionsBox
                                                        .put(
                                                            transaction
                                                                .uniqueId,
                                                            transaction);

                                                    transaction.save();
                                                  }

                                                  widget.expensesBloc
                                                      .fillCategoryList();
                                                  bloc.fillFilterdList();
                                                  widget.expensesBloc
                                                      .fillFilterdList();
                                                  widget.expensesBloc
                                                      .notifyUpdate();
                                                },
                                              );
                                            },
                                            icon: const Icon(Icons.edit)),
                                        IconButton(
                                            iconSize: 15,
                                            onPressed: () async {
                                              (bloc.myCategories.length == 1
                                                  ? ScaffoldMessenger.of(
                                                          context)
                                                      .showSnackBar(
                                                          const SnackBar(
                                                      content: Text(
                                                          "at least one item should exist in the list"),
                                                    ))
                                                  : await deleteAlert(
                                                      index, context, bloc));
                                            },
                                            icon: const Icon(Icons.delete))
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                ],
              );
            }
          }),
    );
  }
}
