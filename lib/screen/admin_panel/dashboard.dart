import 'package:flutter/material.dart';
import 'package:my_web_app/screen/admin_panel/addproduct.dart';
import 'package:my_web_app/screen/admin_panel/editproduct.dart';

class DashboardScreen extends StatefulWidget {
  final String name;

  const DashboardScreen({
    super.key,
    required this.name,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
   int currentIndex=0;

    final List<Widget> pages=[
    const AddProduct(),
    const EditProduct(product: {
  "id": 0,
  "name": "",
  "price": 0,
  "image_url": ""
}),
    ];
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Panel, ${widget.name}"),
        backgroundColor: Colors.blue,
      ),drawer: Drawer(
        
        child: ListView(
          children: [DrawerHeader(child: CircleAvatar(backgroundColor: Colors.black,)),
          
          ListTile(
            leading: Icon(Icons.add),title: Text("AddData"),
            onTap: () {
              setState(() {
                currentIndex=0;
              });
            },
          ),
         
          ListTile(
            leading: Icon(Icons.edit),title: Text("Edit"),
            onTap: () {
              setState(() {
                currentIndex=1;
              });
            },
          ),
        
          ],
        ),
        
      
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
  currentIndex: currentIndex,
  onTap: (value) {
    setState(() {
      currentIndex = value;
    });
  },
  items: const [
    BottomNavigationBarItem(
      icon: Icon(Icons.add),
      label: "Add",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.edit),
      label: "Edit",
    ),
  ],
)
    );
  }
}