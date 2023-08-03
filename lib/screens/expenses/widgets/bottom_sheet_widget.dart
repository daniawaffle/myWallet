// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:expenses_app/models/transactions.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../locator.dart';
import '../../../models/settings.dart';

class BottomSheetWidget extends StatefulWidget {
  final Transactions? trans;
  final Function(Transactions) onClicked;

  const BottomSheetWidget({
    Key? key,
    this.trans,
    required this.onClicked,
  }) : super(key: key);

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  fillCategoryList() {
    final Settings settings = settingsBox.get('settingsKey') ??
        Settings(categories: ['All'], language: 'English', theme: 'Blue');
    List categoryList = settings.categories;
    return categoryList;
  }

  final formKey = GlobalKey<FormState>();
  TransactionType type = TransactionType.income;
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  var settingsBox = locator<Box<Settings>>();

  bool isIncome = true;
  String selectedCategory = 'Food';

  @override
  void initState() {
    if (widget.trans != null) {
      priceController.text = widget.trans!.price.toString();
      descController.text = widget.trans!.desc;
      type = widget.trans!.type;
      isIncome = type == TransactionType.income ? true : false;
      selectedCategory = widget.trans!.category;
      fillCategoryList();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> categoryList = fillCategoryList();
    List<String> filteredCategoryList = List.from(categoryList);
    filteredCategoryList.remove('All');

    return Padding(
      padding: EdgeInsets.only(
          right: 20,
          left: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.only(top: 50, bottom: 40),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.teal),
                        )),
                    Text(
                      widget.trans == null ? 'Add' : 'Edit',
                      style: const TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    TextButton(
                        child: const Text(
                          'Done',
                          style: TextStyle(color: Colors.teal),
                        ),
                        onPressed: () {
                          if (!formKey.currentState!.validate()) {
                            return;
                          } else {
                            final newTransaction = Transactions(
                              desc: descController.text,
                              price: double.parse(priceController.text),
                              type: type,
                              category: selectedCategory,
                            );
                            if (widget.trans != null) {
                              newTransaction.uniqueId = widget.trans!.uniqueId;
                            }
                            widget.onClicked(newTransaction);
                            print(
                                '${newTransaction.uniqueId}===== newtransaction');
                          }

                          Navigator.pop(context);
                          setState(() {});
                        }),
                  ],
                ),
                const Divider(),
                DropdownButton(
                  value: filteredCategoryList
                      .firstWhere((element) => element == selectedCategory),
                  items: filteredCategoryList.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                ),
                TextFormField(
                  controller: priceController,
                  validator: (value) {
                    if ((value?.isEmpty ?? true) ||
                        double.parse(value!) <= 0.0) {
                      return 'Please add price as number';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Price..',
                      prefixIcon: Icon(Icons.price_check),
                      border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  validator: (value) {
                    if (value!.isNotEmpty && value.length > 2) {
                      return null;
                    } else {
                      return 'Please add description';
                    }
                  },
                  decoration: const InputDecoration(
                      labelText: 'Descriprtion..',
                      prefixIcon: Icon(Icons.money),
                      border: OutlineInputBorder()),
                  controller: descController,
                ),
                RadioListTile(
                  activeColor: Colors.teal,
                  title: const Text('Income'),
                  value: true,
                  groupValue: isIncome,
                  onChanged: (context) {
                    setState(() {
                      isIncome = true;
                      type = TransactionType.income;
                    });
                  },
                ),
                RadioListTile(
                  activeColor: Colors.teal,
                  title: const Text('Outcome'),
                  value: false,
                  groupValue: isIncome,
                  onChanged: (context) {
                    setState(() {
                      isIncome = false;
                      type = TransactionType.outcome;
                    });
                  },
                ),
              ]),
            ),
          )
        ],
      ),
    );
  }
}
