// lib/providers/order_provider.dart
import 'package:flutter/material.dart';
import 'dart:async';
import '../models/order.dart';
import '../services/firebase_order_service.dart';

enum OrderLoadingStatus { initial, loading, loaded, error }

class OrderProvider with ChangeNotifier {
  final FirebaseOrderService _firebaseOrderService;

  List<AppOrder> _allOrders = [];
  OrderLoadingStatus _status = OrderLoadingStatus.initial;
  String? _errorMessage;

  StreamSubscription<List<AppOrder>>? _ordersSubscription;

  OrderProvider(this._firebaseOrderService) {
    _listenToAllOrders();
  }

  List<AppOrder> get allOrders => _allOrders;
  OrderLoadingStatus get status => _status;
  String? get errorMessage => _errorMessage;

  void _setStatus(OrderLoadingStatus newStatus) {
    _status = newStatus;
    notifyListeners();
  }

  void _setErrorMessage(String message) {
    _errorMessage = message;
    _setStatus(OrderLoadingStatus.error);
  }

  void _listenToAllOrders() {
    _setStatus(OrderLoadingStatus.loading);
    _ordersSubscription?.cancel();

    _ordersSubscription = _firebaseOrderService.streamAllOrders().listen(
      (orders) {
        _allOrders = orders;
        _setStatus(OrderLoadingStatus.loaded);
        _errorMessage = null;
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

  // --- NEW METHOD/GETTER TO PROVIDE FILTERED LIST ---
  List<AppOrder> getOrdersByStatus(String? status) {
    if (status == null) {
      return _allOrders; // Return all orders if status is null
    }
    return _allOrders.where((order) => order.status == status).toList();
  }

  Future<void> addNewOrder(AppOrder order) async {
    _setStatus(OrderLoadingStatus.loading);
    try {
      await _firebaseOrderService.addOrder(order);
      _setStatus(OrderLoadingStatus.loaded);
      _errorMessage = null;
    } catch (e) {
      _setErrorMessage('Failed to add order: $e');
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    _setStatus(OrderLoadingStatus.loading);
    try {
      await _firebaseOrderService.updateOrderStatus(orderId, newStatus);
      _setStatus(OrderLoadingStatus.loaded);
      _errorMessage = null;
    } catch (e) {
      _setErrorMessage('Failed to update order status: $e');
    }
  }

  @override
  void dispose() {
    _ordersSubscription?.cancel();
    super.dispose();
  }
}