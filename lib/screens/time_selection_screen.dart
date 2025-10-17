import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:taobook/screens/booking_confirm_screen.dart';

class TimeSelectionScreen extends StatefulWidget {
  final Map<String, dynamic> service;
  final Map<String, dynamic> barber;

  const TimeSelectionScreen({
    super.key,
    required this.service,
    required this.barber,
  });

  @override
  State<TimeSelectionScreen> createState() => _TimeSelectionScreenState();
}

class _TimeSelectionScreenState extends State<TimeSelectionScreen> {
  DateTime selectedDate = DateTime.now();
  String? selectedTime;
  List<dynamic> timeSlots = [];
  bool isLoading = true;

  final mainColor = Colors.deepOrange;

  @override
  void initState() {
    super.initState();
    _loadTimeSlots();
  }

  Future<void> _loadTimeSlots() async {
    setState(() {
      isLoading = true;
      selectedTime = null;
    });

    final barberId = int.tryParse("${widget.barber['id']}") ?? 0;
    final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);

    try {
      final response = await http.post(
        Uri.parse("https://nidez.net/api/bookings/get_time_slots.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"barber_id": barberId, "date": dateStr}),
      );

      final data = jsonDecode(response.body);
      if (data["success"] == true) {
        setState(() => timeSlots = data["data"]);
      } else {
        setState(() => timeSlots = []);
      }
    } catch (e) {
      setState(() => timeSlots = []);
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
      _loadTimeSlots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        title: const Text("Chọn thời gian"),
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.deepOrange),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Header gradient ---
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
                          const Icon(
                            Icons.access_time_filled_rounded,
                            color: Colors.white,
                            size: 36,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Chọn thời gian hẹn ✨",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Hãy chọn ngày và giờ phù hợp để tiếp tục",
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

                  // --- Cards dịch vụ / thợ / ngày ---
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
                      title: "Ngày hẹn",
                      name: DateFormat('EEEE, dd/MM/yyyy').format(selectedDate),
                      detail: "Nhấn để đổi ngày",
                      onTap: () => _selectDate(context),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // --- Chọn khung giờ ---
                  const Text(
                    "🕒 Chọn khung giờ phù hợp:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  _animatedCard(delay: 200, child: _buildTimeSlots()),

                  const SizedBox(height: 40),
                  _animatedCard(delay: 250, child: _buildConfirmButton()),
                ],
              ),
            ),
    );
  }

  // --- Danh sách khung giờ ---
  Widget _buildTimeSlots() {
    if (timeSlots.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text(
            "Không có khung giờ khả dụng.",
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
        ),
      );
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.6,
      children: timeSlots.map((slot) {
        final time = slot["time"];
        final available = slot["available"] == true;
        final isSelected = selectedTime == time;

        return GestureDetector(
          onTap: available ? () => setState(() => selectedTime = time) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [Colors.deepOrange, Colors.orangeAccent],
                    )
                  : null,
              color: available
                  ? (isSelected ? null : Colors.white)
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: available
                    ? (isSelected ? Colors.transparent : Colors.deepOrange)
                    : Colors.grey.shade400,
                width: 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: mainColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : [],
            ),
            child: Text(
              time,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: available
                    ? (isSelected ? Colors.white : Colors.black87)
                    : Colors.grey,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // --- Nút xác nhận gradient ---
  Widget _buildConfirmButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: selectedTime == null
              ? [Colors.grey, Colors.grey]
              : [mainColor, Colors.orangeAccent],
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
        onPressed: selectedTime == null
            ? null
            : () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 300),
                    pageBuilder: (_, __, ___) => BookingConfirmScreen(
                      service: widget.service,
                      barber: widget.barber,
                      date: selectedDate,
                      time: selectedTime!,
                    ),
                    transitionsBuilder: (_, animation, __, child) =>
                        FadeTransition(opacity: animation, child: child),
                  ),
                );
              },
        icon: const Icon(Icons.check_circle_outline, size: 22),
        label: const Text(
          "Xác nhận & Tiếp tục",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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
    );
  }

  // --- Card thông tin ---
  Widget _infoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String name,
    String? detail,
    String? image,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
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
                  errorBuilder: (_, __, ___) => Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const Icon(Icons.person, color: Colors.grey),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // --- Animation nhanh hơn ---
  Widget _animatedCard({required int delay, required Widget child}) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 250 + delay ~/ 2), // ⚡ nhanh gấp đôi
      builder: (context, value, _) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 15 * (1 - value)), // dịch chuyển ít => mượt hơn
            child: child,
          ),
        );
      },
    );
  }
}
