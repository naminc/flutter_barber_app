import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taobook/screens/auth/forgot_password_screen.dart';
import 'package:taobook/screens/main_screen.dart';
import 'package:taobook/screens/auth/register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainScreen()),
      );
    }
  }

  Future<void> login() async {
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();
    if (phone.isEmpty || password.isEmpty) {
      showSnack('Số điện thoại và mật khẩu không được để trống');
      return;
    }
    setState(() => isLoading = true);
    try {
      final url = Uri.parse('https://nidez.net/api/auth/login.php');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'password': password}),
      );
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        showSnack(data['message'], success: true);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', jsonEncode(data['user']));
        await prefs.setString('token', data['user']['token']);
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        }
      } else {
        showSnack(data['message']);
      }
    } catch (e) {
      showSnack('Lỗi kết nối đến máy chủ');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showSnack(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mainColor = Colors.deepOrange.shade700;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.cut, size: 80, color: mainColor),
              const SizedBox(height: 16),
              Text(
                'Chào mừng bạn!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: mainColor,
                ),
              ),
              Text(
                'Vui lòng đăng nhập để sử dụng dịch vụ!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: mainColor,
                ),
              ),
              const SizedBox(height: 32),

              TextField(
                controller: phoneController,
                style: TextStyle(color: mainColor),
                decoration: InputDecoration(
                  labelText: 'Số điện thoại',
                  labelStyle: TextStyle(color: mainColor),
                  prefixIcon: Icon(Icons.phone, color: mainColor),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: mainColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: mainColor, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: passwordController,
                obscureText: true,
                style: TextStyle(color: mainColor),
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  labelStyle: TextStyle(color: mainColor),
                  prefixIcon: Icon(Icons.lock, color: mainColor),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: mainColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: mainColor, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: isLoading ? null : login,
                icon: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.login),
                label: Text(
                  isLoading ? 'Đang xử lý...' : 'Đăng nhập',
                  style: const TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(child: Divider(thickness: 1, color: mainColor)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "hoặc tiếp tục với",
                      style: TextStyle(
                        color: mainColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(thickness: 1, color: mainColor)),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.grey.shade200,
                    child: const FaIcon(
                      FontAwesomeIcons.google,
                      color: Colors.red,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 20),
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.grey.shade200,
                    child: const FaIcon(
                      FontAwesomeIcons.facebookF,
                      color: Colors.blue,
                      size: 22,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => RegisterScreen()),
                  );
                },
                child: Text(
                  'Chưa có tài khoản? Đăng ký',
                  style: TextStyle(color: mainColor),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => ForgotPasswordScreen()),
                  );
                },
                child: Text(
                  'Quên mật khẩu?',
                  style: TextStyle(color: mainColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
