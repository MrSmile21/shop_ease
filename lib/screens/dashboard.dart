import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/shopping_list_provider.dart';
import '../services/user_provider.dart'; // Make sure UserProvider is correctly defined
import '../services/deals_provider.dart';
import 'shopping_list.dart'; // Ensure this import is correct and ShoppingListScreen is defined there
import 'shopping_list_detail.dart';
import 'notification.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      // No need to explicitly call shoppingListProvider methods here as subscription
      // happens in its constructor.
      userProvider.fetchUserProfile('current_user_id');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(),
            const SizedBox(height: 24),
            _buildRecentShoppingLists(context),
            const SizedBox(height: 24),
            _buildDealsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (userProvider.isLoading) {
          return const CircularProgressIndicator();
        }
        if (userProvider.error != null) {
          return Text('Error: ${userProvider.error}');
        }
        // Assuming userProfile is a Map<String, dynamic> in UserProvider
        // You need to ensure your UserProvider has a getter named 'userProfile'
        // that returns Map<String, dynamic>?
        final userName = userProvider.userProfile?['username'] ?? 'User'; // Fix: Access userProfile
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back, $userName!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Ready to manage your shopping today?',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRecentShoppingLists(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Your Shopping Lists',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                // Fix: Ensure ShoppingListScreen is correctly defined and imported
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ShoppingListScreen(),
                  ),
                );
              },
              child: const Text('See All'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Consumer<ShoppingListProvider>(
          builder: (context, shoppingListProvider, child) {
            if (shoppingListProvider.isLoading && shoppingListProvider.shoppingLists.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (shoppingListProvider.error != null) {
              return Center(child: Text(shoppingListProvider.error!));
            }

            final lists = shoppingListProvider.shoppingLists;

            if (lists.isEmpty) {
              return const Center(
                child: Text('No shopping lists created yet.'),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: lists.length > 3 ? 3 : lists.length, // Show up to 3 recent lists
              itemBuilder: (context, index) {
                final list = lists[index];
                final itemsCount = (list['items'] as List?)?.length ?? 0;
                final itemsPreview = itemsCount > 0
                    ? '${itemsCount} item${itemsCount == 1 ? '' : 's'}'
                    : 'No items';

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    title: Text(list['title'] ?? 'Unnamed List'),
                    subtitle: Text(itemsPreview),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShoppingListDetailScreen(
                            listId: list['id'],
                            listName: list['title'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildDealsSection() {
    return Consumer<DealsProvider>(
      builder: (context, dealsProvider, child) {
        if (dealsProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (dealsProvider.error != null) {
          return Center(child: Text(dealsProvider.error!));
        }

        final deals = dealsProvider.deals;

        if (deals.isEmpty) {
          return const Center(child: Text('No active deals available'));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Active Deals',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: deals
                    .map((deal) => _buildDealCard(
                          deal['title'] ?? '',
                          deal['validity'] ?? '',
                        ))
                    .toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDealCard(String title, String subtitle) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.local_offer, size: 40, color: Colors.orange),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}