// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
//
// class PopUpModel{
//
//   final String? billingID;
//   final String? status;
//   final String? isShown;
//
//  PopUpModel({this.billingID, this.status, this.isShown});
// }
//
//
// class PopUpController{
//   static Stream<List<PopUpModel>> getPopup(BuildContext context){
//     return FirebaseFirestore.instance.collection("billing").snapshots().map((snapshot) {
//       return snapshot.docs.map((doc) {
//         Map<String, dynamic> data = doc.data();
//         return PopUpModel(
//             billingID: data['billingID'],
//             status: data['status'],
//             isShown: data['isShown']
//         );
//       }).where((element) {
//        if(element.status == "0"){
//          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Order Proceded")));
//         } else{
//          return -;
//        }
//       }).toList();
//     });
//   }
//
//   void updateStatus(PopUpModel model)async{
//     await FirebaseFirestore.instance.collection("billing").doc(model.billingID).update({
//       "isShown" : "1",
//     });
//   }
// }