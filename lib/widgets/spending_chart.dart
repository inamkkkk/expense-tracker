import 'package:expense_tracker/main.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpendingChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final transactions = transactionProvider.transactions;

    // Calculate category spending
    Map<String, double> categorySpending = {};
    for (var transaction in transactions) {
      if (!transaction.isIncome) {
        categorySpending.update(
          transaction.category, 
          (existingValue) => existingValue + transaction.amount, 
          ifAbsent: () => transaction.amount
        );
      }
    }

    List<PieChartSectionData> sections = [];
    categorySpending.forEach((category, amount) {
      sections.add(
        PieChartSectionData(
          color: _getColor(category), // Assign colors based on category
          value: amount,
          title: '$${amount.toStringAsFixed(1)}',  // Adjusted to show total amount per category
          radius: 50,  // Adjusted radius for better visualization
          titleStyle: const TextStyle(
            fontSize: 12,  // Adjusted title size
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    });

    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            const SizedBox(height: 18),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: sections,
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: categorySpending.entries.map((entry) {
                return Indicator(
                  color: _getColor(entry.key),
                  text: entry.key,
                  isSquare: true,
                );
              }).toList(),
            ),
            const SizedBox(width: 10),  // Add some spacing
          ],
        ),
      ),
    );
  }

  // Function to assign colors to categories
  Color _getColor(String category) {
    switch (category) {
      case 'Food':
        return Colors.red;
      case 'Transportation':
        return Colors.green;
      case 'Shopping':
        return Colors.blue;
      case 'Entertainment':
        return Colors.yellow;
      default:
        return Colors.purple;
    }
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}