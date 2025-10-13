import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:taobook/screens/account_screen.dart';
import 'package:taobook/screens/booking_history_screen.dart';
import 'package:taobook/screens/select_service_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> sliders = [];
  Map<String, dynamic>? nextBooking;
  bool isLoading = true;
  final mainColor = Colors.deepOrange;
  String userName = '';

  @override
  void initState() {
    super.initState();
    loadSliders();
    fetchNextBooking();
    loadUserName();
  }

  Future<void> loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      final user = jsonDecode(userJson);
      final fullName = user['fullname'] ?? '';
      final parts = fullName.trim().split(' ');
      final shortName = parts.isNotEmpty ? parts.last : fullName;
      setState(() => userName = shortName);
    }
  }

  Future<void> loadSliders() async {
    try {
      final res = await http.get(
        Uri.parse("https://nidez.net/api/slider/get_slider.php"),
      );
      final data = jsonDecode(res.body);
      if (data["success"] == true && data["data"] is List) {
        sliders = data["data"];
      }
    } catch (e) {
      debugPrint("Lỗi load slider: $e");
    } finally {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchNextBooking() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      if (userJson == null) return;

      final user = jsonDecode(userJson);
      final url = Uri.parse(
        "https://nidez.net/api/bookings/get_next_booking.php",
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': user['id']}),
      );

      final data = jsonDecode(response.body);

      if (data['success'] == true && data['data'] != null) {
        setState(() => nextBooking = data['data']);
      } else {
        setState(() => nextBooking = null);
      }
    } catch (e) {
      debugPrint("Lỗi lấy lịch sắp tới: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final String displayName = userName.isNotEmpty ? userName : 'bạn';

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Xin chào 👋 ",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Text(
                    displayName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            if (isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(color: Colors.deepOrange),
                ),
              )
            else if (sliders.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("Không có banner nào được hiển thị"),
                ),
              )
            else
              CarouselSlider(
                options: CarouselOptions(
                  height: 180,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                ),
                items: sliders.map((item) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        Image.network(
                          item["image"],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.black54, Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          bottom: 16,
                          child: Text(
                            item["title"] ?? "",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 20),

            if (nextBooking != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.deepOrange, Colors.pinkAccent],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepOrange.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.schedule, color: Colors.white, size: 40),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${nextBooking!['service_name']} - ${nextBooking!['time_slot']}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            DateFormat(
                              'dd/MM/yyyy',
                            ).format(DateTime.parse(nextBooking!['date'])),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "Thợ: ${nextBooking!['barber_name']}",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        nextBooking!['barber_image'] ?? '',
                        width: 45,
                        height: 45,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 45,
                          height: 45,
                          color: Colors.white12,
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "✨ Dịch vụ nổi bật",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),

            GridView.count(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildServiceCard(Icons.cut, "Cắt tóc nam", Colors.orange),
                _buildServiceCard(Icons.spa, "Gội đầu", Colors.green),
                _buildServiceCard(Icons.face, "Cạo mặt", Colors.blue),
                _buildServiceCard(Icons.color_lens, "Nhuộm tóc", Colors.purple),
              ],
            ),

            const SizedBox(height: 28),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "⚡ Chức năng nhanh",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _quickAction(Icons.calendar_today, "Đặt lịch", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SelectServiceScreen(),
                    ),
                  );
                }),
                _quickAction(Icons.history, "Lịch sử", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BookingHistoryScreen(),
                    ),
                  );
                }),
                _quickAction(Icons.person, "Tài khoản", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AccountScreen()),
                  );
                }),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(IconData icon, String title, Color color) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(colors: [color.withOpacity(0.8), color]),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 30,
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickAction(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.deepOrange.shade100,
            child: Icon(icon, color: Colors.deepOrange, size: 28),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
