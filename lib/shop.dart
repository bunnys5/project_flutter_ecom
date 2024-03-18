import 'package:flutter/material.dart';
import 'screens/product.dart';
import 'screens/sale.dart';
import 'screens/slip.dart';
import 'services/auth_service.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: MenuPage(
        user_name: 'Test',
        user_status: null,
      ),
    );
  }
}

class MenuPage extends StatefulWidget {
  final String user_name;
  final String? user_status;

  const MenuPage({Key? key, required this.user_name, required this.user_status})
      : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late List<Widget> menu;
  int index = 0;

  @override
  void initState() {
    super.initState();
    menu = [
      Product(user_name: widget.user_name),
      Sale(
        image_path: null,
        user_name: widget.user_name,
      ),
      Slip(
        user_name: widget.user_name,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการอาหารและเครื่องดื่ม'),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text('Profile'),
                  value: 'profile',
                ),
                PopupMenuItem(
                  child: Text('Settings'),
                  value: 'settings',
                ),
                PopupMenuItem(
                  child: Text('Logout'),
                  value: 'logout',
                ),
              ];
            },
            onSelected: (String value) {
              // Handle menu item selection here
              print('Selected menu item: $value');
            },
            child: IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(100, 100, 0, 0),
                  items: [
                    PopupMenuItem(
                      child: Text('ชื่อผู้ใช้งาน ${widget.user_name}'),
                    ),
                    PopupMenuItem(
                      child: Text('${widget.user_status}'),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      body: menu[index],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: index,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.production_quantity_limits),
            label: 'สินค้า',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sailing),
            label: 'สั่งซื้อ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'ชำระ',
          ),
        ],
      ),
    );
  }
}
