import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Add_Sujjestion_Data extends StatefulWidget {
  const Add_Sujjestion_Data({super.key});

  @override
  State<Add_Sujjestion_Data> createState() => _Add_Sujjestion_DataState();
}

class _Add_Sujjestion_DataState extends State<Add_Sujjestion_Data> {
  final TextEditingController title = TextEditingController();
  final TextEditingController image = TextEditingController();
  final TextEditingController price = TextEditingController();
  final Uuid uuid = Uuid();

  String? selectedBrand;
  String? selectedCategory;

  List<String> brands = [];
  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    fetchBrands();
    fetchCategories();
  }

  Future<void> fetchBrands() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Brand_Category').get();
    List<String> fetchedBrands = snapshot.docs.map((doc) => doc['brand'] as String).toList();
    setState(() {
      brands = fetchedBrands;
      selectedBrand = null; // Ensure it's null initially
    });
  }

  Future<void> fetchCategories() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Brand_Category').get();
    List<String> fetchedCategories = snapshot.docs.map((doc) => doc['category'] as String).toList();
    setState(() {
      categories = fetchedCategories;
      selectedCategory = null; // Ensure it's null initially
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10,),
            SizedBox(
              width: 400,
              child: TextFormField(
                controller: title,
                decoration: const InputDecoration(
                  hintText: "Title",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            SizedBox(
              width: 400,
              child: TextFormField(
                controller: price,
                decoration: const InputDecoration(
                  hintText: "Price",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            SizedBox(
              width: 400,
              child: TextFormField(
                controller: image,
                decoration: const InputDecoration(
                  hintText: "Image",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            SizedBox(
              width: 400,
              child: DropdownButtonFormField<String>(
                value: selectedBrand,
                items: brands.map((String brand) {
                  return DropdownMenuItem<String>(
                    value: brand,
                    child: Text(brand),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedBrand = newValue;
                  });
                },
                decoration: const InputDecoration(
                  hintText: "Brand",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            SizedBox(
              width: 400,
              child: DropdownButtonFormField<String>(
                value: selectedCategory,
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                },
                decoration: const InputDecoration(
                  hintText: "Category",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () async {
                try {
                  String id = uuid.v4();
                  await FirebaseFirestore.instance.collection("Sujjestion-Product").doc(id).set({
                    "id": id,
                    "title": title.text,
                    "image": image.text,
                    "price": price.text,
                    "brand": selectedBrand,
                    "category": selectedCategory,
                  });


                  Navigator.pop(context);
                } catch (ex) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ex.toString())),
                  );
                }
              },
              child: const Text("Add Data"),
            ),
          ],
        ),
      ),
    );
  }
}
