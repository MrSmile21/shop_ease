// main.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'screens/dashboard.dart';
import 'screens/shopping_list.dart';
import 'screens/deals.dart';
import 'screens/shop.dart';
import 'screens/profile.dart';
import 'screens/auth_screen.dart';
import 'screens/splash_screen.dart';
import 'services/shopping_list_provider.dart';
import 'services/budget_provider.dart';
import 'services/user_provider.dart';
import 'services/deals_provider.dart';
import 'services/cart_provider.dart';
import 'providers/order_provider.dart'; // Correct import for OrderProvider
import 'services/firebase_order_service.dart';
import 'services/firebase_service.dart'; // Import the new FirebaseService
import 'screens/order_details.dart';
import 'screens/order_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase for web and other platforms
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyBDOpeLAww_RVYm7T-SIZFhsbLmANkeCPE",
        authDomain: "shop-ease-d8eb1.firebaseapp.com",
        projectId: "shop-ease-d8eb1",
        storageBucket: "shop-ease-d8eb1.firebasestorage.app",
        messagingSenderId: "181885205222",
        appId: "1:181885205222:web:f520aa231980348172d927",
      ),
    );
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(
    MultiProvider(
      providers: [
        // Existing Providers
        ChangeNotifierProvider(create: (_) => BudgetProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => DealsProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),

        // Provide FirebaseOrderService
        Provider<FirebaseOrderService>(
          create: (_) => FirebaseOrderService(),
        ),
        // Provide OrderProvider, depending on FirebaseOrderService
        ChangeNotifierProxyProvider<FirebaseOrderService, OrderProvider>(
          create: (context) => OrderProvider(
            Provider.of<FirebaseOrderService>(context, listen: false),
          ),
          update: (context, firebaseOrderService, orderProvider) =>
              OrderProvider(firebaseOrderService),
        ),

        // NEW: Provide FirebaseService for shopping lists
        Provider<FirebaseService>(
          create: (_) => FirebaseService(),
        ),
        // NEW: Provide ShoppingListProvider, depending on FirebaseService
        ChangeNotifierProxyProvider<FirebaseService, ShoppingListProvider>(
          create: (context) => ShoppingListProvider(
            Provider.of<FirebaseService>(context, listen: false),
          ),
          update: (context, firebaseService, shoppingListProvider) =>
              ShoppingListProvider(firebaseService),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopEase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/dashboard': (context) => const MainNavigation(),
        '/orders': (context) => const OrderListScreen(),
        '/order_details': (context) => const OrderDetailsScreen(),
        '/shopping_lists': (context) => const ShoppingListScreen(),
      },
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          if (snapshot.hasData) {
            return const MainNavigation();
          }
          return const AuthScreen();
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    DashboardScreen(),
    ShoppingListScreen(),
    DealsScreen(),
    ShopScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Lists',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            label: 'Deals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}