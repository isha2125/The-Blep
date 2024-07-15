import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/product_card.dart';
import 'search_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> productIds = [];
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    fetchProductIds();
  }

  Future<void> fetchProductIds() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Products').get();
      productIds = querySnapshot.docs.map((doc) => doc.id).toList();
      print('Fetched product IDs: $productIds');
      setState(() {
        isLoading = false;
        isError = false;
      });
    } catch (e) {
      print('Error fetching product IDs: $e');
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Myntra', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : isError
              ? Center(child: Text('Failed to load products'))
              : ListView(
                  children: [
                    SearchBar(),
                    CategoryButtons(),
                    PromotionalBanner(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'WESTERN WEAR',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ProductGrid(productIds: productIds),
                  ],
                ),
    );
  }
}

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchScreen()),
          );
        },
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search for products, brands and more',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
          enabled: false,
        ),
      ),
    );
  }
}

class CategoryButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            CategoryButton(label: 'Fashion'),
            CategoryButton(label: 'Beauty'),
            CategoryButton(label: 'Home'),
            CategoryButton(label: 'Rakhi Gifting'),
            CategoryButton(label: 'Men'),
            CategoryButton(label: 'Women'),
            CategoryButton(label: 'Kids'),
            CategoryButton(label: 'Accessories'),
          ],
        ),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String label;

  CategoryButton({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[200],
          foregroundColor: Colors.black,
        ),
        onPressed: () {},
        child: Text(label),
      ),
    );
  }
}

class PromotionalBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/sale_banner.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'SUPER SAVER SALE\n50-80% OFF\nDeals Too Good To Miss',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class ProductGrid extends StatelessWidget {
  final List<String> productIds;

  ProductGrid({required this.productIds});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics:
          NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
      shrinkWrap: true, // Ensure GridView takes up only necessary space
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
      ),
      itemCount: productIds.length,
      itemBuilder: (context, index) {
        return ProductCard(productId: productIds[index]);
      },
    );
  }
}
