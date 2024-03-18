import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:appshop/order.dart';
import 'package:appshop/services/auth_service.dart';

class Product extends StatefulWidget {
  final String user_name;

  const Product({Key? key, required this.user_name}) : super(key: key);

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  final IP = '10.160.96.72'; // Your IP address

  List<String> product_id = [];
  List<String> product_name = [];
  List<String> product_price = [];
  List<String> image_path = [];

  @override
  void initState() {
    super.initState();
    getProduct();
  }

  void getProduct() async {
    try {
      String url = "http://${IP}/appsale/getProduct.php";
      var response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
        'Charset': 'utf-8'
      });
      if (response.statusCode == 200) {
        var rs = response.body.replaceAll('ï»¿', '');
        var product = convert.jsonDecode(rs);

        setState(() {
          product.forEach((value) {
            product_id.add(value['product_id']);
            product_name.add(value['product_name']);
            product_price.add(value['product_price']);
            image_path.add(value['image_path']);
          });
        });
      } else {
        throw Exception('Failed to load Data');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<bool>(
        stream: authService.authState,
        initialData: authService.isAuthenticated,
        builder: (context, snapshot) {
          final isAuthenticated = snapshot.data ?? false;
          return CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          'Find the best food and drink for you',
                          style: GoogleFonts.bebasNeue(fontSize: 46),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Find your foods or drinks',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade600),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade600),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                  ],
                ),
              ),
              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 2),
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Card(
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderPage(
                                user_name: widget.user_name,
                                product_id: product_id[index],
                                product_name: product_name[index],
                                image_path: image_path[index],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black54,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    'http://${IP}/appsale/images/${image_path[index].toString()}',
                                  ),
                                ),
                                Text(
                                  product_name[index].toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  'ราคา ${product_price[index].toString()} บาท',
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: product_id.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
