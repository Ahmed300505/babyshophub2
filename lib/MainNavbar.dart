import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainNavbar(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class MainNavbar extends StatefulWidget {
  const MainNavbar({Key? key}) : super(key: key);

  @override
  State<MainNavbar> createState() => _MainNavbarState();
}

class _MainNavbarState extends State<MainNavbar> {
  int currentIndex = 0;

  void pageShifter(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  final List<Widget> myScreens = [
    MyHomePage(),
    // Add other screens here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: myScreens[currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          iconSize: 24,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          currentIndex: currentIndex,
          onTap: pageShifter,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.chair_outlined), label: "Product"),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Profile"),
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> selectedCategories = [];
  List<String> selectedBrands = [];
  String searchQuery = '';

  PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Baby Shop Hub'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_basket_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_sharp),
            onPressed: () {},
          ),
        ],
      ),
      drawer: screenWidth <= 600
          ? Drawer(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  hintText: 'Search furniture',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text(
                "Categories",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 21,
                  fontFamily: 'Arial',
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('Category').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var categories = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          String category = categories[index]['category'];
                          bool isSelected = selectedCategories.contains(category);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: CheckboxListTile(
                              title: Text(category),
                              value: isSelected,
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    selectedCategories.add(category);
                                  } else {
                                    selectedCategories.remove(category);
                                  }
                                });
                              },
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Error loading categories'));
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Brands",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 21,
                  fontFamily: 'Arial',
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('Brand').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var brands = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: brands.length,
                        itemBuilder: (context, index) {
                          String brand = brands[index]['brand'];
                          bool isSelected = selectedBrands.contains(brand);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: CheckboxListTile(
                              title: Text(brand),
                              value: isSelected,
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    selectedBrands.add(brand);
                                  } else {
                                    selectedBrands.remove(brand);
                                  }
                                });
                              },
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Error loading Brands'));
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      )
          : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Section
          if (screenWidth > 600)
            Container(
              width: screenWidth * 0.25,
              padding: const EdgeInsets.all(16.0),
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      hintText: 'Search furniture',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Categories",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 21,
                      fontFamily: 'Arial',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('Category').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var categories = snapshot.data!.docs;
                          return ListView.builder(
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              String category = categories[index]['category'];
                              bool isSelected = selectedCategories.contains(category);
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: CheckboxListTile(
                                  title: Text(category),
                                  value: isSelected,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        selectedCategories.add(category);
                                      } else {
                                        selectedCategories.remove(category);
                                      }
                                    });
                                  },
                                ),
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return const Center(child: Text('Error loading categories'));
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Brands",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 21,
                      fontFamily: 'Arial',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('Brand').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var brands = snapshot.data!.docs;
                          return ListView.builder(
                            itemCount: brands.length,
                            itemBuilder: (context, index) {
                              String brand = brands[index]['brand'];
                              bool isSelected = selectedBrands.contains(brand);
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: CheckboxListTile(
                                  title: Text(brand),
                                  value: isSelected,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        selectedBrands.add(brand);
                                      } else {
                                        selectedBrands.remove(brand);
                                      }
                                    });
                                  },
                                ),
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return const Center(child: Text('Error loading Brands'));
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
          // Product Cards Section
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,
                      child: PageView(
                        controller: _pageController,
                        children: [
                          Image.network(
                              'data:image/jpeg;base64,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', fit: BoxFit.cover),
                          Image.network(
                              'data:image/jpeg;base64,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', fit: BoxFit.cover),
                          Image.network(
                              'data:image/jpeg;base64,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', fit: BoxFit.cover),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                      child: Center(
                        child: SmoothPageIndicator(
                          controller: _pageController,
                          count: 3,
                          effect: ExpandingDotsEffect(
                            dotHeight: 8,
                            dotWidth: 8,
                            activeDotColor: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    StreamBuilder(
                      stream: getFilteredProducts(),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.hasData) {
                          var dataLength = snapshot.data!.docs.length;
                          if (dataLength == 0) {
                            return Center(child: Text("No products found"));
                          }
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: screenWidth > 600 ? 3 : 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: dataLength,
                            itemBuilder: (context, index) {
                              String title = snapshot.data!.docs[index]["title"];
                              String image = snapshot.data!.docs[index]["image"];
                              String price = snapshot.data!.docs[index]["price"];

                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: GestureDetector(
                                  onDoubleTap: () async {
                                    await FirebaseFirestore.instance.collection("Cart").add({
                                      "title": title,
                                      "image": image,
                                      "price": price,
                                    });
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    elevation: 5,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                          ),
                                          child: Image.network(
                                            image,
                                            height: 100,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                title,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                '\$$price',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                await FirebaseFirestore.instance.collection("Cart").add({
                                                  "title": title,
                                                  "image": image,
                                                  "price": price,
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: Text(
                                                'Add to Cart',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return const Icon(Icons.error_outline);
                        } else if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot> getFilteredProducts() {
    Query collection = FirebaseFirestore.instance.collection("product");

    if (searchQuery.isNotEmpty) {
      collection = collection
          .where("title", isGreaterThanOrEqualTo: searchQuery)
          .where("title", isLessThanOrEqualTo: searchQuery + '\uf8ff');
    }

    if (selectedCategories.isNotEmpty && selectedBrands.isNotEmpty) {
      collection = collection
          .where("category", whereIn: selectedCategories)
          .where("brand", whereIn: selectedBrands);
    } else if (selectedCategories.isNotEmpty) {
      collection = collection.where("category", whereIn: selectedCategories);
    } else if (selectedBrands.isNotEmpty) {
      collection = collection.where("brand", whereIn: selectedBrands);
    }

    return collection.snapshots();
  }
}

class StackItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;

  const StackItem({
    required this.imageUrl,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 180, // Adjust as needed for your design
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.favorite_border, color: Colors.red),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.add_shopping_cart, color: Colors.black),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
