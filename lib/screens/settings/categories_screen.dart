import 'package:expenses_app/models/categories.dart';
import 'package:expenses_app/screens/settings/widgets/bottom_sheet_widget.dart';
import 'package:flutter/material.dart';

import 'package:expenses_app/models/transactions.dart';
import 'categories_bloc.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

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
                  onPressed: () {
                    bloc.myCategories = bloc.categoriesBox.values.toList();

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
                    Navigator.pop(context);
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
                                              showBottomSheetMethod(
                                                ctx: context,
                                                cat: bloc.myCategories[index],
                                                onClicked: (value) {
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

                                                  bloc.fillFilterdList();
                                                },
                                              );
                                            },
                                            icon: const Icon(Icons.edit)),
                                        IconButton(
                                            iconSize: 15,
                                            onPressed: () async {
                                              await deleteAlert(
                                                  index, context, bloc);
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
