import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FetchOrders extends StatefulWidget {
  const FetchOrders({super.key});

  @override
  State<FetchOrders> createState() => _FetchOrdersState();
}

class _FetchOrdersState extends State<FetchOrders> {
  String? userId;

  String order = "pending";
  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userEmail');
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              GestureDetector(
                onTap: (){
                  setState(() {
                    order = "pending";
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(5.0),
                  child: Text("Pending"),
                ),
              ),

                GestureDetector(
                  onTap: (){
                    setState(() {
                      order = "Processed";
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(5.0),
                    child: Text("Completed"),
                  ),
                ),
              ],
            ),
          ),

          StreamBuilder(
              stream: FirebaseFirestore.instance.collection("billing").where('userEmail',isEqualTo: userId).snapshots(),
              builder: (BuildContext context,  snapshot) {
                if (snapshot.hasData) {
                  var dataLength = snapshot.data!.docs.length;
                  return ListView.builder(
                    itemCount: dataLength,
                    itemBuilder: (context, index) {
                      String orderStatus = snapshot.data!.docs[index]['status'];
                      String orderEmail = snapshot.data!.docs[index]['userEmail'];
                      String orderAmount = snapshot.data!.docs[index]['totalAmount'];
                    return orderStatus == order ? ListTile(
                      title: Text(orderEmail),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(orderAmount),
                          Text(orderStatus),
                        ],
                      ),
                    ): Container();
                  },);
                } else if (snapshot.hasError) {
                  return const Icon(Icons.error_outline);
                } else {
                  return const CircularProgressIndicator();
                }
              }),
        ],
      ),
    );
  }
}
