import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final TextEditingController category = TextEditingController();
  final TextEditingController brand = TextEditingController();
  final Uuid uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10,),

            SizedBox(
              width: 200,
              child: TextFormField(
                controller: category,
                decoration: const InputDecoration(
                    hintText: "Category",
                    border: OutlineInputBorder()
                ),
              ),
            ),
            const SizedBox(height: 10,),

            SizedBox(
              width: 200,
              child: TextFormField(
                controller: brand,
                decoration: const InputDecoration(
                    hintText: "Brand",
                    border: OutlineInputBorder()
                ),
              ),
            ),
            const SizedBox(height: 10,),

            ElevatedButton(onPressed: () async {
              try {
                String id = uuid.v4();
                await FirebaseFirestore.instance.collection("Brand_Category").doc(id).set({
                  "id": id,
                  "category" : category.text,
                  "brand" : brand.text
                });


              } catch (ex) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ex.toString())));
              }
            }, child: const Text("Add Data"))

          ],
        ),
      ),
    );
  }
}
