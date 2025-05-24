import 'package:flutter/foundation.dart';
import '../models/budget.dart';
import 'database_service.dart';

class BudgetProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<Budget> _budgets = [];
  bool _isLoading = false;

  List<Budget> get budgets => _budgets;
  bool get isLoading => _isLoading;

  Future<void> fetchBudgets() async {
    _isLoading = true;
    notifyListeners();

    try {
      _databaseService.getBudgets().listen((budgets) {
        _budgets = budgets;
        notifyListeners();
      });
    } catch (e) {
      print('Error fetching budgets: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addBudget(Budget budget) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _databaseService.addBudget(budget);
    } catch (e) {
      print('Error adding budget: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateBudget(Budget budget) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _databaseService.updateBudget(budget);
    } catch (e) {
      print('Error updating budget: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteBudget(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _databaseService.deleteBudget(id);
    } catch (e) {
      print('Error deleting budget: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
