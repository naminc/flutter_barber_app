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

  /// 🧩 Gọi API lấy danh sách khung giờ
  Future<void> _loadTimeSlots() async {
    setState(() {
      isLoading = true;
      selectedTime = null;
    });

    // Ép kiểu barber_id an toàn
    final barberId = int.tryParse("${widget.barber['id']}") ?? 0;
    final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);

    debugPrint("🧩 Gửi yêu cầu lấy khung giờ: barber_id=$barberId | date=$dateStr");

    try {
      final response = await http.post(
        Uri.parse("https://nidez.net/api/bookings/get_time_slots.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "barber_id": barberId,
          "date": dateStr,
        }),
      );

      final data = jsonDecode(response.body);
      debugPrint("📦 Phản hồi API: ${response.body}");

      if (data["success"] == true) {
        setState(() {
          timeSlots = data["data"];
        });
      } else {
        setState(() => timeSlots = []);
      }
    } catch (e) {
      debugPrint("❌ Lỗi khi tải khung giờ: $e");
      setState(() => timeSlots = []);
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// 📅 Chọn ngày bằng DatePicker
  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      _loadTimeSlots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // === Dịch vụ & thợ ===
                  Container(
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
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            widget.barber['image'] ?? '',
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stack) => Container(
                              width: 70,
                              height: 70,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.person, color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.service['name'] ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: mainColor,
                                ),
                              ),
                              Text(
                                "Thợ: ${widget.barber['name'] ?? 'Không rõ'}",
                                style: const TextStyle(color: Colors.black87),
                              ),
                              Text(
                                "${widget.service['price']} VND",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // === Chọn ngày ===
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "📅 Ngày: ${DateFormat('dd/MM/yyyy').format(selectedDate)}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => _selectDate(context),
                        icon: const Icon(Icons.calendar_month, size: 18),
                        label: Text("Đổi ngày", style: TextStyle(color: mainColor)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    "🕒 Chọn khung giờ phù hợp:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // === Danh sách khung giờ ===
                  if (timeSlots.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Không có khung giờ nào khả dụng.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    GridView.count(
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
                          onTap: available
                              ? () => setState(() => selectedTime = time)
                              : null,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: available
                                  ? (isSelected ? mainColor : Colors.white)
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: available
                                    ? mainColor
                                    : Colors.grey.shade400,
                                width: 1.5,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: mainColor.withOpacity(0.3),
                                        blurRadius: 6,
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
                                    ? (isSelected
                                        ? Colors.white
                                        : Colors.black87)
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: 40),

                  // === Nút xác nhận ===
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: selectedTime == null
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BookingConfirmScreen(
                                    service: widget.service,
                                    barber: widget.barber,
                                    date: selectedDate,
                                    time: selectedTime!,
                                  ),
                                ),
                              );
                            },
                      icon: const Icon(Icons.check),
                      label: const Text(
                        "Xác nhận đặt lịch",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor: Colors.grey.shade400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
