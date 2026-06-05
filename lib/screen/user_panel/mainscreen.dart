import 'package:my_web_app/screen/user_panel/cart.dart';
import 'package:my_web_app/screen/user_panel/home.dart';
import 'package:my_web_app/screen/user_panel/login.dart';
import 'package:my_web_app/screen/user_panel/product.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  const MainScreen({super.key, required this.userName , required this.userEmail});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${widget.userName}"),
        backgroundColor: Colors.amber,
          actions: [
            IconButton(onPressed: (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
     }, icon: Icon(Icons.person)),
IconButton(
  icon: const Icon(Icons.shopping_cart),
  onPressed: () {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Shopping Cart"),
        contentPadding: const EdgeInsets.all(8),
        content: const CartScreen(),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  },
),
          ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(accountName: Text(widget.userName), accountEmail: Text(widget.userEmail)),
            ListTile(
              leading: Icon(Icons.home),
              
              title: Text("Home"),
              onTap: () {
                setState(() {
                  currentIndex=0;
                });
              },
            ),
             ListTile(
              leading: Icon(Icons.production_quantity_limits),
              title: Text("Product"),
              onTap: () {
                setState(() {
                  currentIndex=1;
                });
              },
            )
          ],
        ),
      ),

      body: IndexedStack(
        index: currentIndex,
        children: [
          HomePage(userName: widget.userName),
          const ProductScreen(),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: "Products",
          ),
        ],
      ),
    );
  }
}