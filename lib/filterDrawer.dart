import 'package:babyshophub/Add_Screen.dart';
import 'package:flutter/material.dart';
class Filter_drawer extends StatefulWidget {
  const Filter_drawer({super.key});

  @override
  State<Filter_drawer> createState() => _Filter_drawerState();
}

class _Filter_drawerState extends State<Filter_drawer> {
  @override
  Widget build(BuildContext context) {
    return  Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Filter Options',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.filter_1),
            title: Text('Filter 1'),
            onTap: () {
              // Handle filter 1 action
            },
          ),
          ListTile(
            leading: Icon(Icons.filter_2),
            title: Text('Filter 2'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Add_Data()));
            },
          ),
          // Add more filter options here
        ],
      ),
    );
  }
}
