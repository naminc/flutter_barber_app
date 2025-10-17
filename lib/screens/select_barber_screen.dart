import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:taobook/screens/time_selection_screen.dart';

class SelectBarberScreen extends StatefulWidget {
  final Map<String, dynamic> service;

  const SelectBarberScreen({
    super.key,
    required this.service,
  });

  @override
  State<SelectBarberScreen> createState() => _SelectBarberScreenState();
}

class _SelectBarberScreenState extends State<SelectBarberScreen> {
  List<dynamic> barbers = [];
  bool isLoading = true;
  final mainColor = Colors.deepOrange;

  @override
  void initState() {
    super.initState();
    _loadBarbers();
  }

  Future<void> _loadBarbers() async {
    try {
      final response = await http.get(
        Uri.parse("https://nidez.net/api/barbers/get_barbers.php"),
      );
      final data = jsonDecode(response.body);

      if (data["success"] == true) {
        setState(() => barbers = data["data"]);
      }
    } catch (e) {
      debugPrint("❌ Lỗi khi tải danh sách thợ: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        title: const Text("Chọn thợ cắt tóc"),
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
          : barbers.isEmpty
              ? const Center(
                  child: Text(
                    "Không có thợ cắt nào khả dụng.",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 20),
                      ...barbers.asMap().entries.map(
                        (entry) {
                          final index = entry.key;
                          final barber = entry.value;
                          return _animatedCard(
                            delay: index * 50, // ⚡ nhanh hơn
                            child: _buildBarberCard(barber),
                          );
                        },
                      ).toList(),
                    ],
                  ),
                ),
    );
  }

  // --- Header gradient ---
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [mainColor, Colors.orangeAccent]),
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
          const Icon(Icons.people_alt_rounded, color: Colors.white, size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Chọn thợ phù hợp ✂️",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Hãy chọn người thợ mà bạn tin tưởng nhất để tiếp tục",
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
    );
  }

  // --- Card thông tin thợ ---
  Widget _buildBarberCard(Map<String, dynamic> barber) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (_, __, ___) => TimeSelectionScreen(
              service: widget.service,
              barber: {
                "id": int.tryParse("${barber['id']}") ?? 0,
                "name": barber['name'] ?? '',
                "image": barber['image'] ?? '',
                "rating": barber['rating'] ?? '',
                "description": barber['description'] ?? '',
              },
            ),
            transitionsBuilder: (_, animation, __, child) => FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                barber['image'] ?? '',
                width: 85,
                height: 85,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 85,
                  height: 85,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.person, size: 38),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    barber['name'] ?? 'Không rõ tên',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    barber['description'] ?? 'Thợ cắt tóc chuyên nghiệp',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star,
                          size: 16, color: Colors.orangeAccent),
                      const SizedBox(width: 4),
                      Text(
                        barber['rating'].toString(),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Đánh giá cao",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                color: mainColor.withOpacity(0.8), size: 18),
          ],
        ),
      ),
    );
  }

  // --- Animation nhanh gấp đôi ---
  Widget _animatedCard({required int delay, required Widget child}) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 220 + delay ~/ 2), // ⚡ nhanh hơn
      builder: (context, value, _) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 12 * (1 - value)), // nhỏ hơn => mượt
            child: child,
          ),
        );
      },
    );
  }
}
