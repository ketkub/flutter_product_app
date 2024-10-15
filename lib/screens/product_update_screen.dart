import 'package:flutter/material.dart';
import 'product_list_screen.dart';
import '../../services/product_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProductUpdateScreen extends StatefulWidget {
  final Map productData;
  const ProductUpdateScreen({super.key, required this.productData});

  @override
  State<ProductUpdateScreen> createState() => _ProductUpdateScreenState();
}

class _ProductUpdateScreenState extends State<ProductUpdateScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _pronameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final ProductService _productService = ProductService();

  Future<void> _pickImage(ImageSource source) async {
    // ประกาศตัวแปร pickedFile สำหรับจัดเก็บไฟล์รูปภาพที่เลือก
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        // กำหนดให้ตัวแปร _image เก็บข้อมูลไฟล์รูปภาพที่อยู่ในตัวแปร pickedFile
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // ตั้งค่าข้อมูลเริ่มต้นสำหรับ TextField
    _pronameController.text = widget.productData['proname'];
    _priceController.text = widget.productData['price'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขข้อมูลสินค้า'),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // แสดงรูปภาพที่เลือก
              SizedBox(
                height: 150,
                child: _image != null
                    ? Image.file(_image!)
                    : Image.network(
                        ProductService().imageUrl +
                            "/" +
                            widget.productData['image'],
                      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.camera),
                    child: Text('ถ่ายรูป'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    child: Text('เลือกรูปจากแกลเลอรี'),
                  ),
                ],
              ),
              TextField(
                controller: _pronameController,
                decoration: InputDecoration(labelText: 'ชื่อสินค้า'),
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'ราคา'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  String proname = _pronameController.text;
                  double? price = double.tryParse(_priceController.text);

                  if (price == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red,
                      content: Text('กรุณากรอกราคาที่เป็นตัวเลข'),
                    ));
                    return;
                  }

                  // ตรวจสอบว่า _image มีค่าหรือไม่ ถ้าไม่มีให้ใช้รูปภาพเดิมจาก widget.productData['image']
                  final upload = await _productService.updateProduct(
                    widget.productData['proId'],
                    _image ?? File(widget.productData['image']),
                    proname,
                    price,
                  );

                  if (upload != null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('แก้ไขข้อมูลสำเร็จ'),
                    ));
                    // กลับไปยังหน้าแสดงรายการสินค้า
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => ProductListScreen()),
                      (Route<dynamic> route) => false,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red,
                      content: Text('การแก้ไขข้อมูลล้มเหลว'),
                    ));
                  }
                },
                icon: Icon(Icons.save),
                label: Text('แก้ไขข้อมูล'),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  // ยืนยันการลบ
                  final confirmDelete = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('ยืนยันการลบ'),
                      content: Text('คุณต้องการลบสินค้านี้หรือไม่?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('ยกเลิก'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text('ยืนยัน'),
                        ),
                      ],
                    ),
                  );

                  if (confirmDelete == true) {
                    // เรียกใช้เมธอดลบจาก ProductService
                    final result = await _productService
                        .deleteProduct(widget.productData['proId']);
                    if (result) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('ลบสินค้าสำเร็จ'),
                      ));
                      // กลับไปยังหน้ารายการสินค้า
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => ProductListScreen()),
                        (Route<dynamic> route) => false,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('การลบล้มเหลว'),
                      ));
                    }
                  }
                },
                icon: Icon(Icons.delete),
                label: Text('ลบข้อมูล'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
