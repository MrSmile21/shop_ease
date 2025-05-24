import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Shopping List Operations
  Future<void> createShoppingList(Map<String, dynamic> list) async {
    try {
      await _firestore.collection('shoppingLists').doc(list['listId']).set({
        'category': list['category'],
        'createdAt': FieldValue.serverTimestamp(),
        'description': list['description'],
        'estimatedTotal': list['estimatedTotal'],
        'ownerId': list['ownerId'],
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error creating shopping list: $e');
      rethrow;
    }
  }

  // Shopping List Items Operations
  Future<void> addItemToList(String listId, Map<String, dynamic> item) async {
    try {
      await _firestore
          .collection('shoppingLists')
          .doc(listId)
          .collection('items')
          .add({
        'item': item['item'],
        'storeName': item['storeName'],
        'timestamp': FieldValue.serverTimestamp(),
        'totalSpend': item['totalSpend'],
      });
    } catch (e) {
      print('Error adding item to list: $e');
      rethrow;
    }
  }

  // Deals Operations
  Future<void> createDeal(Map<String, dynamic> deal) async {
    try {
      await _firestore.collection('deals').add({
        'description': deal['description'],
        'title': deal['title'],
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error creating deal: $e');
      rethrow;
    }
  }

  // User Preferences Operations
  Future<void> updateUserPreferences(
      String userId, Map<String, dynamic> item) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'estimatePrice': item['estimatePrice'],
        'isChecked': item['isChecked'],
        'name': item['name'],
        'quantity': item['quantity'],
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error updating user preferences: $e');
      rethrow;
    }
  }

  // Store Location Operations
  Future<void> addStoreLocation(Map<String, dynamic> store) async {
    try {
      await _firestore.collection('storeLocations').add({
        'name': store['name'],
        'address': store['address'],
        'coordinates': GeoPoint(store['latitude'], store['longitude']),
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding store location: $e');
      rethrow;
    }
  }

  // Price Comparison Operations
  Future<void> addPriceComparison(Map<String, dynamic> price) async {
    try {
      await _firestore.collection('priceComparisons').add({
        'itemName': price['itemName'],
        'storeName': price['storeName'],
        'price': price['price'],
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding price comparison: $e');
      rethrow;
    }
  }

  // Stream Operations
  Stream<QuerySnapshot> getShoppingListsStream(String userId) {
    return _firestore
        .collection('shoppingLists')
        .where('ownerId', isEqualTo: userId)
        .snapshots();
  }

  Stream<QuerySnapshot> getDealsStream() {
    return _firestore
        .collection('deals')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getStoreLocationsStream() {
    return _firestore.collection('storeLocations').snapshots();
  }

  Stream<QuerySnapshot> getPriceComparisonsStream(String itemName) {
    return _firestore
        .collection('priceComparisons')
        .where('itemName', isEqualTo: itemName)
        .orderBy('price')
        .snapshots();
  }
}
