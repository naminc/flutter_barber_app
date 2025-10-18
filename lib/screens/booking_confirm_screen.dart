import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class BookingConfirmScreen extends StatefulWidget {
  final Map<String, dynamic> service;
  final Map<String, dynamic> barber;
  final DateTime date;
  final String time;

  const BookingConfirmScreen({
    super.key,
    required this.service,
    required this.barber,
    required this.date,
    required this.time,
  });

  @override
  State<BookingConfirmScreen> createState() => _BookingConfirmScreenState();
}

class _BookingConfirmScreenState extends State<BookingConfirmScreen> {
  bool isLoading = false;
  final mainColor = Colors.deepOrange;

  Future<void> _createBooking() async {
    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      if (userJson == null) {
        showSnack('Vui lòng đăng nhập để đặt lịch');
        return;
      }

      final user = jsonDecode(userJson);
      final userId = user['id'];

      final response = await http.post(
        Uri.parse('https://nidez.net/api/bookings/create_booking.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "user_id": userId,
          "barber_id": widget.barber['id'] ?? 1,
          "service_id": widget.service['id'] ?? 1,
          "date": DateFormat('yyyy-MM-dd').format(widget.date),
          "time_slot": widget.time,
        }),
      );

      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        showSnack(data['message'], success: true);
        Navigator.popUntil(context, (route) => route.isFirst);
      } else {
        showSnack(data['message'] ?? 'Đặt lịch thất bại');
      }
    } catch (e) {
      showSnack('Lỗi kết nối đến máy chủ');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showSnack(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: success ? Colors.green : Colors.redAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        title: const Text("Xác nhận đặt lịch"),
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        backgroundColor: mainColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _animatedCard(
              delay: 0,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [mainColor, Colors.orangeAccent],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: mainColor.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.event_available,
                        color: Colors.white, size: 36),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Xác nhận lịch hẹn ✨",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Hãy kiểm tra lại thông tin trước khi hoàn tất",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),

            _animatedCard(
              delay: 50,
              child: _infoCard(
                icon: Icons.cut,
                iconColor: mainColor,
                title: "Dịch vụ",
                name: widget.service['name'] ?? 'Không rõ',
                detail: "${widget.service['price'] ?? 0}",
              ),
            ),
            _animatedCard(
              delay: 100,
              child: _infoCard(
                icon: Icons.person,
                iconColor: Colors.purple,
                title: "Thợ cắt",
                name: widget.barber['name'] ?? 'Không rõ',
                detail: "⭐ ${widget.barber['rating'] ?? '5.0'}",
                image: widget.barber['image'],
              ),
            ),
            _animatedCard(
              delay: 150,
              child: _infoCard(
                icon: Icons.calendar_month,
                iconColor: Colors.blue,
                title: "Thời gian",
                name:
                    "${widget.time}, ${DateFormat('EEEE, dd/MM/yyyy').format(widget.date)}",
              ),
            ),

            const SizedBox(height: 20),

            // --- Nút xác nhận ---
            _animatedCard(
              delay: 200,
              child: Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(
                    colors: [mainColor, Colors.orangeAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: mainColor.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : _createBooking,
                  icon: isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.2,
                          ),
                        )
                      : const Icon(Icons.check_circle_outline, size: 22),
                  label: Text(
                    isLoading ? "Đang xử lý..." : "Xác nhận & Hoàn tất",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String name,
    String? detail,
    String? image,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.1),
            radius: 28,
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (detail != null)
                  Text(detail, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          if (image != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholderAvatar(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _placeholderAvatar() => Container(
        width: 60,
        height: 60,
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: const Icon(Icons.person, color: Colors.grey),
      );

  Widget _animatedCard({required int delay, required Widget child}) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 250 + delay ~/ 2),
      builder: (context, value, _) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 15 * (1 - value)),
            child: child,
          ),
        );
      },
    );
  }
}