import 'package:flutter/material.dart';
import 'product_update_screen.dart';
import '../../services/product_service.dart';

class ProductViewScreen extends StatelessWidget {
  final Map productData;
  const ProductViewScreen({super.key, required this.productData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดสินค้า'),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
                width: double.infinity,
                child: Image.network(
                    ProductService().imageUrl + "/" + productData['image'])),
            SizedBox(
              height: 10,
            ),
            Text(productData['proname']),
            SizedBox(
              height: 10,
            ),
            Text(productData['price'].toString() + ' บาท'),
            SizedBox(
              height: 15,
            ),
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductUpdateScreen(
                              productData: productData,
                            )),
                  );
                },
                label: Text('แก้ไขข้อมูล'))
          ],
        ),
      ),
    );
  }
}
