import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './scan_photo.dart';
import './photo_history.dart';

import '../macro/constant.dart';
import '../macro/text.dart';


class HomeScreen extends StatefulWidget {
  final int index;

  // constructor
  HomeScreen({required String tab, Key? key})
      : index = indexFrom(tab),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();

  static int indexFrom(String tab) {
    switch (tab) {
      case 'scan':
        return 0;
      case 'history':
        return 1;
      case 'other':
        return 2;
      default:
        return 0;
    }
  }
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;
  }

  //dependency of this State object changes
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
      statusBarColor: DARKCOLOR_SCHEME,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: DARKCOLOR_SCHEME,
        foregroundColor: Colors.white,
        title: Text(
          APP_NAME,
            style: const TextStyle(color: Colors.white,
                fontStyle: FontStyle.italic,
                )
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.photo_camera), label: 'Scan'),
            BottomNavigationBarItem(icon: Icon(Icons.photo_library),
                label: HOME_ACC_INFO),
          ],
          backgroundColor: Colors.white70,
          currentIndex: _selectedIndex,
          selectedItemColor: NAV_COLOR,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          }),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          Scan(),
          PhotoHistory(),
        ],
      ),
    );
  }
}
