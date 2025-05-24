import 'package:cloud_firestore/cloud_firestore.dart';

class Budget {
  final String id;
  final String name;
  final double amount;
  final DateTime startDate;
  final DateTime endDate;
  final List<BudgetCategory> categories;
  final double totalSpent;

  Budget({
    required this.id,
    required this.name,
    required this.amount,
    required this.startDate,
    required this.endDate,
    required this.categories,
    this.totalSpent = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'categories': categories.map((category) => category.toMap()).toList(),
      'totalSpent': totalSpent,
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map, String documentId) {
    return Budget(
      id: documentId,
      name: map['name'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      categories: (map['categories'] as List<dynamic>?)
              ?.map((category) =>
                  BudgetCategory.fromMap(category as Map<String, dynamic>))
              .toList() ??
          [],
      totalSpent: (map['totalSpent'] ?? 0.0).toDouble(),
    );
  }

  double get remainingAmount => amount - totalSpent;
  bool get isOverBudget => totalSpent > amount;
  double get spentPercentage => (totalSpent / amount * 100).clamp(0.0, 100.0);
}

class BudgetCategory {
  final String name;
  final double allocation;
  final double spent;

  BudgetCategory({
    required this.name,
    required this.allocation,
    this.spent = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'allocation': allocation,
      'spent': spent,
    };
  }

  factory BudgetCategory.fromMap(Map<String, dynamic> map) {
    return BudgetCategory(
      name: map['name'] ?? '',
      allocation: (map['allocation'] ?? 0.0).toDouble(),
      spent: (map['spent'] ?? 0.0).toDouble(),
    );
  }

  double get remaining => allocation - spent;
  bool get isOverBudget => spent > allocation;
  double get spentPercentage => (spent / allocation * 100).clamp(0.0, 100.0);
}
