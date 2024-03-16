import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Sale extends StatefulWidget {
  const Sale({Key? key, required this.image_path});

  final List<String>? image_path;

  @override
  State<Sale> createState() => _SaleState();
}

class _SaleState extends State<Sale> {
  void initState() {
    super.initState();
    getSales();
  }

  final IP = '10.160.96.72';
  var sale_no = [];
  var sale_date = [];
  var user_name = [];
  var product_id = [];
  var sale_num = [];
  var sale_status = [];

  File? imagePath;
  String? imageName;
  String? imageData;

  ImagePicker imagePicker = new ImagePicker();

  void getSales() async {
    try {
      String url = "http://${IP}/appsale/getSales.php";
      var response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
        'Charset': 'utf-8'
      });

      if (response.statusCode == 200) {
        var rs = response.body.replaceAll('ï»¿', '');
        var product = convert.jsonDecode(rs);

        setState(() {});

        product.forEach((value) {
          sale_no.add(value['sale_no']);
          sale_date.add(value['sale_date']);
          user_name.add(value['user_name']);
          product_id.add(value['product_id']);
          sale_num.add(value['sale_num']);
          sale_status.add(value['sale_status']);
        });
      } else {
        print('Request failed with status: ${response.statusCode}.');
        throw Exception('Failed to load Data');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getImage() async {
    var getImage = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      imagePath = File(getImage!.path);
      imageName = getImage.path.split('/').last;
      imageData = base64Encode(imagePath!.readAsBytesSync());
    });
  }

  Future<void> uploadImage(String saleNo, String userName, String productId,
      String saleNum, String saleStatus) async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://10.160.96.72/appsale/imageUpload.php'));
      request.fields.addAll({
        'sale_no': '${saleNo}',
        'sale_status': 'ชำระเงินเสร็จสิ้น',
        'image_name': '${imageName}',
        'image_data': '${imageData}',
      });
      print("${imageName}----> ${imageData}------> ${imagePath}");

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('อัปโหลดสำเร็จ'),
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
        print(response.reasonPhrase);
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  void _showUploadDialog(String saleNo, String userName, String productId,
      String saleNum, String saleStatus, String saleDate) async {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Sale Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ชื่อ: $userName'),
              Text('รหัสสินค้า: $productId'),
              Text('จำนวน: $saleNum'),
              Text('สถานะการขาย: $saleStatus'),
              Text('วันที่ขาย: $saleDate'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  getImage();
                  // Implement file selection logic
                },
                child: Icon(Icons.add_a_photo),
              ),
              SizedBox(height: 20),
              Flexible(
                child: Center(
                  child: imagePath != null
                      ? Image.file(imagePath!)
                      : Text('No image selected'),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  uploadImage(saleNo, userName, productId, saleNum, saleStatus);
                });
                // Implement file upload logic
              },
              child: Text('Upload'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return sale_no.isEmpty
        ? Center(
            child: Text(
              'ไม่มีรายการสั่งซื้อ',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          )
        : ListView.builder(
            itemCount: sale_no.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 5, top: 10),
                child: InkWell(
                  onTap: () {
                    _showUploadDialog(
                      sale_no[index],
                      user_name[index],
                      product_id[index],
                      sale_num[index].toString(), // Convert to string
                      sale_status[index],
                      sale_date[index],
                    );
                  },
                  child: Card(
                    child: Row(
                      children: [
                        Container(
                          color: Colors.yellow,
                          padding: EdgeInsets.all(10),
                          child: Text('data_picture'),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Text('ชื่อ ${user_name[index]}'),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Text('รหัสสินค้า ${product_id[index]}'),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Text('x ${sale_num[index]}'),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Text('${sale_status[index]}'),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Text('${sale_date[index]}'),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            color: Colors.yellow,
                            padding: EdgeInsets.all(10),
                            child: Text('upload'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}
