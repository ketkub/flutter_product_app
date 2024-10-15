import 'package:flutter/material.dart';
import '../../services/product_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProductAddScreen extends StatefulWidget {
  @override
  _ProductAddScreenState createState() => _ProductAddScreenState();
}

class _ProductAddScreenState extends State<ProductAddScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _pronameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final ProductService _productService = ProductService();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มข้อมูลสินค้ามใหม่'),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                  height: 150,
                  child: _image != null
                      ? Image.file(_image!)
                      : Text('ยังไม่มีรูปภาพ')),
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
                decoration: InputDecoration(labelText: 'ชื่อสินค้าม'),
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'ราคา'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  if (_image != null) {
                    String proname = _pronameController.text;
                    double price = double.parse(_priceController.text);
                    // เรียกใช้งาน API เพื่อเพิ่มข้อมูลใหม่
                    final upload = await _productService.createProduct(
                        _image!, proname, price);
                    // ตรวจสอบการตอบกลับจาก API
                    if (upload != null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('สำเร็จ'),
                      ));
                      // ส่งค่ากลับไปที่ ProductListScreen
                      Navigator.pop(context, true);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('ผิดพลาด'),
                      ));
                    }
                  }
                },
                label: Text('บันทึกข้อมูล'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
