import 'package:flutter/material.dart';
import 'package:tamanina/Features/Home/presentation/view_model/views/widgets/HomeBody.dart';
import '../../../../Azkar/presentation/view_model/views/Azkar.dart';
import '../../../../Pray/presentation/view_model/views/PrayerTime.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 2;

  final List<Widget> _pages = [
    const PrayerTimesPage(),
    const Azkar(),
    const HomeBody(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,  // Apply BottomNavigationBar color
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Color(0xff2e7d32),  // Apply selected item color
        unselectedItemColor: Colors.grey,  // Apply unselected item color
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'مواقيت الصلاة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined),
            label: 'الأذكار',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'الرئيسية',
          ),
        ],
      ),
    );
  }
}
