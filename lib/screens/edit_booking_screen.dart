import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditBookingScreen extends StatefulWidget {
  final int bookingId;
  final int barberId;
  final String serviceName;
  final String price;
  final String barberName;
  final String barberImage;
  final String oldDate;
  final String oldTime;

  const EditBookingScreen({
    super.key,
    required this.bookingId,
    required this.barberId,
    required this.serviceName,
    required this.price,
    required this.barberName,
    required this.barberImage,
    required this.oldDate,
    required this.oldTime,
  });

  @override
  State<EditBookingScreen> createState() => _EditBookingScreenState();
}

class _EditBookingScreenState extends State<EditBookingScreen> {
  DateTime selectedDate = DateTime.now();
  String? selectedTime;
  List<dynamic> timeSlots = [];
  bool isLoading = false;

  final mainColor = Colors.deepOrange;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.tryParse(widget.oldDate) ?? DateTime.now();
    selectedTime = widget.oldTime;
    fetchTimeSlots();
  }

  Future<void> fetchTimeSlots() async {
    setState(() => isLoading = true);
    try {
      final url = Uri.parse(
        "https://nidez.net/api/bookings/get_time_slots.php",
      );
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "barber_id": widget.barberId,
          "date": DateFormat('yyyy-MM-dd').format(selectedDate),
        }),
      );

      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        setState(() => timeSlots = data['data']);
      } else {
        _showSnack(data['message'] ?? "Không thể tải khung giờ");
      }
    } catch (e) {
      _showSnack("Lỗi kết nối máy chủ");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> updateBooking() async {
    if (selectedTime == null) {
      _showSnack("Vui lòng chọn khung giờ mới");
      return;
    }

    setState(() => isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      if (userJson == null) return;
      final user = jsonDecode(userJson);

      final url = Uri.parse(
        "https://nidez.net/api/bookings/update_booking.php",
      );
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "booking_id": widget.bookingId,
          "user_id": user['id'],
          "date": DateFormat('yyyy-MM-dd').format(selectedDate),
          "time_slot": selectedTime,
        }),
      );

      final data = jsonDecode(response.body);
      _showSnack(data['message']);
      if (data['success'] == true && mounted) {
        Navigator.pop(context, true); // reload list
      }
    } catch (e) {
      _showSnack("Không thể cập nhật lịch");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        selectedTime = null;
      });
      fetchTimeSlots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Chỉnh sửa lịch hẹn"),
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
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔶 Service Info Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
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
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            widget.barberImage,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 70,
                              height: 70,
                              color: Colors.grey.shade300,
                              child: const Icon(
                                Icons.person,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.serviceName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: mainColor,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "${widget.price} VND",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Thợ: ${widget.barberName}",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 🗓️ Date
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "📅 ${DateFormat('dd/MM/yyyy').format(selectedDate)}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _selectDate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Đổi ngày"),
                        ),
                      ],
                    ),
                  ),

                  // 🕒 Time Slots
                  const Text(
                    "🕒 Chọn giờ:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  timeSlots.isEmpty
                      ? const Text("Không có khung giờ khả dụng")
                      : GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 3,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 2.6,
                          children: timeSlots.map((slot) {
                            final time = slot['time'];
                            final available = slot['available'] == true;
                            final isSelected = time == selectedTime;

                            return GestureDetector(
                              onTap: available
                                  ? () => setState(() => selectedTime = time)
                                  : null,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: !available
                                      ? Colors.grey.shade300
                                      : isSelected
                                      ? mainColor
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: !available
                                        ? Colors.grey.shade400
                                        : isSelected
                                        ? mainColor
                                        : Colors.grey.shade400,
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  time,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: !available
                                        ? Colors.grey.shade600
                                        : isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                  const SizedBox(height: 30),

                  // 🟢 Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : updateBooking,
                      icon: isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.check_circle),
                      label: Text(
                        isLoading ? "Đang lưu..." : "Lưu thay đổi",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
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
