import 'package:expenses_app/constants.dart';
import 'package:flutter/material.dart';
import '../locater.dart';
import '../models/transactions.dart';
import '../screens/expenses/expenses_bloc.dart';
import '../screens/expenses/widgets/bottom_sheet_widget.dart';
import '../services/hive_service.dart';

mixin WidgetsMixin {
  deleteAlert(int index, BuildContext context, ExpensesBloc bloc) {
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
                    bloc.myExpenses = locator<HiveService>()
                        .transactionBox
                        .values
                        .toList() as List<Transactions>;

                    for (int i = 0; i < bloc.myExpenses.length; i++) {
                      if (bloc.myExpenses[i].uniqueId ==
                          bloc.filteredList[index].uniqueId) {
                        bloc.myExpenses[i].delete();
                        // bloc.transactionsBox
                        //     .delete(bloc.myExpenses[i].uniqueId);
                        locator<HiveService>().deleteValue(
                            boxName: transactionsHive,
                            key: bloc.myExpenses[i].uniqueId!);
                      }
                    }
                    bloc.myExpenses = locator<HiveService>()
                        .transactionBox
                        .values
                        .toList() as List<Transactions>;
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
    final Transactions? trans,
    required Function(Transactions) onClicked,
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
              trans: trans,
              onClicked: (value) {
                onClicked(value);
              });
        });
  }
}
