import 'package:babyshophub/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'PrdouctCard.dart';
import 'cart.dart';
import 'login.dart';

class Product_Page extends StatefulWidget {
  const Product_Page({super.key});

  @override
  State<Product_Page> createState() => _Product_PageState();
}

class _Product_PageState extends State<Product_Page> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  final CarouselController _carouselController = CarouselController();

  bool _isExpanded = false;
  int currentIndex = 0;
  int cartCount = 0;

  List<String> _images = [
    'https://babyplanet.pk/cdn/shop/files/01-hb150724.jpg?v=1721049866&width=2000',
    'https://babyplanet.pk/cdn/shop/files/05-hb150724.jpg?v=1721049866&width=2000',
    'https://babyplanet.pk/cdn/shop/files/07-hb150724.jpg?v=1721049866&width=2000',
    'https://babyplanet.pk/cdn/shop/files/03-hb150724.jpg?v=1721049866&width=2000',
  ];

  List<Map<String, dynamic>> products = [];
  List<String> brands = [];
  String? selectedBrand;

  @override
  void initState() {
    super.initState();
    fetchProducts();
    fetchBrands();
    // PopUpController.getPopup();
    _searchController.addListener(() {
      fetchProducts();
    });
    fetchCartCount();
  }

  Future<void> fetchProducts() async {
    Query query = FirebaseFirestore.instance.collection('product');

    // Filter by brand if selectedBrand is not null and not "All"
    if (selectedBrand != null && selectedBrand != "All") {
      query = query.where('brand', isEqualTo: selectedBrand);
    }

    // Filter by search query if it is not empty
    if (_searchController.text.isNotEmpty) {
      query = query.where('title', isGreaterThanOrEqualTo: _searchController.text).where('title', isLessThanOrEqualTo: _searchController.text + '\uf8ff');
    }

    final QuerySnapshot productSnapshot = await query.get();
    setState(() {
      products = productSnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'imageUrl': doc['image'],
          'name': doc['title'],
          'price': doc['price'],
          'description':doc['description']
        };
      }).toList();
    });
  }

  Future<void> fetchCartCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('userEmail');
    if (userEmail == null) return;

    final cartSnapshot = await FirebaseFirestore.instance
        .collection('cart')
        .where('userEmail', isEqualTo: userEmail)
        .get();

    setState(() {
      cartCount = cartSnapshot.docs.length;
    });
  }

  Future<void> fetchBrands() async {
    final QuerySnapshot brandSnapshot = await FirebaseFirestore.instance.collection('Brand_Category').get();
    setState(() {
      brands = brandSnapshot.docs.map((doc) => doc['brand'] as String).toList();
    });
  }

  void pageShifter(int index) {
    setState(() {
      currentIndex = index;
    });
    // You can navigate to other pages based on the index
    if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
    }
  }

  void updateCartCount() {
    fetchCartCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Center(
          child: Text(
              "Baby"
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.purple),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.purple),
            onPressed: () {
              logout(context);
            },
          ),
        ],
      ),
      drawer: DrawerScreen(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: _images.map((image) {
                return Builder(
                  builder: (BuildContext context) {
                    return Image.network(
                      image,
                      fit: BoxFit.fill,
                      width: 500,
                      height: 180,
                    );
                  },
                );
              }).toList(),
              carouselController: _carouselController,
              options: CarouselOptions(
                viewportFraction: 1.0,
                autoPlay: true,
                scrollPhysics: const ScrollPhysics(),
                height: 180,
                autoPlayInterval: const Duration(seconds: 3),
                scrollDirection: Axis.vertical,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: brands.length + 1, // Adding 1 for the "All" tab
                itemBuilder: (context, index) {
                  final brand = index == 0 ? "All" : brands[index - 1];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedBrand = brand;
                        fetchProducts(); // Re-fetch products with the selected brand
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: selectedBrand == brand ? Colors.purpleAccent : Colors.purple,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Center(
                        child: Text(
                          brand,
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: Text("Food Product", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(1.0, 0.0),
                    end: Offset(0.0, 0.0),
                  ).animate(animation),
                  child: child,
                );
              },
              child: GridView.builder(
                key: ValueKey<int>(products.length),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 180 / 300),
                itemCount: products.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(
                    id: product['id'],
                    imageUrl: product['imageUrl'],
                    name: product['name'],
                    price: product['price'],
                    description: product['description'],
                    onAddToCart: updateCartCount,
                    category:'',
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.purple,
        unselectedLabelStyle: TextStyle(color: Colors.purple),
        showUnselectedLabels: true,
        currentIndex: currentIndex,
        onTap: pageShifter,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Product"),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(Icons.shopping_cart),
                if (cartCount > 0)
                  Positioned(
                    right: 0,
                    top: -3,
                    child: Container(
                      padding: EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        maxWidth: 15,
                        maxHeight: 20,
                      ),
                      child: Center(
                        child: Text(
                          '$cartCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            label: "Cart",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        ],
      ),
    );
  }

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
