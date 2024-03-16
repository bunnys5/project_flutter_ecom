import 'package:appshop/shop.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderPage extends StatefulWidget {
  const OrderPage({super.key, required this.user_name, required this.product_id, required this.product_name, required this.image_path});

  final String user_name;
  final String product_id;
  final String product_name;
  final String image_path;

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

  TextEditingController sale_num = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.show_chart),
        title: Text('ป้อนจำนวนที่ต้องการซื้อ'),
        
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Image.network('${widget.image_path}', width: 100, height: 100,),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Text('รหัสสินค้า: ${widget.product_id} (${widget.product_name})')
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Text('รหัสสินค้า: ${widget.product_id} (${widget.product_name})')
            ),
            Container(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                  controller: sale_num,
                  decoration: InputDecoration(
                    labelText: 'ป้อนจำนวนสินค้า',
                    suffixIcon: Icon(Icons.people_alt),
                    // border: OutlineInputBorder(
                    //     borderSide: BorderSide(color: Colors.blue)),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10)),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      
                      //           Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => const MenuPage()),
                      // );
                    });
                  },
                  child: Text(
                    'ยืนยัน',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}