import 'package:flutter/material.dart';
import 'package:taobook/screens/home_screen.dart';
import 'select_service_screen.dart';
import 'account_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    SelectServiceScreen(),
    AccountScreen(),
  ];

  final List<String> _titles = [
    'Trang chủ',
    'Chọn dịch vụ',
    'Thông tin tài khoản',
  ];

  @override
  Widget build(BuildContext context) {
    final mainColor = Colors.deepOrange.shade700;
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        
        backgroundColor: mainColor,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: mainColor,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.cut), label: 'Dịch vụ'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tài khoản'),
        ],
      ),
    );
  }
}
