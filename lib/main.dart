import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopease/screens/budget.dart';
import 'package:shopease/screens/deals.dart';
import 'package:shopease/screens/profile.dart';
import 'package:shopease/screens/shopping_list.dart';
import 'screens/dashboard.dart';
import 'package:provider/provider.dart';
import 'services/shopping_list_provider.dart';
import 'screens/dashboard.dart';
import 'screens/shopping_list.dart';
import 'screens/deals.dart';
import 'screens/budget.dart';
import 'screens/profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBDOpeLAww_RVYm7T-SIZFhsbLmANkeCPE",
            authDomain: "shop-ease-d8eb1.firebaseapp.com",
            projectId: "shop-ease-d8eb1",
            storageBucket: "shop-ease-d8eb1.firebasestorage.app",
            messagingSenderId: "181885205222",
            appId: "1:181885205222:web:f520aa231980348172d927"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ShoppingListProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopEase',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    DashboardScreen(), // Home Page
    ShoppingListScreen(),
    DealsScreen(),
    BudgetScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Lists'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_offer), label: 'Deals'),
          BottomNavigationBarItem(
              icon: Icon(Icons.attach_money), label: 'Budget'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
