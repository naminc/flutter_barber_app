import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taobook/screens/edit_booking_screen.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  List<dynamic> bookings = [];
  bool isLoading = true;
  final mainColor = Colors.deepOrange.shade700;

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  int asInt(dynamic v, {int fallback = 0}) {
    if (v == null) return fallback;
    if (v is int) return v;
    final s = v.toString();
    if (s.isEmpty || s == 'null') return fallback;
    return int.tryParse(s) ?? fallback;
  }

  Future<void> fetchBookings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      if (userJson == null) {
        setState(() => isLoading = false);
        return;
      }

      final user = jsonDecode(userJson);
      final userId = user['id'];

      final url = Uri.parse("https://nidez.net/api/bookings/get_bookings.php");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId}),
      );

      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        setState(() => bookings = data['data']);
      } else {
        _showSnack(data['message'] ?? 'Không thể tải danh sách lịch');
      }
    } catch (e) {
      _showSnack('Lỗi tải dữ liệu: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> cancelBooking(int bookingId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      if (userJson == null) return;
      final user = jsonDecode(userJson);

      final url = Uri.parse(
        "https://nidez.net/api/bookings/cancel_booking.php",
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'booking_id': bookingId, 'user_id': user['id']}),
      );

      final data = jsonDecode(response.body);
      _showSnack(data['message'] ?? 'Lỗi hủy lịch');

      if (data['success'] == true) fetchBookings();
    } catch (e) {
      _showSnack('Lỗi kết nối đến máy chủ');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'done':
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Lịch sử đặt lịch"),
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.deepOrange),
            )
          : bookings.isEmpty
          ? const Center(
              child: Text(
                "😕 Chưa có lịch đặt nào",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            )
          : RefreshIndicator(
              color: mainColor,
              onRefresh: fetchBookings,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final b = bookings[index];
                  final statusColor = _statusColor(b['status']);

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.orange.shade100,
                              child: const Icon(
                                Icons.cut,
                                color: Colors.deepOrange,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                b['service_name'] ?? 'Dịch vụ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: mainColor,
                                ),
                              ),
                            ),
                            PopupMenuButton<String>(
                              color: Colors.white,
                              onSelected: (value) {
                                if (value == 'edit') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EditBookingScreen(
                                        bookingId: asInt(b['id']),
                                        barberId: asInt(b['barber_id']),
                                        serviceName: b['service_name'],
                                        price: b['price'],
                                        barberName: b['barber_name'],
                                        barberImage: b['barber_image'],
                                        oldDate: b['date'],
                                        oldTime: b['time_slot'],
                                      ),
                                    ),
                                  ).then((updated) {
                                    if (updated == true) fetchBookings();
                                  });
                                } else if (value == 'cancel') {
                                  cancelBooking(asInt(b['id']));
                                }
                              },
                              itemBuilder: (context) => const [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Text("Chỉnh sửa"),
                                ),
                                PopupMenuItem(
                                  value: 'cancel',
                                  child: Text("Hủy lịch"),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Giá
                        Row(
                          children: [
                            const Icon(
                              Icons.attach_money,
                              color: Colors.green,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text("${b['price']} VND"),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Ngày & Giờ
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_month,
                              color: Colors.blue,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "${DateFormat('dd/MM/yyyy').format(DateTime.parse(b['date']))} - ${b['time_slot']}",
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Thợ cắt
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              color: Colors.purple,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(b['barber_name'] ?? 'Không rõ thợ'),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(
                                b['barber_image'] ?? '',
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 40,
                                  height: 40,
                                  color: Colors.grey.shade200,
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Trạng thái
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: statusColor),
                            ),
                            child: Text(
                              b['status'] == 'pending'
                                  ? "Đang chờ"
                                  : b['status'] == 'confirmed'
                                  ? "Đã xác nhận"
                                  : b['status'] == 'done'
                                  ? "Hoàn tất"
                                  : "Đã hủy",
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
