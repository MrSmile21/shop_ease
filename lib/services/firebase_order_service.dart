import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order.dart'; // Still imports 'order.dart' but now it contains AppOrder

class FirebaseOrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _ordersCollection;

  FirebaseOrderService() {
    _ordersCollection = _firestore.collection('orders');
  }

  // 1. Add a new order
  Future<void> addOrder(AppOrder order) async { // Changed Order to AppOrder
    try {
      await _ordersCollection.add(order.toFirestore());
      print('Order added successfully!');
    } on FirebaseException catch (e) {
      print('Firebase Exception adding order: ${e.message}');
      throw Exception('Failed to add order: ${e.message}');
    } catch (e) {
      print('General Exception adding order: $e');
      throw Exception('Failed to add order: $e');
    }
  }

  // If you want to set an order with a specific ID (e.g., if ID comes from elsewhere)
  Future<void> setOrder(AppOrder order) async { // Changed Order to AppOrder
    try {
      await _ordersCollection.doc(order.id).set(order.toFirestore());
      print('Order set/updated successfully!');
    } on FirebaseException catch (e) {
      print('Firebase Exception setting order: ${e.message}');
      throw Exception('Failed to set order: ${e.message}');
    } catch (e) {
      print('General Exception setting order: $e');
      throw Exception('Failed to set order: $e');
    }
  }

  // 2. Update an existing order's status (or any other field)
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _ordersCollection.doc(orderId).update({'status': newStatus});
      print('Order $orderId status updated to $newStatus!');
    } on FirebaseException catch (e) {
      print('Firebase Exception updating order status: ${e.message}');
      throw Exception('Failed to update order status: ${e.message}');
    } catch (e) {
      print('General Exception updating order status: $e');
      throw Exception('Failed to update order status: $e');
    }
  }

  // 3. Fetch a single order by ID
  Future<AppOrder?> getOrderById(String orderId) async { // Changed Order to AppOrder
    try {
      final docSnapshot = await _ordersCollection.doc(orderId).get();
      if (docSnapshot.exists) {
        return AppOrder.fromFirestore(docSnapshot); // Changed Order.fromFirestore to AppOrder.fromFirestore
      }
      return null;
    } on FirebaseException catch (e) {
      print('Firebase Exception fetching order: ${e.message}');
      throw Exception('Failed to fetch order: ${e.message}');
    } catch (e) {
      print('General Exception fetching order: $e');
      throw Exception('Failed to fetch order: $e');
    }
  }

  // 4. Get a stream of all orders (real-time updates)
  Stream<List<AppOrder>> streamAllOrders() { // Changed Stream<List<Order>> to Stream<List<AppOrder>>
    return _ordersCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => AppOrder.fromFirestore(doc)).toList(); // Changed Order.fromFirestore to AppOrder.fromFirestore
    }).handleError((error) {
      print("Error streaming all orders: $error");
      throw Exception('Failed to stream all orders: $error');
    });
  }

  // 5. Get a stream of orders by status
  Stream<List<AppOrder>> streamOrdersByStatus(String status) { // Changed Stream<List<Order>> to Stream<List<AppOrder>>
    return _ordersCollection.where('status', isEqualTo: status).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => AppOrder.fromFirestore(doc)).toList(); // Changed Order.fromFirestore to AppOrder.fromFirestore
    }).handleError((error) {
      print("Error streaming orders by status ($status): $error");
      throw Exception('Failed to stream orders by status: $error');
    });
  }
}