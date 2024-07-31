import 'package:babyshophub/cart.dart';
import 'package:babyshophub/page_indicator.dart';
import 'package:babyshophub/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdateScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final String userAge;
  final String userGender;
  final String userContact;
  final String userAddress;

  UpdateScreen({
    required this.userId,
    required this.userName,
    required this.userAge,
    required this.userGender,
    required this.userContact,
    required this.userAddress,
  });

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {

  int currentIndex = 0;

  void pageShifter(int index) {
    setState(() {
      currentIndex = index;
    });
  }
  final List<Widget> myscreens = [
    Product_Page(),
    CartPage(),
    RegisterScreen(),
  ];

  void _onBottomNavBarTapped(int index) {
    setState(() {
      currentIndex = index;
    });
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => myscreens[index]),
          (Route<dynamic> route) => false,
    );
  }


  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _contact;
  late String _address;
  late String _gender;
  late String _age;

  @override
  void initState() {
    super.initState();
    _name = widget.userName;
    _contact = widget.userContact;
    _address = widget.userAddress;
    _gender = widget.userGender;
    _age = widget.userAge;
  }

  Future<void> _updateUserInfo() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
          'name': _name,
          'contact': _contact,
          'address': _address,
          'gender': _gender,
          'age': _age,
        });
        Navigator.pop(context);
      } catch (e) {
        print('Failed to update user info: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Information"),
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade800, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 4,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    _buildProfileSection(),
                    _buildTextField(
                      label: 'Name',
                      initialValue: _name,
                      onSaved: (value) => _name = value!,
                    ),
                    _buildTextField(
                      label: 'Contact',
                      initialValue: _contact,
                      onSaved: (value) => _contact = value!,
                    ),
                    _buildTextField(
                      label: 'Address',
                      initialValue: _address,
                      onSaved: (value) => _address = value!,
                    ),
                    _buildTextField(
                      label: 'Gender',
                      initialValue: _gender,
                      onSaved: (value) => _gender = value!,
                    ),
                    _buildTextField(
                      label: 'Age',
                      initialValue: _age,
                      onSaved: (value) => _age = value!,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateUserInfo,
                      child: const Text('Update',style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          iconSize: 18,
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.purple,
          showUnselectedLabels: true,
          currentIndex: currentIndex,
          onTap: _onBottomNavBarTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Product"),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-NBM75ZQZZnw1LjpWznA06oYugMc2aPgGvMm9F_3XoeANFiUtQ5OZ_tq7ykNQCPrHoAE&usqp=CAU'),
        ),
        const SizedBox(width: 20),
        SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Username:",style: TextStyle(
              fontSize: 20,

            ),),
            Text(
              _name,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.purple,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required FormFieldSetter<String> onSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.purple),
          hintText: 'Enter your $label',
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
        ),
        onSaved: onSaved,
        validator: (value) => value!.isEmpty ? 'Please enter your $label' : null,
      ),
    );
  }
}