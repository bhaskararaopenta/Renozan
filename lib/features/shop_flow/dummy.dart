import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        color: Colors.purple,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '12',
                        style: TextStyle(color: Colors.purple),
                      ),
                    ],
                  ),
                ),
                Spacer(),
              ],
            ),
            SizedBox(height: 10),
            Center(
              child: Image.asset(
                'assets/images/product_image.png', // Your product image asset path
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Product 1',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              '\$50',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Row(
                    children: [
                      Icon(
                        Icons.remove_circle_outline,
                        color: Colors.purple,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '12',
                        style: TextStyle(color: Colors.purple),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.add_circle_outline,
                        color: Colors.purple,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.add_circle_outline, color: Colors.purple),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
