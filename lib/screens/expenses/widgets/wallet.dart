import 'package:expenses_app/extentions.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class Wallet extends StatelessWidget {
  final double income;
  final double outcome;
  final String color;
  final Map<String, double>? pieMap;

  const Wallet(
      {Key? key,
      required this.income,
      required this.outcome,
      this.pieMap,
      required this.color})
      : super(key: key);

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
          width: MediaQuery.of(context).size.width,
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Account balance ${income - outcome}JD',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: color.toColor()),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ' Income \n $income JD',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: color.toColor()),
                    ),
                    if (pieMap != null && pieMap!.isNotEmpty)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8.0), // Adjust the values as needed
                          child: PieChart(
                            chartLegendSpacing: 10,
                            chartType: ChartType.disc,
                            chartRadius: 60,
                            dataMap: pieMap!,
                            chartValuesOptions: const ChartValuesOptions(
                                showChartValues: false),
                            legendOptions: const LegendOptions(
                              legendTextStyle: TextStyle(fontSize: 8),
                              legendPosition: LegendPosition.bottom,
                              showLegendsInRow: true,
                            ),
                          ),
                        ),
                      ),
                    Text(
                      ' Outcome \n $outcome JD',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: color.toColor()),
                    ),
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
