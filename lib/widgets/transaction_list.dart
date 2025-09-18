import 'package:expense_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final transactions = transactionProvider.transactions;

    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return Card(
          child: ListTile(
            leading: Icon(transaction.isIncome ? Icons.arrow_upward : Icons.arrow_downward, color: transaction.isIncome ? Colors.green : Colors.red),
            title: Text(transaction.title),
            subtitle: Text('${DateFormat('yyyy-MM-dd').format(transaction.date)} - ${transaction.category}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$${transaction.amount.toStringAsFixed(2)}'),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    transactionProvider.deleteTransaction(transaction.id!);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}