import 'package:flutter/material.dart';
import 'product_add_screen.dart';
import 'product_view_screen.dart';
import '../../services/product_service.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<dynamic>> futureProduct;

  @override
  void initState() {
    super.initState();
    futureProduct = _fetchProducts();
  }

  Future<List<dynamic>> _fetchProducts() async {
    return await ProductService().fetchProducts();
  }

  void _refreshProducts() {
    setState(() {
      futureProduct = _fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการข้อมูลสินค้า'),
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<List<dynamic>>(
          future: futureProduct,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('ไม่พบรายการข้อมูลสินค้า'));
            } else {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(snapshot.data![index]['proname']),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductViewScreen(
                                      productData: snapshot.data![index],
                                    )),
                          );
                        },
                      ),
                    );
                  });
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to the add product screen and wait for a result
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductAddScreen()),
          );

          // If result is true, refresh the product list
          if (result == true) {
            _refreshProducts();
          }
        },
        tooltip: 'เพิ่มข้อมูลสินค้าใหม่',
        child: const Icon(Icons.add),
      ),
    );
  }
}
