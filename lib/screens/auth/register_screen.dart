import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../main_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final fulllnameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool agreeTerms = false;
  bool isLoading = false;

  Future<void> register() async {
    final fullname = fulllnameController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (fullname.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showSnack('Vui lòng điền đầy đủ thông tin');
      return;
    }
    if (password != confirmPassword) {
      showSnack('Mật khẩu xác nhận không khớp');
      return;
    }
    if (!agreeTerms) {
      showSnack('Bạn cần đồng ý với Điều khoản & Điều kiện');
      return;
    }
    setState(() => isLoading = true);
    try {
      final url = Uri.parse('https://nidez.net/api/auth/register.php');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullname': fullname,
          'phone': phone,
          'password': password,
        }),
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
            MaterialPageRoute(builder: (_) => MainScreen()),
          );
        }
      } else {
        showSnack(data['message'] ?? 'Đăng ký thất bại');
      }
    } catch (e) {
      showSnack('Lỗi kết nối đến máy chủ: $e');
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
              Icon(Icons.person_add, size: 80, color: mainColor),
              const SizedBox(height: 16),
              Text(
                'Tạo tài khoản mới',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: mainColor,
                ),
              ),
              const SizedBox(height: 32),

              // Họ tên
              TextField(
                controller: fulllnameController,
                style: TextStyle(color: mainColor),
                decoration: _inputDecoration(
                  mainColor,
                  'Họ và tên',
                  Icons.person,
                ),
              ),
              const SizedBox(height: 16),

              // Số điện thoại
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                style: TextStyle(color: mainColor),
                decoration: _inputDecoration(
                  mainColor,
                  'Số điện thoại',
                  Icons.phone,
                ),
              ),
              const SizedBox(height: 16),

              // Mật khẩu
              TextField(
                controller: passwordController,
                obscureText: true,
                style: TextStyle(color: mainColor),
                decoration: _inputDecoration(mainColor, 'Mật khẩu', Icons.lock),
              ),
              const SizedBox(height: 16),

              // Xác nhận mật khẩu
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                style: TextStyle(color: mainColor),
                decoration: _inputDecoration(
                  mainColor,
                  'Xác nhận mật khẩu',
                  Icons.lock_outline,
                ),
              ),
              const SizedBox(height: 10),

              CheckboxListTile(
                value: agreeTerms,
                onChanged: (value) =>
                    setState(() => agreeTerms = value ?? false),
                activeColor: mainColor,
                controlAffinity: ListTileControlAffinity.leading,
                title: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black87, fontSize: 15),
                    children: [
                      const TextSpan(text: "Tôi đồng ý với "),
                      TextSpan(
                        text: "Điều khoản & Điều kiện",
                        style: TextStyle(
                          color: mainColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text("Điều khoản & Điều kiện"),
                                content: const Text(
                                  "Đây là điều khoản sử dụng dịch vụ của TaoBook...",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: Text(
                                      "Đóng",
                                      style: TextStyle(color: mainColor),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: isLoading ? null : register,
                icon: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.app_registration),
                label: Text(isLoading ? 'Đang xử lý...' : 'Đăng ký'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                  );
                },
                child: Text(
                  'Đã có tài khoản? Đăng nhập',
                  style: TextStyle(color: mainColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
    Color mainColor,
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: mainColor),
      prefixIcon: Icon(icon, color: mainColor),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: mainColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: mainColor, width: 2),
      ),
    );
  }
}
