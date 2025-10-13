import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taobook/screens/about_screen.dart';
import 'package:taobook/screens/auth/login_screen.dart';
import 'package:taobook/screens/booking_history_screen.dart';
import 'package:taobook/screens/profile/edit_profile_screen.dart';
import 'package:taobook/screens/profile/support_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  Future<Map<String, dynamic>?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      return jsonDecode(userJson);
    }
    return null;
  }
  @override
  Widget build(BuildContext context) {
    final mainColor = Colors.deepOrange;

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: FloatingActionButton(
          mini: true,
          onPressed: () => Navigator.pop(context),
          backgroundColor: mainColor,
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          FutureBuilder<Map<String, dynamic>?>(
            future: loadUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(color: Colors.deepOrange),
                );
              }
              final user = snapshot.data;
              final fullname = user?['fullname'] ?? 'Người dùng';
              final phone = user?['phone'] ?? 'Chưa có số điện thoại';
              return Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.deepOrange,
                      child: Icon(Icons.person, color: Colors.white, size: 36),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        "$fullname\n$phone",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 1.2,
                  color: Colors.white,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: mainColor.withOpacity(0.1),
                      child: Icon(Icons.edit, color: mainColor),
                    ),
                    title: const Text("Chỉnh sửa thông tin"),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => EditProfileScreen()),
                      );
                    },
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 1.2,
                  color: Colors.white,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: mainColor.withOpacity(0.1),
                      child: Icon(Icons.history, color: mainColor),
                    ),
                    title: const Text("Lịch sử đặt lịch"),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookingHistoryScreen(),
                        ),
                      );
                    },
                  ),
                ),

                // Liên hệ hỗ trợ
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 1.2,
                  color: Colors.white,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: mainColor.withOpacity(0.1),
                      child: Icon(Icons.headset_mic, color: mainColor),
                    ),
                    title: const Text("Liên hệ hỗ trợ"),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SupportScreen()),
                      );
                    },
                  ),
                ),

                // Giới thiệu ứng dụng
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 1.2,
                  color: Colors.white,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: mainColor.withOpacity(0.1),
                      child: Icon(Icons.info_outline, color: mainColor),
                    ),
                    title: const Text("Giới thiệu ứng dụng"),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AboutScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Đăng xuất
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 1.2,
              color: Colors.white,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.red.withOpacity(0.1),
                  child: const Icon(Icons.logout, color: Colors.red),
                ),
                title: const Text(
                  "Đăng xuất",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final userJson = prefs.getString('user');

                  if (userJson != null) {
                    final user = jsonDecode(userJson);
                    final userId = user['id'];

                    try {
                      final res = await http.post(
                        Uri.parse(
                          'https://nidez.net/api/users/remove_fcm_token.php',
                        ),
                        headers: {'Content-Type': 'application/json'},
                        body: jsonEncode({'user_id': userId}),
                      );

                      debugPrint("🧹 Remove token response: ${res.body}");
                    } catch (e) {
                      debugPrint("⚠️ Lỗi khi xóa FCM token: $e");
                    }
                  }
                  await prefs.clear();
                  if (!context.mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                    (route) => false,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
