// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// class AddBrand extends StatefulWidget {
//   const AddBrand({super.key});
//
//   @override
//   State<AddBrand> createState() => _AddBrandState();
// }
//
// class _AddBrandState extends State<AddBrand> {
//   final TextEditingController brand = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//
//             // const SizedBox(height: 10,),
//             //
//             // SizedBox(
//             //   width: 200,
//             //   child: TextFormField(
//             //     controller: title,
//             //     decoration: const InputDecoration(
//             //         hintText: "Title",
//             //         border: OutlineInputBorder()
//             //     ),
//             //   ),
//             // ),
//             //
//             // const SizedBox(height: 10,),
//             //
//             // SizedBox(
//             //   width: 200,
//             //   child: TextFormField(
//             //     controller: price,
//             //     decoration: const InputDecoration(
//             //         hintText: "Price",
//             //         border: OutlineInputBorder()
//             //     ),
//             //   ),
//             // ),
//             const SizedBox(height: 10,),
//
//             SizedBox(
//               width: 200,
//               child: TextFormField(
//                 controller: brand,
//                 decoration: const InputDecoration(
//                     hintText: "brand",
//                     border: OutlineInputBorder()
//                 ),
//               ),
//             ),
//             // const SizedBox(height: 10,),
//             //
//             // SizedBox(
//             //   width: 200,
//             //   child: TextFormField(
//             //     controller: category,
//             //     decoration: const InputDecoration(
//             //         hintText: "category",
//             //         border: OutlineInputBorder()
//             //     ),
//             //   ),
//             // ),
//             // const SizedBox(height: 10,),
//             //
//             // SizedBox(
//             //   width: 200,
//             //   child: TextFormField(
//             //     controller: image,
//             //     decoration: const InputDecoration(
//             //         hintText: "Image",
//             //         border: OutlineInputBorder()
//             //     ),
//             //   ),
//             // ),
//
//             const SizedBox(height: 10,),
//
//             ElevatedButton(onPressed: ()async{
//               try{
//                 await FirebaseFirestore.instance.collection("Brand").add({
//                   // "title" : title.text,
//                   // "image" : image.text,
//                   // "price" : price.text,
//                   "brand" : brand.text,
//                   // "category" : category.text
//                 });
//                 Navigator.pop(context);
//               }catch (ex){
//                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ex.toString())));
//               }
//             }, child: const Text("Add Data"))
//
//           ],
//         ),
//       ),
//     );
//   }
// }
//
