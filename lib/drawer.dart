  import 'package:flutter/material.dart';

  class DrawerScreen extends StatefulWidget {
    const DrawerScreen({Key? key}) : super(key: key);

    @override
    _DrawerScreenState createState() => _DrawerScreenState();
  }

  class _DrawerScreenState extends State<DrawerScreen> {
    List<bool> _isExpanded = List<bool>.filled(5, false);

    @override
    Widget build(BuildContext context) {
      // Define your subitem titles here
      List<List<String>> subItemTitles = [
        ["Sippers & Cups", "Dishes & Utensils", "Teethers & Pacifiers", "Kids Food & Supplement"],
        ["Lotion Oils & Powders", "Creams", "Bath Tubs & Bathers", "Towels", "Bathing Accessories"],
        ["Wipes", "Rash Creams", "Potty Seats", "Diapers"],
        ["Musical Toys", "Bath Toys", "Playmats", "Soft Toys", "Rattles"],
        ["Swaddles", "Sleep Wear", "Caps & Hats", "Body Suits & Wrampers", "Blankets"],
      ];

      return  Drawer(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "MENU",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context); // Close the drawer
                      },
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.home_outlined),
                      SizedBox(width: 12.0),
                      Text(
                        "HOME",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Handle HOME tap
                  },
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Row(
                              children: [
                                Icon(getCategoryIcon(index + 1)),
                                SizedBox(width: 12.0),
                                Text(
                                  getCategoryTitle(index + 1),
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(_isExpanded[index] ? Icons.remove : Icons.add),
                              onPressed: () {
                                setState(() {
                                  _isExpanded[index] = !_isExpanded[index];
                                });
                              },
                            ),
                          ),
                          if (_isExpanded[index])
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _buildSubItems(index, subItemTitles[index]),
                              ),
                            ),
                          Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );

    }

    IconData getCategoryIcon(int index) {
      switch (index) {
        case 0:
          return Icons.home_outlined;
        case 1:
          return Icons.local_cafe_outlined;
        case 2:
          return Icons.bathtub_outlined;
        case 3:
          return Icons.baby_changing_station;
        case 4:
          return Icons.toys_outlined;
        case 5:
          return Icons.checkroom;
        default:
          return Icons.category;
      }
    }

    String getCategoryTitle(int index) {
      switch (index) {
        case 0:
          return "HOME";
        case 1:
          return "FEEDING";
        case 2:
          return "BATH";
        case 3:
          return "DIAPERING";
        case 4:
          return "TOYS";
        case 5:
          return "FASHION";
        default:
          return "CATEGORY";
      }
    }

    List<Widget> _buildSubItems(int index, List<String> subItemTitles) {
      return List.generate(subItemTitles.length, (subIndex) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Row(
                children: [
                  SizedBox(width: 12.0),
                  SizedBox(
                    width: 120,
                    child: Text(
                      subItemTitles[subIndex],
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: Text(subItemTitles[subIndex]),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      });
    }
  }