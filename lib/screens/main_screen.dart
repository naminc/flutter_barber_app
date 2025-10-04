import 'package:flutter/material.dart';
import 'package:taobook/screens/home_screen.dart';
import 'package:taobook/screens/select_service_screen.dart';
import 'package:taobook/screens/account_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final mainColor = Colors.deepOrange.shade700;

    String title = "Trang chủ";
    if (_currentIndex == 1) title = "Chọn dịch vụ";
    if (_currentIndex == 2) title = "Thông tin tài khoản";

    Widget body = const HomeScreen();
    if (_currentIndex == 1) body = SelectServiceScreen();
    if (_currentIndex == 2) body = const AccountScreen();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        backgroundColor: mainColor,
      ),
      body: body,
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