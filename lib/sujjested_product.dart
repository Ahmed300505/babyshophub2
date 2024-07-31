import 'package:babyshophub/productDetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SujjestedProductCard extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String name;
  final String price;
  final String category;
  final double rating; // Rating property to reflect the product's customer feedback

  final Function() onAddToCart; // Callback function to update cart count

  const SujjestedProductCard({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.price,
    this.rating = 4.0, // Default rating when not specified
    required this.onAddToCart, // Pass this function as parameter
    Key? key, required this.category,
  }) : super(key: key);

  Future<void> addToCart(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('userEmail');
    if (userEmail == null) {
      // Handle case where user email is not set
      return;
    }

    final cartCollection = FirebaseFirestore.instance.collection('cart');
    final cartItem = await cartCollection
        .where('userEmail', isEqualTo: userEmail)
        .where('productId', isEqualTo: id)
        .get();

    if (cartItem.docs.isNotEmpty) {
      final doc = cartItem.docs.first;
      await cartCollection.doc(doc.id).update({
        'quantity': doc['quantity'] + 1,
      });
    } else {
      await cartCollection.add({
        'userEmail': userEmail,
        'productId': id,
        'imageUrl': imageUrl,
        'name': name,
        'price': price,
        'quantity': 1,
      });
    }

    // Show Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added $name to cart'),
        backgroundColor: Colors.purple,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.fixed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );

    // Call the function to update cart count in the parent widget
    onAddToCart();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.45; // Responsive card width

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(
              id: id,
              imageUrl: imageUrl,
              name: name,
              price: price,
              rating: rating, description: '',
              category: category,
            ),
          ),
        );
      },
      child: Container(
        width: cardWidth,
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Card(
          elevation: 5.0, // Slightly reduced for a cleaner look
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Smoother radius
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                    child: Image.network(
                      imageUrl,
                      width: double.infinity,
                      height: cardWidth * 0.65, // Keeping a balanced image height
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(Icons.favorite_border, color: Colors.redAccent, size: 24.0), // Simplified interaction
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        '20% OFF',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      'Rs. $price',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    RatingBar.builder(
                      initialRating: rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 16.0, // Smaller stars for less screen space usage
                      itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {},
                    ),
                    SizedBox(height: 15.0),
                    ElevatedButton.icon(
                      onPressed: () => addToCart(context),
                      icon: Icon(Icons.shopping_cart, color: Colors.white),
                      label: Text('', style: TextStyle(color: Colors.white, fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        minimumSize: Size(double.infinity, 40), // Smaller button for aesthetic balance
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
