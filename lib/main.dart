import 'package:expense_tracker/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/services/database_service.dart';
import 'package:expense_tracker/models/transaction.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbService = DatabaseService();
  await dbService.initializeDatabase();

  runApp(MyApp(dbService: dbService));
}

class MyApp extends StatelessWidget {
  final DatabaseService dbService;

  const MyApp({Key? key, required this.dbService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TransactionProvider(dbService)),
      ],
      child: MaterialApp(
        title: 'Expense Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      ),
    );
  }
}

class TransactionProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];
  final DatabaseService _dbService;

  TransactionProvider(this._dbService) {
    loadTransactions();
  }

  List<Transaction> get transactions => _transactions;

  Future<void> addTransaction(Transaction transaction) async {
    await _dbService.insertTransaction(transaction);
    await loadTransactions();
    notifyListeners();
  }

  Future<void> deleteTransaction(int id) async {
    await _dbService.deleteTransaction(id);
    await loadTransactions();
    notifyListeners();
  }

  Future<void> loadTransactions() async {
    _transactions = await _dbService.getTransactions();
    notifyListeners();
  }
}