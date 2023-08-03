// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import '../../../models/categories.dart';

class BottomSheetWidget extends StatefulWidget {
  final Categories? category;
  final Function(Categories) onClicked;

  const BottomSheetWidget({
    Key? key,
    this.category,
    required this.onClicked,
  }) : super(key: key);

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();

  List<Categories> categoryList = [
    Categories(
      category: 'Food',
      categoryIcon: Icons.fastfood,
    ),
    Categories(
      category: 'Transportation',
      categoryIcon: Icons.emoji_transportation,
    ),
    Categories(
      category: 'Family',
      categoryIcon: Icons.people,
    ),
    Categories(
      category: 'Personal Care',
      categoryIcon: Icons.self_improvement,
    ),
    Categories(
      category: 'Bills',
      categoryIcon: Icons.local_atm,
    ),
    Categories(
      category: 'Medical',
      categoryIcon: Icons.medical_services,
    ),
    Categories(
      category: 'Loans',
      categoryIcon: Icons.real_estate_agent,
    ),
  ];

  @override
  void initState() {
    if (widget.category != null) {
      nameController.text = widget.category!.category;
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
                      widget.category == null ? 'Add' : 'Edit',
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
                            Categories newTransaction = Categories(
                              category: nameController.text,
                            );
                            if (widget.category != null) {
                              newTransaction.uniqueId =
                                  widget.category!.uniqueId;
                            }
                            widget.onClicked(newTransaction);
                          }

                          Navigator.pop(context);
                          setState(() {});
                        }),
                  ],
                ),
                const Divider(),
                TextFormField(
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  validator: (value) {
                    if (value!.isNotEmpty && value.length > 2) {
                      return null;
                    } else {
                      return 'Please add a name';
                    }
                  },
                  decoration: const InputDecoration(
                      labelText: 'Category Name', border: OutlineInputBorder()),
                  controller: nameController,
                ),
              ]),
            ),
          )
        ],
      ),
    );
  }
}
