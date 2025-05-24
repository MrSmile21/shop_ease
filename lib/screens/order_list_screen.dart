import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../models/order.dart'; // Still imports 'order.dart' but now it contains AppOrder

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  String _currentFilterStatus = 'all';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _addOrder(context),
          ),
        ],
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.status == OrderLoadingStatus.loading && orderProvider.allOrders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (orderProvider.status == OrderLoadingStatus.error) {
            return Center(
              child: Text('Error: ${orderProvider.errorMessage}\nPlease try again.'),
            );
          }
          if (orderProvider.allOrders.isEmpty && orderProvider.status == OrderLoadingStatus.loaded) {
            return const Center(child: Text('No orders found. Add some!'));
          }

          final displayedOrders = _currentFilterStatus == 'all'
              ? orderProvider.allOrders
              : orderProvider.allOrders
                  .where((order) => order.status == _currentFilterStatus)
                  .toList();

          return Column(
            children: [
              _buildFilterChips(orderProvider),
              Expanded(
                child: ListView.builder(
                  itemCount: displayedOrders.length,
                  itemBuilder: (context, index) {
                    final order = displayedOrders[index]; // This 'order' is now an AppOrder
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: order.productImage.isNotEmpty
                            ? Image.network(order.productImage, width: 50, height: 50, fit: BoxFit.cover)
                            : const Icon(Icons.shopping_bag),
                        title: Text(order.productName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Status: ${order.status}'),
                            Text('Price: \$${order.price.toStringAsFixed(2)} x ${order.quantity}'),
                            Text('Date: ${order.orderDate.toLocal().toString().split(' ')[0]}'),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'shipped') {
                              orderProvider.updateOrderStatus(order.id, 'shipped');
                            } else if (value == 'delivered') {
                              orderProvider.updateOrderStatus(order.id, 'delivered');
                            } else if (value == 'cancelled') {
                              orderProvider.updateOrderStatus(order.id, 'cancelled');
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return [
                              const PopupMenuItem(value: 'shipped', child: Text('Mark as Shipped')),
                              const PopupMenuItem(value: 'delivered', child: Text('Mark as Delivered')),
                              const PopupMenuItem(value: 'cancelled', child: Text('Mark as Cancelled')),
                            ];
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChips(OrderProvider orderProvider) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FilterChip(
            label: const Text('All'),
            selected: _currentFilterStatus == 'all',
            onSelected: (selected) {
              if (selected) {
                setState(() {
                  _currentFilterStatus = 'all';
                });
              }
            },
          ),
          FilterChip(
            label: const Text('Pending'),
            selected: _currentFilterStatus == 'pending',
            onSelected: (selected) {
              if (selected) {
                setState(() {
                  _currentFilterStatus = 'pending';
                });
              }
            },
          ),
          FilterChip(
            label: const Text('Shipped'),
            selected: _currentFilterStatus == 'shipped',
            onSelected: (selected) {
              if (selected) {
                setState(() {
                  _currentFilterStatus = 'shipped';
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _addOrder(BuildContext context) async {
    final productNameController = TextEditingController();
    final priceController = TextEditingController();
    final quantityController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Order'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: productNameController, decoration: const InputDecoration(labelText: 'Product Name')),
              TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
              TextField(controller: quantityController, decoration: const InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (productNameController.text.isNotEmpty &&
                    priceController.text.isNotEmpty &&
                    quantityController.text.isNotEmpty) {
                  final newOrder = AppOrder( // Changed Order to AppOrder
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    status: 'pending',
                    productName: productNameController.text,
                    productImage: 'https://via.placeholder.com/150',
                    price: double.tryParse(priceController.text) ?? 0.0,
                    quantity: int.tryParse(quantityController.text) ?? 0,
                    orderDate: DateTime.now(),
                  );
                  await Provider.of<OrderProvider>(context, listen: false).addNewOrder(newOrder);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}