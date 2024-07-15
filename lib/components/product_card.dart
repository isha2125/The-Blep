import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductCard extends StatelessWidget {
  final String productId;

  ProductCard({required this.productId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('Products')
          .doc(productId)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.hasError) {
          return Center(child: Text('Error loading product'));
        }

        var product = snapshot.data!.data() as Map<String, dynamic>;

        return Card(
          margin: EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(4.0)),
                  child: Image.network(
                    product['imageURL'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 123, // Fixed height for the image container
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 8, 5, 0),
                  child: Text(
                    product['name'],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                  child: Text(
                    product['desc'],
                    maxLines: 2, // Adjust the number of lines as needed
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                  child: Text(
                    '₹${product['price']}',
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
