// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:expenses_app/models/transactions.dart';
import '../../../locater.dart';
import '../../../models/categories.dart';
import '../../../services/hive_service.dart';

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
  final formKey = GlobalKey<FormState>();
  TransactionType type = TransactionType.income;
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  final db = FirebaseFirestore.instance;
  final CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');

  bool isIncome = true;
  String? selectedCategory;

  List<Categories> categoryList = [];

  @override
  void initState() {
    categoryList = locator<HiveService>()
        .categoriesBox
        .values
        .map((dynamic item) => item as Categories)
        .toList();

    if (widget.trans != null) {
      priceController.text = widget.trans!.price.toString();
      descController.text = widget.trans!.desc;
      type = widget.trans!.type;
      isIncome = type == TransactionType.income ? true : false;
      selectedCategory = widget.trans!.category;
    } else {
      // selectedCategory = categoryList.first.category;
      selectedCategory = '';
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                            Transactions newTransaction = Transactions(
                              desc: descController.text,
                              price: double.parse(priceController.text),
                              type: type,
                              category: selectedCategory!,
                            );
                            if (widget.trans != null) {
                              newTransaction.uniqueId = widget.trans!.uniqueId;
                            }
                            widget.onClicked(newTransaction);
                          }

                          Navigator.pop(context);
                          setState(() {});
                        }),
                  ],
                ),
                const Divider(),
                FutureBuilder<QuerySnapshot>(
                  future:
                      FirebaseFirestore.instance.collection('categories').get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }

                    // Data snapshot from Firestore
                    QuerySnapshot querySnapshot = snapshot.data!;

                    // Extract category data for dropdown
                    List<String> categories = querySnapshot.docs
                        .map((doc) => doc['category'] as String)
                        .toList();

                    List<int> icons = querySnapshot.docs
                        .map((doc) => doc['categoryIconCode'] as int)
                        .toList();
                    return DropdownButtonFormField<String>(
                      value: selectedCategory!.isEmpty
                          ? null
                          : selectedCategory, // Initial value (you can set a default)
                      onChanged: (newValue) {
                        setState(() {
                          selectedCategory = newValue;
                        });
                      },
                      hint: const Text("Select Category"),
                      validator: (value) =>
                          value == null ? 'field required' : null,

                      items: List<DropdownMenuItem<String>>.generate(
                        categories.length,
                        (index) {
                          return DropdownMenuItem<String>(
                            value: categories[index],
                            child: Row(
                              children: [
                                Icon(
                                  IconData(icons[index],
                                      fontFamily: 'MaterialIcons'),
                                  color: Colors.teal,
                                ),
                                const SizedBox(width: 10),
                                Text(categories[index]),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                // DropdownButtonFormField(
                //   value: categoryList.any(
                //           (element) => element.category == selectedCategory)
                //       ? categoryList.firstWhere(
                //           (element) => element.category == selectedCategory)
                //       : categoryList.isNotEmpty
                //           ? categoryList.first
                //           : null,
                //   hint: const Text("Select Value"),
                //   items: categoryList.map((Categories? category) {
                //     return DropdownMenuItem<Categories>(
                //       value: category,
                //       child: Row(
                //         children: [
                //           const SizedBox(width: 8),
                //           Text(category!.category),
                //         ],
                //       ),
                //     );
                //   }).toList(),
                //   validator: (value) => value == null ? 'field required' : null,
                //   onChanged: (newValue) {
                //     setState(() {
                //       selectedCategory = newValue!.category;
                //     });
                //   },
                // ),
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
