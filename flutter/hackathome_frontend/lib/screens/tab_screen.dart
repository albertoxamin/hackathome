import 'package:anylivery/values/values.dart';
import 'package:flutter/material.dart';
import 'package:anylivery/screens/profile.dart';
import 'package:anylivery/screens/shops.dart';

import 'myshops.dart';

class TabScreen extends StatefulWidget {
  @override
  TabState createState() => new TabState();
}

class TabState extends State<TabScreen> {
  List<StatefulWidget> _pages;
  StatefulWidget _selectedContent;
  int _bottomIndex;

  @override
  void initState() {
    _bottomIndex = 0;
    super.initState();
  }

  void _definePages() {
    _pages = <StatefulWidget>[
      Shops(),
      MyShops(),
      Profile(),
    ];
  }

  void _onTabTapped(int index) {
    setState(() {
      _bottomIndex = index;
      _selectedContent = _pages[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    _definePages();
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress)
          return false;
        else
          return true;
      },
      child: Scaffold(
        body: Center(
          child: _selectedContent ?? _pages[_bottomIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              title: Text('Compra'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.store),
              title: Text('Miei Negozi'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profilo'),
            ),
          ],
          selectedItemColor: Colors.black,
          currentIndex: _bottomIndex,
          onTap: _onTabTapped,
        ),
      ),
    );
  }
}
