import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cart_provider.dart';
import 'cart_details.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        elevation: 0,
        actions: [
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.shopping_cart,
                    size: 24,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CartDetailsScreen(),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                right: 10,
                top: 4,
                child: Consumer<CartProvider>(
                  builder: (context, cart, child) {
                    return cart.totalQuantity == 0
                        ? Container()
                        : Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Text(
                              '${cart.totalQuantity}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                  },
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Groceries'),
            Tab(text: 'Health Care'),
            Tab(text: 'Cleaning'),
            Tab(text: 'Electronic'),
            Tab(text: 'Foods'),
            Tab(text: 'Perfumes'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCategoryList('Groceries'),
          _buildCategoryList('Health Care'),
          _buildCategoryList('Cleaning'),
          _buildCategoryList('Electronic'),
          _buildCategoryList('Foods'),
          _buildCategoryList('Perfumes'),
        ],
      ),
    );
  }

  Widget _buildCategoryList(String category) {
    if (category == 'Cleaning') {
      return ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildProductCard(
            'Lysol Disinfectant',
            '500 ml',
            'All Purpose Cleaner',
            'Rs. 180.00',
            'assets/images/Cleaning/lysol.png',
            true,
          ),
          const SizedBox(height: 16),
          _buildProductCard(
            'Harpic Green',
            '750 ml',
            'Toilet Cleaner',
            'Rs. 120.00',
            'assets/images/Cleaning/harpic_green.png',
            true,
          ),
          const SizedBox(height: 16),
          _buildProductCard(
            'Vim Dish Powder',
            '500 g',
            'Dishwashing Powder',
            'Rs. 60.00',
            'assets/images/Cleaning/vim_powder.png',
            true,
          ),
          const SizedBox(height: 16),
          _buildProductCard(
            'Dettol Gel',
            '250 ml',
            'Hand Sanitizer',
            'Rs. 85.00',
            'assets/images/Cleaning/dettol.png',
            true,
          ),
        ],
      );
    }
    if (category == 'Electronic') {
      return ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildProductCard(
            'Samsung Galaxy S25',
            '256GB',
            'Brand New',
            'Rs. 240,000.00',
            'assets/images/Electronics/s25.png',
            true,
          ),
          const SizedBox(height: 16),
          _buildProductCard(
            'Samsung Galaxy S25 Plus',
            '256GB',
            'Brand New',
            'Rs. 275,000.00',
            'assets/images/Electronics/s25plus.png',
            true,
          ),
          const SizedBox(height: 16),
          _buildProductCard(
            'Samsung Gear IV',
            '40mm',
            'Brand New',
            'Rs. 120,000.00',
            'assets/images/Electronics/swatch.png',
            true,
          ),
          const SizedBox(height: 16),
          _buildProductCard(
            'Electric Kettle',
            '1500 ml',
            '1 Year Warranty',
            'Rs. 6,500.00',
            'assets/images/Electronics/ekettle.png',
            true,
          ),
        ],
      );
    }
    if (category == 'Health Care') {
      return ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildProductCard(
            'Medical Plaster',
            '10 pcs',
            'Waterproof & Breathable',
            'Rs. 45.00',
            'assets/images/Health/plaster.png',
            true,
          ),
          const SizedBox(height: 16),
          _buildProductCard(
            'Betadine Solution',
            '100 ml',
            'Antiseptic & Disinfectant',
            'Rs. 120.00',
            'assets/images/Health/betadine.png',
            true,
          ),
          const SizedBox(height: 16),
          _buildProductCard(
            'Surgical Kit',
            '1 set',
            'Basic First Aid',
            'Rs. 250.00',
            'assets/images/Health/surgical.png',
            true,
          ),
          const SizedBox(height: 16),
          _buildProductCard(
            'Medical Face Mask',
            '50 pcs',
            '3-Ply Protection',
            'Rs. 150.00',
            'assets/images/Health/mask.png',
            true,
          ),
        ],
      );
    }
    if (category == 'Foods') {
      return ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildProductCard(
            'Classic Burger',
            '250g',
            'Fresh & Juicy',
            'Rs. 180.00',
            'assets/burger.png',
            true,
          ),
          const SizedBox(height: 16),
          _buildProductCard(
            'Glazed Donut',
            '80g',
            'Sweet & Fluffy',
            'Rs. 60.00',
            'assets/donut.png',
            true,
          ),
          const SizedBox(height: 16),
          _buildProductCard(
            'Chocolate Muffin',
            '100g',
            'Freshly Baked',
            'Rs. 80.00',
            'assets/images/Foods/muffin.png',
            true,
          ),
          const SizedBox(height: 16),
          _buildProductCard(
            'Cheese Bun',
            '120g',
            'Soft & Cheesy',
            'Rs. 70.00',
            'assets/images/Foods/cheese-bun.png',
            true,
          ),
        ],
      );
    }
    if (category == 'Perfumes') {
      return ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildProductCard(
            'BLEU the Chanel Parfum Pour',
            '50ml',
            'For Men',
            'Rs. 16,300.00',
            'assets/images/Perfumes/bleu.png',
            true,
          ),
          const SizedBox(height: 16),
          _buildProductCard(
            'Roja Parfum Pour',
            '50ml',
            'For Men',
            'Rs. 38,000.00',
            'assets/images/Perfumes/roja.png',
            true,
          ),
          const SizedBox(height: 16),
          _buildProductCard(
            'Amouage Parfum Pour',
            '75ml',
            'For Men',
            'Rs. 23,000.00',
            'assets/images/Perfumes/amouage.png',
            true,
          ),
          const SizedBox(height: 16),
          _buildProductCard(
            'PRADA Rosetto',
            '30ml',
            'For Women',
            'Rs. 9,600.00',
            'assets/images/Perfumes/prada.png',
            true,
          ),
        ],
      );
    }
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildProductCard(
          'Purnama Krimer',
          '400.0 g',
          'Milk Mix',
          'Rs. 99.40',
          'assets/images/milk_mix.png',
          true,
        ),
        const SizedBox(height: 16),
        _buildProductCard(
          'Purnama Butter',
          '200.0 g',
          'Plant Based',
          'Rs. 60.00',
          'assets/images/butter.png',
          true,
        ),
        const SizedBox(height: 16),
        _buildProductCard(
          'Kinnela Processed Cheese',
          '120.0 g',
          '',
          'Rs. 40.00',
          'assets/images/cheese.png',
          true,
        ),
        const SizedBox(height: 16),
        _buildProductCard(
          'Andowesia Fresh Milk',
          '1.0 L',
          '',
          'Rs. 50.00',
          'assets/images/milk.png',
          true,
        ),
      ],
    );
  }

  Widget _buildProductCard(
    String name,
    String weight,
    String description,
    String price,
    String imagePath,
    bool hasDiscount,
  ) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 16),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  weight,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          // Add to Cart Button
          GestureDetector(
            onTap: () async {
              final int? quantity = await showDialog<int>(
                context: context,
                builder: (BuildContext context) {
                  int selectedQuantity = 1;
                  return AlertDialog(
                    title: const Text('Select Quantity'),
                    content: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: selectedQuantity > 1
                                  ? () => setState(() => selectedQuantity--)
                                  : null,
                            ),
                            Text(
                              '$selectedQuantity',
                              style: const TextStyle(fontSize: 20),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () =>
                                  setState(() => selectedQuantity++),
                            ),
                          ],
                        );
                      },
                    ),
                    actions: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: const Text('Add to Cart'),
                        onPressed: () =>
                            Navigator.of(context).pop(selectedQuantity),
                      ),
                    ],
                  );
                },
              );

              if (quantity != null) {
                final cart = Provider.of<CartProvider>(context, listen: false);
                // First check if item already exists in cart
                if (cart.items.containsKey(name)) {
                  // If it exists, remove it first to reset quantity
                  cart.removeItem(name);
                }

                // Add item with the selected quantity
                cart.addItem(
                  id: name,
                  name: name,
                  weight: weight,
                  description: description,
                  price: price,
                  imagePath: imagePath,
                );

                // Update quantity if more than 1
                if (quantity > 1) {
                  for (var i = 1; i < quantity; i++) {
                    cart.addItem(
                      id: name,
                      name: name,
                      weight: weight,
                      description: description,
                      price: price,
                      imagePath: imagePath,
                    );
                  }
                }

                // Show add to cart animation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                            'Added $quantity ${quantity == 1 ? 'item' : 'items'} to cart'),
                      ],
                    ),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(8.0),
              child: const Icon(
                Icons.add_shopping_cart,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
