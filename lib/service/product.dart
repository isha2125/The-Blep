import 'package:cloud_firestore/cloud_firestore.dart';

class ProductProvider {
  static List<String> productIds = [];

  static Future<void> fetchProductIds() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Products').get();
    productIds = snapshot.docs.map((doc) => doc.id).toList();
  }
}
