// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// class DashboardPage extends StatefulWidget {
//   @override
//   _DashboardPageState createState() => _DashboardPageState();
// }
//
// class _DashboardPageState extends State<DashboardPage> {
//   @override
//
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Admin Dashboard'),
//         backgroundColor: Colors.teal,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('billing').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text('No billing data available.'));
//           }
//
//           final orders = snapshot.data!.docs;
//
//           return ListView.builder(
//             itemCount: orders.length,
//             itemBuilder: (context, index) {
//               final order = orders[index].data() as Map<String, dynamic>;
//               final orderId = orders[index].id;
//
//               return Card(
//                 elevation: 5,
//                 margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Order ID: ${order['orderId']}', style: TextStyle(
//                           fontWeight: FontWeight.bold, fontSize: 16)),
//                       Text(
//                           'User Email: ${order['userEmail']}', style: TextStyle(
//                           fontSize: 14)),
//                       Text('Total Amount: Rs. ${order['totalAmount']
//                           .toStringAsFixed(2)}', style: TextStyle(
//                           fontSize: 14)),
//                       Text('Order Status: ${order['status']}', style: TextStyle(
//                           fontWeight: FontWeight.bold, fontSize: 16)),
//                       SizedBox(height: 10),
//                       Text('Billing Method: ${order['billingMethod']}',
//                           style: TextStyle(fontSize: 14)),
//                       if (order['billingMethod'] == 'Cash on Delivery')
//                         Text('PIN: ${order['pin']}', style: TextStyle(
//                             fontSize: 14)),
//                       if (order['billingMethod'] == 'Easypaisa')
//                         Text('Easypaisa Account: ${order['easypaisaAccount']}',
//                             style: TextStyle(fontSize: 14)),
//                       if (order['billingMethod'] == 'JazzCash')
//                         Text('JazzCash Account: ${order['jazzcashAccount']}',
//                             style: TextStyle(fontSize: 14)),
//                       if (order['billingMethod'] == 'Credit Card' ||
//                           order['billingMethod'] == 'Debit Card')
//                         ...[
//                           Text('Card Number: ${order['cardNumber']}',
//                               style: TextStyle(fontSize: 14)),
//                           Text('Card Name: ${order['cardName']}',
//                               style: TextStyle(fontSize: 14)),
//                           Text('Card Expiration: ${order['cardExpiration']}',
//                               style: TextStyle(fontSize: 14)),
//                           Text('Card CVV: ${order['cardCVV']}',
//                               style: TextStyle(fontSize: 14)),
//                         ],
//                       if (order['billingMethod'] == 'HBL Account')
//                         ...[
//                           Text('HBL Account Number: ${order['hblAccount']}',
//                               style: TextStyle(fontSize: 14)),
//                           Text('CNIC Number: ${order['cnicNumber']}',
//                               style: TextStyle(fontSize: 14)),
//                         ],
//                       SizedBox(height: 10),
//                       Text('Address:', style: TextStyle(fontWeight: FontWeight
//                           .bold, fontSize: 16)),
//                       Text('Name: ${order['selectedAddress']['fullName']}',
//                           style: TextStyle(fontSize: 14)),
//                       Text('Email: ${order['selectedAddress']['email']}',
//                           style: TextStyle(fontSize: 14)),
//                       Text('Contact: ${order['selectedAddress']['mobile']}',
//                           style: TextStyle(fontSize: 14)),
//                       Text('Address: ${order['selectedAddress']['address']}',
//                           style: TextStyle(fontSize: 14)),
//                       Text('Area: ${order['selectedAddress']['area']}',
//                           style: TextStyle(fontSize: 14)),
//                       Text('City: ${order['selectedAddress']['city']}',
//                           style: TextStyle(fontSize: 14)),
//                       Text('Province: ${order['selectedAddress']['province']}',
//                           style: TextStyle(fontSize: 14)),
//                       SizedBox(height: 10),
//                       Text('Cart Items:', style: TextStyle(
//                           fontWeight: FontWeight.bold, fontSize: 16)),
//                       ...order['cartItems'].map<Widget>((item) {
//                         return Text(
//                             '${item['name']} - Quantity: ${item['quantity']} - Price: Rs. ${item['price']}',
//                             style: TextStyle(fontSize: 14));
//                       }).toList(),
//                       SizedBox(height: 10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           ElevatedButton(
//                             onPressed: () =>
//                                 _updateOrderStatus(orderId, 'Processed','${order['selectedAddress']['fullName']}', 'Your order has been placed successfully'),
//                             child: Text('Process Order'),
//                             style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.teal),
//                           ),
//                           ElevatedButton(
//                             onPressed: () =>
//                                 _updateOrderStatus(orderId, 'Rejected','${order['selectedAddress']['fullName']}', 'Your Order Has been rejected'),
//                             child: Text('Reject Order'),
//                             style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.red),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   Future<void> _updateOrderStatus(String orderId, String status, String name, String message) async {
//     // Update the order status in Firestore
//     await FirebaseFirestore.instance.collection('billing').doc(orderId).update(
//         {'status': status});
//     // Send an email notification to the user
//     await _sendNotification(orderId, status, name, message);
//   }
//
//
//   Future<void> _sendNotification(String orderId, String status, String name, String message) async {
//     final orderSnapshot = await FirebaseFirestore.instance.collection('billing')
//         .doc(orderId)
//         .get();
//     final orderData = orderSnapshot.data() as Map<String, dynamic>;
//     final userEmail = orderData['userEmail'] as String;
//     final totalAmount = orderData['totalAmount'].toStringAsFixed(2);
//     final billingMethod = orderData['billingMethod'];
//     final billingDetails = _getBillingDetails(orderData);
//
//     final response = await http.post(
//       Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Basic ' +
//             base64Encode(utf8.encode('your_emailjs_user_id:'))
//       },
//       body: jsonEncode({
//         'service_id': 'service_8db8d1c',
//         'template_id': 'template_ntejbq9',
//         'user_id': 'QN8ws9xhffWR1BdfJ',
//         'template_params': {
//           'to_email': userEmail,
//           'subject': 'Order Status Update',
//           'order_id': orderId,
//           'message': '$message. Order ID: $orderId ',
//           'from_name': name,
//           'total_amount': totalAmount,
//           'billing_method': billingMethod,
//           'billing_details': billingDetails,
//         },
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       print('Email sent successfully to $userEmail.');
//     } else {
//       print('Failed to send email: ${response.body}');
//     }
//   }
//
//   String _getBillingDetails(Map<String, dynamic> orderData) {
//     final billingMethod = orderData['billingMethod'];
//     String details = '';
//
//     switch (billingMethod) {
//       case 'Cash on Delivery':
//         details = 'PIN: ${orderData['pin']}';
//         break;
//       case 'Easypaisa':
//         details = 'Easypaisa Account: ${orderData['easypaisaAccount']}';
//         break;
//       case 'JazzCash':
//         details = 'JazzCash Account: ${orderData['jazzcashAccount']}';
//         break;
//       case 'Credit Card':
//       case 'Debit Card':
//         details = 'Card Number: ${orderData['cardNumber']}\n'
//             'Card Name: ${orderData['cardName']}\n'
//             'Card Expiration: ${orderData['cardExpiration']}\n'
//             'Card CVV: ${orderData['cardCVV']}';
//         break;
//       case 'HBL Account':
//         details = 'HBL Account Number: ${orderData['hblAccount']}\n'
//             'CNIC Number: ${orderData['cnicNumber']}';
//         break;
//       default:
//         details = 'No specific billing details available.';
//         break;
//     }
//
//     return details;
//   }
// }
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('billing').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No billing data available.'));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>;
              final orderId = orders[index].id;

              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order ID: ${order['orderId']}', style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(
                          'User Email: ${order['userEmail']}', style: TextStyle(
                          fontSize: 14)),
                      Text('Total Amount: Rs. ${order['totalAmount']
                          .toStringAsFixed(2)}', style: TextStyle(
                          fontSize: 14)),
                      Text('Order Status: ${order['status']}', style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 10),
                      Text('Billing Method: ${order['billingMethod']}',
                          style: TextStyle(fontSize: 14)),
                      _buildBillingDetails(order),
                      SizedBox(height: 10),
                      Text('Address:', style: TextStyle(fontWeight: FontWeight
                          .bold, fontSize: 16)),
                      Text('Name: ${order['selectedAddress']['fullName']}',
                          style: TextStyle(fontSize: 14)),
                      Text('Email: ${order['selectedAddress']['email']}',
                          style: TextStyle(fontSize: 14)),
                      Text('Contact: ${order['selectedAddress']['mobile']}',
                          style: TextStyle(fontSize: 14)),
                      Text('Address: ${order['selectedAddress']['address']}',
                          style: TextStyle(fontSize: 14)),
                      Text('Area: ${order['selectedAddress']['area']}',
                          style: TextStyle(fontSize: 14)),
                      Text('City: ${order['selectedAddress']['city']}',
                          style: TextStyle(fontSize: 14)),
                      Text('Province: ${order['selectedAddress']['province']}',
                          style: TextStyle(fontSize: 14)),
                      SizedBox(height: 10),
                      Text('Cart Items:', style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                      ...order['cartItems'].map<Widget>((item) {
                        return Text(
                            '${item['name']} - Quantity: ${item['quantity']} - Price: Rs. ${item['price']}',
                            style: TextStyle(fontSize: 14));
                      }).toList(),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () =>
                                _updateOrderStatus(orderId, 'Processed', order),
                            child: Text('Process Order'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal),
                          ),
                          ElevatedButton(
                            onPressed: () =>
                                _updateOrderStatus(orderId, 'Rejected', order),
                            child: Text('Reject Order'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBillingDetails(Map<String, dynamic> order) {
    final billingMethod = order['billingMethod'];
    switch (billingMethod) {
      case 'Cash on Delivery':
        return Text('PIN: ${order['pin']}', style: TextStyle(fontSize: 14));
      case 'Easypaisa':
        return Text('Easypaisa Account: ${order['easypaisaAccount']}',
            style: TextStyle(fontSize: 14));
      case 'JazzCash':
        return Text('JazzCash Account: ${order['jazzcashAccount']}',
            style: TextStyle(fontSize: 14));
      case 'Credit Card':
      case 'Debit Card':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Card Number: ${order['cardNumber']}', style: TextStyle(
                fontSize: 14)),
            Text('Card Name: ${order['cardName']}', style: TextStyle(
                fontSize: 14)),
            Text('Card Expiration: ${order['cardExpiration']}', style: TextStyle(
                fontSize: 14)),
            Text('Card CVV: ${order['cardCVV']}', style: TextStyle(fontSize: 14)),
          ],
        );
      case 'HBL Account':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('HBL Account Number: ${order['hblAccount']}', style: TextStyle(
                fontSize: 14)),
            Text('CNIC Number: ${order['cnicNumber']}', style: TextStyle(
                fontSize: 14)),
          ],
        );
      default:
        return Text('No specific billing details available.', style: TextStyle(
            fontSize: 14));
    }
  }

  Future<void> _updateOrderStatus(String orderId, String status, Map<String, dynamic> order) async {
    // Update the order status in Firestore
    await FirebaseFirestore.instance.collection('billing').doc(orderId).update(
        {'status': status});

    // Determine message based on status
    String message;
    if (status == 'Processed') {
      message = 'Your order has been placed Successfully';
    } else {
      message = 'Your order has been R  ejected';
    }

    // Send an email notification to the user
    await _sendNotification(orderId, status, order, message);
  }

  Future<void> _sendNotification(String orderId, String status, Map<String, dynamic> order, String message) async {
    final userEmail = order['userEmail'];
    final name = order['selectedAddress']['fullName'];
    final totalAmount = order['totalAmount'].toStringAsFixed(2);
    final billingMethod = order['billingMethod'];
    final billingDetails = _getBillingDetails(order);

    // Build cart items string
    String cartItems = order['cartItems'].map<String>((item) {
      return '${item['name']} - Quantity: ${item['quantity']} - Price: Rs. ${item['price']}';
    }).join('\n');

    final response = await http.post(
      Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic ' +
            base64Encode(utf8.encode('your_emailjs_user_id:'))
      },
      body: jsonEncode({
        'service_id': 'service_8db8d1c',
        'template_id': 'template_ntejbq9',
        'user_id': 'QN8ws9xhffWR1BdfJ',
        'template_params': {
          'to_email': userEmail,
          'subject': 'Order Status Update',
          'order_id': orderId,
          'message': '$message',
          'from_name': name,
          'total_amount': totalAmount,
          'billing_method': billingMethod,
          'billing_details': billingDetails,
          'cart_items': cartItems, // Include cart items in the template parameters
        },
      }),
    );

    if (response.statusCode == 200) {
      print('Email sent successfully to $userEmail.');
    } else {
      print('Failed to send email: ${response.body}');
    }
  }

  String _getBillingDetails(Map<String, dynamic> orderData) {
    final billingMethod = orderData['billingMethod'];
    String details = '';

    switch (billingMethod) {
      case 'Cash on Delivery':
        details = 'PIN: ${orderData['pin']}';
        break;
      case 'Easypaisa':
        details = 'Easypaisa Account: ${orderData['easypaisaAccount']}';
        break;
      case 'JazzCash':
        details = 'JazzCash Account: ${orderData['jazzcashAccount']}';
        break;
      case 'Credit Card':
      case 'Debit Card':
        details = 'Card Number: ${orderData['cardNumber']}\n'
            'Card Name: ${orderData['cardName']}\n'
            'Card Expiration: ${orderData['cardExpiration']}\n'
            'Card CVV: ${orderData['cardCVV']}';
        break;
      case 'HBL Account':
        details = 'HBL Account Number: ${orderData['hblAccount']}\n'
            'CNIC Number: ${orderData['cnicNumber']}';
        break;
      default:
        details = 'No specific billing details available.';
        break;
    }

    return details;
  }
}
