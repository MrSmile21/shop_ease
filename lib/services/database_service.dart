import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/shopping_list.dart';
import '../models/budget.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Shopping List Operations
  Future<String> addShoppingList(ShoppingList list) async {
    final docRef =
        await _firestore.collection('shoppingLists').add(list.toMap());
    return docRef.id;
  }

  Stream<List<ShoppingList>> getShoppingLists() {
    return _firestore
        .collection('shoppingLists')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ShoppingList.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> updateShoppingList(ShoppingList list) async {
    await _firestore
        .collection('shoppingLists')
        .doc(list.id)
        .update(list.toMap());
  }

  Future<void> deleteShoppingList(String id) async {
    await _firestore.collection('shoppingLists').doc(id).delete();
  }

  // Budget Operations
  Future<String> addBudget(Budget budget) async {
    final docRef = await _firestore.collection('budgets').add(budget.toMap());
    return docRef.id;
  }

  Stream<List<Budget>> getBudgets() {
    return _firestore
        .collection('budgets')
        .orderBy('startDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Budget.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> updateBudget(Budget budget) async {
    await _firestore
        .collection('budgets')
        .doc(budget.id)
        .update(budget.toMap());
  }

  Future<void> deleteBudget(String id) async {
    await _firestore.collection('budgets').doc(id).delete();
  }
}
