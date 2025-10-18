import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final fullnameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final messageController = TextEditingController();

  bool isLoading = false;
  final mainColor = Colors.deepOrange.shade700;

  Future<void> sendSupport() async {
    final fullname = fullnameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final message = messageController.text.trim();

    if (fullname.isEmpty || email.isEmpty || phone.isEmpty || message.isEmpty) {
      showSnack("Vui lòng điền đầy đủ thông tin");
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse("https://nidez.net/api/supports/create_support.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "fullname": fullname,
          "email": email,
          "phone": phone,
          "message": message,
        }),
      );

      final data = jsonDecode(response.body);
      showSnack(data["message"] ?? "Đã gửi yêu cầu hỗ trợ");

      if (data["success"] == true) {
        fullnameController.clear();
        emailController.clear();
        phoneController.clear();
        messageController.clear();
      }
    } catch (e) {
      showSnack("Không thể kết nối đến máy chủ");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Liên hệ hỗ trợ"),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.deepOrange.shade100,
                child: const Icon(
                  Icons.support_agent,
                  color: Colors.deepOrange,
                  size: 50,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Họ và tên
            TextFormField(
              controller: fullnameController,
              style: TextStyle(color: mainColor),
              decoration: _inputDecoration("Họ và tên", Icons.person),
            ),
            const SizedBox(height: 16),

            // Email
            TextFormField(
              controller: emailController,
              style: TextStyle(color: mainColor),
              decoration: _inputDecoration("Email", Icons.email),
            ),
            const SizedBox(height: 16),

            // Số điện thoại
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              style: TextStyle(color: mainColor),
              decoration: _inputDecoration("Số điện thoại", Icons.phone),
            ),
            const SizedBox(height: 16),

            // Nội dung
            TextFormField(
              controller: messageController,
              style: TextStyle(color: mainColor),
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Nội dung cần hỗ trợ",
                alignLabelWithHint: true,
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

            // Nút gửi
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : sendSupport,
                icon: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.send),
                label: Text(
                  isLoading ? "Đang gửi..." : "Gửi hỗ trợ",
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

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: mainColor),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: mainColor, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: mainColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      labelStyle: TextStyle(color: mainColor),
    );
  }
}