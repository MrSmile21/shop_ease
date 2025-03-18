import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Navigate to Notifications Screen
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            _buildWelcomeSection(),
            SizedBox(height: 24),

            // Quick Stats Section
            _buildQuickStatsSection(),
            SizedBox(height: 24),

            // Shopping Lists Section
            _buildShoppingListsSection(),
            SizedBox(height: 24),

            // Deals Section
            _buildDealsSection(),
          ],
        ),
      ),
    );
  }

  // Welcome Section
  Widget _buildWelcomeSection() {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage('assets/profile_picture.png'),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back,',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              'Chathuranga',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  // Quick Stats Section
  Widget _buildQuickStatsSection() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard('Budget', '\$450', Icons.attach_money),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _buildStatCard('Recent Purchases', '12', Icons.shopping_cart),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _buildStatCard('Active Deals', '5', Icons.local_offer),
        ),
      ],
    );
  }

  // Stat Card Widget
  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // Shopping Lists Section
  Widget _buildShoppingListsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shopping Lists',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 3, // Replace with actual list length
          itemBuilder: (context, index) => ListTile(
            leading: Icon(Icons.list),
            title: Text('Shopping List ${index + 1}'),
            subtitle: Text('5 items'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to Shopping List Details
            },
          ),
        ),
      ],
    );
  }

  // Deals Section
  Widget _buildDealsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Active Deals',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildDealCard('50% Off Groceries', 'Valid until 12/31/2023'),
              SizedBox(width: 16),
              _buildDealCard('Buy 1 Get 1 Free', 'Valid until 11/15/2023'),
              SizedBox(width: 16),
              _buildDealCard('Free Shipping', 'Valid until 10/30/2023'),
            ],
          ),
        ),
      ],
    );
  }

  // Deal Card Widget
  Widget _buildDealCard(String title, String subtitle) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.local_offer, size: 40, color: Colors.orange),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              subtitle,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
