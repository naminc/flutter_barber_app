import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      final user = jsonDecode(userJson);
      nameController.text = user['fullname'] ?? '';
      phoneController.text = user['phone'] ?? '';
      emailController.text = user['email'] ?? '';
    }
  }

  Future<void> updateProfile() async {
    final fullname = nameController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (fullname.isEmpty || phone.isEmpty) {
      showSnack('Không được để trống họ tên và số điện thoại');
      return;
    }
    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      if (userJson == null) {
        showSnack('Không tìm thấy thông tin người dùng');
        return;
      }
      final user = jsonDecode(userJson);
      final userId = user['id'];
      final response = await http.post(
        Uri.parse('https://nidez.net/api/profile/update_profile.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': userId,
          'fullname': fullname,
          'phone': phone,
          'email': email,
          'password': password,
        }),
      );
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        await prefs.setString('user', jsonEncode(data['user']));
        showSnack('Cập nhật thành công', success: true);
      } else {
        showSnack(data['message'] ?? 'Cập nhật thất bại');
      }
    } catch (e) {
      showSnack('Không thể kết nối đến máy chủ');
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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Chỉnh sửa thông tin"),
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        backgroundColor: mainColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.deepOrange.shade100,
              child: const Icon(
                Icons.person,
                color: Colors.deepOrange,
                size: 50,
              ),
            ),
            const SizedBox(height: 20),

            // Họ và tên
            TextFormField(
              controller: nameController,
              style: TextStyle(color: mainColor),
              decoration: InputDecoration(
                labelText: "Họ và tên",
                prefixIcon: Icon(Icons.person, color: mainColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: mainColor, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: mainColor.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(12),
                ),
                labelStyle: TextStyle(color: mainColor),
              ),
            ),
            const SizedBox(height: 16),

            // Email
            TextFormField(
              controller: emailController,
              style: TextStyle(color: mainColor),
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email, color: mainColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: mainColor, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: mainColor.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(12),
                ),
                labelStyle: TextStyle(color: mainColor),
              ),
            ),
            const SizedBox(height: 16),

            // Số điện thoại
            TextFormField(
              controller: phoneController,
              style: TextStyle(color: mainColor),
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Số điện thoại",
                prefixIcon: Icon(Icons.phone, color: mainColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: mainColor, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: mainColor.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(12),
                ),
                labelStyle: TextStyle(color: mainColor),
              ),
            ),
            const SizedBox(height: 16),

            // Mật khẩu mới
            TextFormField(
              controller: passwordController,
              style: TextStyle(color: mainColor),
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Mật khẩu mới (tuỳ chọn)",
                prefixIcon: Icon(Icons.lock, color: mainColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: mainColor, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: mainColor.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(12),
                ),
                labelStyle: TextStyle(color: mainColor),
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : updateProfile,
                icon: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(
                  isLoading ? "Đang lưu..." : "Lưu thay đổi",
                  style: const TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
