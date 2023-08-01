import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class Wallet extends StatelessWidget {
  final double income;
  final double outcome;
  // final Map<String, int> chartExpensesDataMap;

  const Wallet({
    super.key,
    required this.income,
    required this.outcome,
    // required this.chartExpensesDataMap
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color.fromARGB(255, 123, 174, 169),
          ),
          width: MediaQuery.sizeOf(context).width,
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  textAlign: TextAlign.center,
                  'Account balance ${income - outcome}JD',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(' Income \n $income JD',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    // PieChart(
                    //   dataMap: ,
                    // ),
                    Text(' Outcome \n $outcome JD',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
