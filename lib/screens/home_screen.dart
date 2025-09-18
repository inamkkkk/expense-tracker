import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/widgets/add_transaction_dialog.dart';
import 'package:expense_tracker/widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/widgets/spending_chart.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
      ),
      body: Column(
        children: [
          SpendingChart(),
          Expanded(
            child: TransactionList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddTransactionDialog();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}