import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class BillingPage extends StatefulWidget {
  final String userEmail;
  final double totalAmount;
  final List<DocumentSnapshot> cartItems;

  const BillingPage({super.key,
    required this.userEmail,
    required this.totalAmount,
    required this.cartItems,
  });

  @override
  _BillingPageState createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  String? selectedBillingMethod;
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardNameController = TextEditingController();
  final TextEditingController _cardExpirationController = TextEditingController();
  final TextEditingController _cardCVVController = TextEditingController();
  final TextEditingController _hblAccountNumberController = TextEditingController();
  final TextEditingController _cnicNumberController = TextEditingController();
  Map<String, dynamic>? selectedAddress;
  bool isFirstTimeAdding = true; // Track if it's the first time adding an address

  final Uuid _uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Billing Information'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Billing Information',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 10),
            if (selectedAddress != null)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${selectedAddress!['fullName']}', style: const TextStyle(fontSize: 16)),
                      Text('Email: ${selectedAddress!['email']}', style: const TextStyle(fontSize: 16)),
                      Text('Contact: ${selectedAddress!['mobile']}', style: const TextStyle(fontSize: 16)),
                      Text('Address: ${selectedAddress!['address']}', style: const TextStyle(fontSize: 16)),
                      Text('Area: ${selectedAddress!['area']}', style: const TextStyle(fontSize: 16)),
                      Text('City: ${selectedAddress!['city']}', style: const TextStyle(fontSize: 16)),
                      Text('Province: ${selectedAddress!['province']}', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),
            const Text(
              'Cart Items',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final item = widget.cartItems[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
                  child: ListTile(
                    title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Quantity: ${item['quantity']} - Price: Rs. ${item['price']}'),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Total Amount: Rs. ${widget.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedBillingMethod,
              decoration: const InputDecoration(
                labelText: 'Select Billing Method',
                border: OutlineInputBorder(),
              ),
              items: ['Credit Card', 'Debit Card', 'PayPal', 'Cash on Delivery', 'Easypaisa', 'JazzCash', 'HBL Account']
                  .map((method) => DropdownMenuItem<String>(
                value: method,
                child: Text(method),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedBillingMethod = value;
                  _clearBillingFields(); // Clear fields when method changes
                });
              },
            ),
            const SizedBox(height: 20),
            if (selectedBillingMethod == 'Easypaisa')
              TextFormField(
                controller: _accountNumberController,
                decoration: const InputDecoration(
                  labelText: 'Enter Easypaisa Account Number',
                  border: OutlineInputBorder(),
                ),
              ),
            if (selectedBillingMethod == 'JazzCash')
              TextFormField(
                controller: _accountNumberController,
                decoration: const InputDecoration(
                  labelText: 'Enter JazzCash Account Number',
                  border: OutlineInputBorder(),
                ),
              ),
            if (selectedBillingMethod == 'Credit Card' || selectedBillingMethod == 'Debit Card')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _cardNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Card Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextFormField(
                    controller: _cardNameController,
                    decoration: const InputDecoration(
                      labelText: 'Name on Card',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextFormField(
                    controller: _cardExpirationController,
                    decoration: const InputDecoration(
                      labelText: 'Expiration Date',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextFormField(
                    controller: _cardCVVController,
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            if (selectedBillingMethod == 'HBL Account')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _hblAccountNumberController,
                    decoration: const InputDecoration(
                      labelText: 'HBL Account Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextFormField(
                    controller: _cnicNumberController,
                    decoration: const InputDecoration(
                      labelText: 'CNIC Number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            if (selectedBillingMethod == 'Cash on Delivery')
              Container(), // No additional fields needed
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _processOrder();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.teal,
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Place Order'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isFirstTimeAdding) {
            _showAddressSelectionDialog(); // Directly show add address dialog if it's the first time
          } else {
            _showAddressSelectionDialog(); // Show address selection dialog if addresses already exist
          }
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _clearBillingFields() {
    _pinController.clear();
    _accountNumberController.clear();
    _cardNumberController.clear();
    _cardNameController.clear();
    _cardExpirationController.clear();
    _cardCVVController.clear();
    _hblAccountNumberController.clear();
    _cnicNumberController.clear();
  }

  void _processOrder() {
    if (selectedAddress == null || selectedBillingMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please complete all fields')));
      return;
    }

    final orderData = {
      'orderId': _uuid.v4(),
      'userEmail': widget.userEmail,
      'totalAmount': widget.totalAmount,
      'cartItems': widget.cartItems.map((item) => item.data()).toList(),
      'selectedAddress': selectedAddress,
      'billingMethod': selectedBillingMethod,
      'pin': selectedBillingMethod == 'Cash on Delivery' ? null : _pinController.text,
      'easypaisaAccount': selectedBillingMethod == 'Easypaisa' ? _accountNumberController.text : null,
      'jazzcashAccount': selectedBillingMethod == 'JazzCash' ? _accountNumberController.text : null,
      'cardNumber': selectedBillingMethod == 'Credit Card' || selectedBillingMethod == 'Debit Card' ? _cardNumberController.text : null,
      'cardName': selectedBillingMethod == 'Credit Card' || selectedBillingMethod == 'Debit Card' ? _cardNameController.text : null,
      'cardExpiration': selectedBillingMethod == 'Credit Card' || selectedBillingMethod == 'Debit Card' ? _cardExpirationController.text : null,
      'cardCVV': selectedBillingMethod == 'Credit Card' || selectedBillingMethod == 'Debit Card' ? _cardCVVController.text : null,
      'hblAccount': selectedBillingMethod == 'HBL Account' ? _hblAccountNumberController.text : null,
      'cnicNumber': selectedBillingMethod == 'HBL Account' ? _cnicNumberController.text : null,
      'status': 'pending',
    };

    FirebaseFirestore.instance.collection('billing').add(orderData).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order is pending')));
      Navigator.of(context).popUntil((route) => route.isFirst); // Go back to the home page
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to place order: $error')));
    });
  }

  void _showAddressSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Address'),
          content: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('addresses')
                .where('userEmail', isEqualTo: widget.userEmail)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text('No addresses found.');
              }
              final addresses = snapshot.data!.docs
                  .map((doc) => doc.data() as Map<String, dynamic>)
                  .toList();
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...addresses.map((address) => ListTile(
                    title: Text('${address['fullName']}'),
                    subtitle: Text(
                        '${address['address']}, ${address['area']}, ${address['city']}, ${address['province']}'),
                    onTap: () {
                      setState(() {
                        selectedAddress = address;
                      });
                      Navigator.of(context).pop();
                    },
                  )),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              child: const Text('Add Another Address'),
              onPressed: () {
                Navigator.of(context).pop();
                _addAddressDialog();
              },
            ),
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addAddressDialog() {
    final _fullNameController = TextEditingController();
    final _emailController = TextEditingController();
    final _mobileController = TextEditingController();
    final _addressController = TextEditingController();
    String? selectedProvince;
    String? selectedCity;
    String? selectedArea;
    List<String> provinces = ['Sindh', 'Punjab']; // Example provinces
    List<String> cities = [];
    List<String> areas = [];
    Map<String, List<String>> provinceToCities = {
      'Sindh': ['Karachi', 'Hyderabad'],
      'Punjab': ['Lahore', 'Faisalabad'],
    };
    Map<String, List<String>> cityToAreas = {
      'Karachi': ['Clifton', 'Gulshan'],
      'Lahore': ['DHA', 'Gulberg'],
    };

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Address'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _fullNameController,
                      decoration: const InputDecoration(labelText: 'Full Name'),
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      controller: _mobileController,
                      decoration: const InputDecoration(labelText: 'Mobile Number'),
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Select Province'),
                      items: provinces.map((province) {
                        return DropdownMenuItem<String>(
                          value: province,
                          child: Text(province),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedProvince = value;
                          selectedCity = null;
                          selectedArea = null;
                          cities = provinceToCities[value!] ?? [];
                          areas = [];
                        });
                      },
                      value: selectedProvince,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Select City'),
                      items: cities.map((city) {
                        return DropdownMenuItem<String>(
                          value: city,
                          child: Text(city),
                        );
                      }).toList(),
                      onChanged: selectedProvince == null
                          ? null
                          : (value) {
                        setState(() {
                          selectedCity = value;
                          selectedArea = null;
                          areas = cityToAreas[value!] ?? [];
                        });
                      },
                      value: selectedCity,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Select Area'),
                      items: areas.map((area) {
                        return DropdownMenuItem<String>(
                          value: area,
                          child: Text(area),
                        );
                      }).toList(),
                      onChanged: selectedCity == null
                          ? null
                          : (value) {
                        setState(() {
                          selectedArea = value;
                        });
                      },
                      value: selectedArea,
                    ),
                    TextField(
                      controller: _addressController,
                      decoration: const InputDecoration(labelText: 'Address'),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                if (_fullNameController.text.isNotEmpty &&
                    _emailController.text.isNotEmpty &&
                    _mobileController.text.isNotEmpty &&
                    selectedProvince != null &&
                    selectedCity != null &&
                    selectedArea != null &&
                    _addressController.text.isNotEmpty) {
                  final newAddress = {
                    'addressId': _uuid.v4(),
                    'userEmail': widget.userEmail,
                    'fullName': _fullNameController.text,
                    'email': _emailController.text,
                    'mobile': _mobileController.text,
                    'province': selectedProvince,
                    'city': selectedCity,
                    'area': selectedArea,
                    'address': _addressController.text,
                  };

                  FirebaseFirestore.instance.collection('addresses').add(newAddress)
                      .then((_) {
                    Navigator.of(context).pop();
                    if (isFirstTimeAdding) {
                      _showAddressSelectionDialog(); // Show address selection dialog for the first time
                    }
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }
}
