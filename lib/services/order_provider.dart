// lib/providers/order_provider.dart
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Keep this import if needed elsewhere, but not directly for OrderProvider's _orders list
import '../models/order.dart'; // Imports AppOrder
import '../services/firebase_order_service.dart';
import 'dart:async';

enum OrderLoadingStatus { initial, loading, loaded, error } // Re-add this enum if it was removed

class OrderProvider with ChangeNotifier {
  final FirebaseOrderService _firebaseOrderService; // No longer instantiated directly here

  List<AppOrder> _allOrders = []; // Changed to _allOrders for clarity, and to AppOrder
  OrderLoadingStatus _status = OrderLoadingStatus.initial; // Re-add status management
  String? _errorMessage; // Re-add error message management

  StreamSubscription<List<AppOrder>>? _ordersSubscription; // Manage stream subscription

  // Constructor now requires FirebaseOrderService to be injected
  OrderProvider(this._firebaseOrderService) {
    _listenToAllOrders(); // Start listening to stream on creation
  }

  // Getter to expose the current list of all orders
  List<AppOrder> get allOrders => [..._allOrders]; // Changed to AppOrder
  OrderLoadingStatus get status => _status;
  String? get errorMessage => _errorMessage;


  // Removed this as FirebaseOrderService provides streams of List<AppOrder>, not QuerySnapshot directly
  // Stream<QuerySnapshot> get ordersStream => _firebaseOrderService.getOrdersStream();


  void _setStatus(OrderLoadingStatus newStatus) {
    _status = newStatus;
    notifyListeners();
  }

  void _setErrorMessage(String message) {
    _errorMessage = message;
    _setStatus(OrderLoadingStatus.error);
  }

  // Method to start listening to the real-time stream of all orders
  void _listenToAllOrders() {
    _setStatus(OrderLoadingStatus.loading);
    _ordersSubscription?.cancel(); // Cancel any existing subscription

    _ordersSubscription = _firebaseOrderService.streamAllOrders().listen(
      (orders) {
        _allOrders = orders; // Update the internal list
        _setStatus(OrderLoadingStatus.loaded); // Set status to loaded
        _errorMessage = null; // Clear any previous error
      },
      onError: (error) {
        _setErrorMessage('Failed to load orders: $error');
        print("Provider Error: $error");
      },
      onDone: () {
        print("Order stream done.");
      },
    );
  }

  // Method to get a filtered list from the currently loaded orders
  // This is a synchronous getter, not a Future, as it operates on already loaded data
  List<AppOrder> getOrdersByStatus(String? status) { // Changed to AppOrder
    if (status == null || status == 'All') { // 'All' for the tab filter
      return _allOrders;
    }
    return _allOrders.where((order) => order.status == status).toList();
  }


  Future<void> addOrder({
    required String productName,
    required String productImage,
    required double price,
    required int quantity,
  }) async {
    _setStatus(OrderLoadingStatus.loading); // Indicate loading
    try {
      final order = AppOrder( // Changed Order to AppOrder
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Use a more robust ID
        status: 'To Pay',
        productName: productName,
        productImage: productImage,
        price: price,
        quantity: quantity,
        orderDate: DateTime.now(),
      );

      await _firebaseOrderService.addOrder(order);
      // No need to call getOrdersByStatus(null) here because the stream will automatically update _allOrders
      _setStatus(OrderLoadingStatus.loaded); // Indicate success
      _errorMessage = null;
    } catch (e) {
      _setErrorMessage('Error adding order: $e');
      throw Exception('Failed to add order');
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    _setStatus(OrderLoadingStatus.loading); // Indicate loading
    try {
      await _firebaseOrderService.updateOrderStatus(orderId, newStatus);
      // No need to call getOrdersByStatus(null) here because the stream will automatically update _allOrders
      _setStatus(OrderLoadingStatus.loaded); // Indicate success
      _errorMessage = null;
    } catch (e) {
      _setErrorMessage('Error updating order status: $e');
      throw Exception('Failed to update order status');
    }
  }

  @override
  void dispose() {
    _ordersSubscription?.cancel(); // Crucial: Cancel the stream subscription when the provider is disposed
    super.dispose();
  }
}