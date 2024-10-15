import 'package:flutter/material.dart';
import 'product_list_screen.dart'; // นำเข้า ProductListScreen

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('หน้าแรก'),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // รูปภาพจาก URL
            Image.network(
              'https://lh3.googleusercontent.com/a/ACg8ocLU1PYyZEBmzxg94g3YKfAjgMy90gwijJ1JC418_-PItQTKW04=s288-c-no', // เปลี่ยนเป็น URL ของรูปที่คุณต้องการ
              width: 150, // กำหนดความกว้างของรูป
              height: 150, // กำหนดความสูงของรูป
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null)
                  return child; // หากโหลดเสร็จแล้วให้แสดงรูป
                return Center(
                  child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null),
                );
              },
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                return const Text('ไม่สามารถโหลดรูปภาพ');
              },
            ),
            const SizedBox(height: 20), // เว้นระยะห่างระหว่างรูปภาพและข้อความ
            const Text(
              'กฤษดา สวาศรี 64010914607',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20), // เว้นระยะห่าง
            ElevatedButton(
              onPressed: () {
                // คลิกแล้วไปที่หน้ารายการสินค้า
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProductListScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('ไปที่รายการสินค้า'),
            ),
          ],
        ),
      ),
    );
  }
}
