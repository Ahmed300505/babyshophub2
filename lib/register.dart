import 'dart:ui';
import 'package:babyshophub/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  bool isHide = true;
  String? selectedGender;

  int currentIndex = 0;

  void pageShifter(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void userRegister() async {
    String userId = Uuid().v1();
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance.collection("users").doc(userId).set({
        "name": userNameController.text,
        "id": userId,
        "email": email,
        "contact": contactController.text,
        "address": addressController.text,
        "gender": selectedGender,
        "age": ageController.text,
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userEmail', email);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Registration failed')),
      );
    }
  }

  void goToLogin() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Stack(
        children: <Widget>[
          // Background image
          Positioned.fill(
            child: Image.network(
              'https://images.pexels.com/photos/5011647/pexels-photo-5011647.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
              fit: BoxFit.cover,
            ),
          ),
          // Glassmorphism effect
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ),
          // Form content
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 30),
                buildGlassTextField(userNameController, 'Username', Icons.person),
                SizedBox(height: 20),
                buildGlassTextField(emailController, 'Email Address', Icons.email),
                SizedBox(height: 20),
                buildGlassTextField(passwordController, 'Password', Icons.lock, isPassword: true),
                SizedBox(height: 20),
                buildGlassTextField(confirmPasswordController, 'Confirm Password', Icons.lock, isPassword: true),
                SizedBox(height: 20),
                buildGlassTextField(contactController, 'Contact Number', Icons.phone),
                SizedBox(height: 20),
                buildGlassTextField(addressController, 'Address', Icons.location_on),
                SizedBox(height: 20),
                buildGlassDropdownField(),
                SizedBox(height: 20),
                buildGlassTextField(ageController, 'Age', Icons.calendar_today),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: userRegister,
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 18, // Font size
                      fontWeight: FontWeight.bold, // Font weight
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Padding
                    elevation: 5, // Elevation
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: goToLogin,
                  child: Text("Already have an account? Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: pageShifter,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Product"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        ],
      ),
    );
  }

  Widget buildGlassTextField(TextEditingController controller, String labelText, IconData icon, {bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? isHide : false,
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.white),
          labelText: labelText,
          prefixIcon: Icon(icon, color: Colors.white),
          suffixIcon: isPassword
              ? IconButton(
            icon: isHide ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
            onPressed: () {
              setState(() {
                isHide = !isHide;
              });
            },
          )
              : null,
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.transparent,
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget buildGlassDropdownField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedGender,
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.white),
          labelText: 'Gender',
          prefixIcon: Icon(Icons.people, color: Colors.white),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.transparent,
        ),
        items: ['Male', 'Female'].map((String gender) {
          return DropdownMenuItem<String>(
            value: gender,
            child: Text(gender, style: TextStyle(color: Colors.white)),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            selectedGender = newValue;
          });
        },
        dropdownColor: Colors.black.withOpacity(0.7),
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
