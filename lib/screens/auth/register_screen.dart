import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import '../main_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool agreeTerms = false;

  void register() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mainColor = Colors.deepOrange.shade700;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.person_add, size: 80, color: mainColor),
              SizedBox(height: 16),
              Text(
                'Tạo tài khoản mới',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: mainColor,
                ),
              ),
              Text(
                'Vui lòng điền thông tin để đăng ký!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: mainColor,
                ),
              ),
              SizedBox(height: 32),

              // Họ tên
              TextField(
                controller: nameController,
                style: TextStyle(color: mainColor),
                decoration: InputDecoration(
                  labelText: 'Họ và tên',
                  labelStyle: TextStyle(color: mainColor),
                  prefixIcon: Icon(Icons.person, color: mainColor),
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
              SizedBox(height: 16),

              // Email
              TextField(
                controller: emailController,
                style: TextStyle(color: mainColor),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: mainColor),
                  prefixIcon: Icon(Icons.email, color: mainColor),
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
              SizedBox(height: 16),
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
              SizedBox(height: 16),

              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                style: TextStyle(color: mainColor),
                decoration: InputDecoration(
                  labelText: 'Xác nhận mật khẩu',
                  labelStyle: TextStyle(color: mainColor),
                  prefixIcon: Icon(Icons.lock_outline, color: mainColor),
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
              SizedBox(height: 10),

              CheckboxListTile(
                value: agreeTerms,
                onChanged: (value) {
                  setState(() {
                    agreeTerms = value ?? false;
                  });
                },
                activeColor: mainColor,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.symmetric(horizontal: 1),
                title: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(text: "Tôi đồng ý với "),
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
                                title: Text("Điều khoản & Điều kiện"),
                                content: SingleChildScrollView(
                                  child: Text(
                                    "Đây là nội dung điều khoản mẫu...\n\n"
                                    "1. Bạn đồng ý sử dụng dịch vụ.\n"
                                    "2. Không spam, không lạm dụng.\n"
                                    "3. Chúng tôi tôn trọng quyền riêng tư...",
                                    style: TextStyle(fontSize: 14, height: 1.5),
                                  ),
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
              SizedBox(height: 16),

              // Nút Đăng ký
              ElevatedButton.icon(
                onPressed: register,
                icon: Icon(Icons.app_registration),
                label: Text('Đăng ký', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
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
}
