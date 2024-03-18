import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'screens/product.dart';

class OrderPage extends StatefulWidget {
  const OrderPage(
      {super.key,
      required this.user_name,
      required this.product_id,
      required this.product_name,
      required this.image_path});

  final String user_name;
  final String product_id;
  final String product_name;
  final String image_path;

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  TextEditingController sale_num = TextEditingController();

  var sale = '';

  //final IP = '10.160.152.66';
  final IP = '10.160.96.72';

  void insertOrder(String user_name, String product_id, String sale_num) async {
    try {
      String url =
          "http://${IP}/appsale/insertOrder.php?user_name=${user_name}&product_id=${product_id}&sale_num=${sale_num}";

      print(url);
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://10.160.96.72/appsale/insertOrder.php'));
      request.fields.addAll({
        'user_name': '${user_name}',
        'product_id': '${product_id}',
        'sale_num': '${sale_num}',
        'status': 'รอการชำระเงิน'
      });

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // Show alert for successful order
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('สั่งซื้อสำเร็จ'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('สั่งซื้อไม่สำเร็จ'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e);
    }
  } //getProduct

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.show_chart),
        title: Text('ป้อนจำนวนที่ต้องการซื้อ'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Text('ชื่อผู้ใช้งาน ${widget.user_name}'),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Image.network(
              'http://${IP}/appsale/images/${widget.image_path.toString()}',
              height: 50,
              width: 50,
            ),
          ),
          Container(
              padding: EdgeInsets.all(20),
              child: Text(
                  'รหัสสินค้า: ${widget.product_id} (${widget.product_name})')),
          Container(
            padding: EdgeInsets.all(20),
            child: TextField(
              controller: sale_num,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'ป้อนจำนวนสินค้า',
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    insertOrder(
                        widget.user_name, widget.product_id, sale_num.text);
                    Navigator.of(context).pop();
                  });
                },
                child: Text(
                  'ยืนยัน',
                  style: TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(backgroundColor: Colors.blue),
              )),
        ],
      ),
    );
  }
}
