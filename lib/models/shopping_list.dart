import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingList {
  final String id;
  final String name;
  final List<ShoppingItem> items;
  final DateTime createdAt;
  final double totalBudget;
  final double totalSpent;

  ShoppingList({
    required this.id,
    required this.name,
    required this.items,
    required this.createdAt,
    this.totalBudget = 0.0,
    this.totalSpent = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'items': items.map((item) => item.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'totalBudget': totalBudget,
      'totalSpent': totalSpent,
    };
  }

  factory ShoppingList.fromMap(Map<String, dynamic> map, String documentId) {
    return ShoppingList(
      id: documentId,
      name: map['name'] ?? '',
      items: (map['items'] as List<dynamic>?)
              ?.map(
                  (item) => ShoppingItem.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      totalBudget: (map['totalBudget'] ?? 0.0).toDouble(),
      totalSpent: (map['totalSpent'] ?? 0.0).toDouble(),
    );
  }
}

class ShoppingItem {
  final String name;
  final double price;
  final int quantity;
  final bool isCompleted;

  ShoppingItem({
    required this.name,
    required this.price,
    required this.quantity,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
      'isCompleted': isCompleted,
    };
  }

  factory ShoppingItem.fromMap(Map<String, dynamic> map) {
    return ShoppingItem(
      name: map['name'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      quantity: map['quantity'] ?? 1,
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}
