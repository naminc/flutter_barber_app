import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:taobook/screens/select_barber_screen.dart';

class SelectServiceScreen extends StatefulWidget {
  const SelectServiceScreen({super.key});

  @override
  State<SelectServiceScreen> createState() => _SelectServiceScreenState();
}

class _SelectServiceScreenState extends State<SelectServiceScreen> {
  List<dynamic> services = [];
  bool isLoading = true;
  final mainColor = Colors.deepOrange;

  @override
  void initState() {
    super.initState();
    loadServices();
  }

  Future<void> loadServices() async {
    try {
      final response = await http.get(
        Uri.parse("https://nidez.net/api/services/get_services.php"),
      );
      final data = jsonDecode(response.body);
      if (data["success"] == true && mounted) {
        setState(() => services = data["data"]);
      }
    } catch (e) {
      debugPrint("❌ Lỗi khi tải dịch vụ: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.deepOrange),
            )
          : RefreshIndicator(
              color: mainColor,
              onRefresh: loadServices,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),
                    ...services.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return _animatedCard(
                        delay: index * 70,
                        child: _buildServiceCard(item),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
    );
  }

  // --- Header gradient ---
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [mainColor, Colors.orangeAccent]),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: mainColor.withOpacity(0.35),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.design_services_rounded,
              color: Colors.white, size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Chọn dịch vụ ✂️",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Hãy chọn dịch vụ bạn muốn sử dụng để tiếp tục đặt lịch.",
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

  // --- Card dịch vụ ---
  Widget _buildServiceCard(Map<String, dynamic> item) {
    final rating = double.tryParse(item['rating']?.toString() ?? "0") ?? 0.0;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      splashColor: mainColor.withOpacity(0.1),
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (_, __, ___) => SelectBarberScreen(
              service: {
                'id': item['id'],
                'name': item['name'],
                'price': item['price'],
                'image': item['image'],
              },
            ),
            transitionsBuilder: (_, animation, __, child) =>
                FadeTransition(opacity: animation, child: child),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- Ảnh dịch vụ ---
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                item['image'] ?? '',
                width: 85,
                height: 85,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 85,
                  height: 85,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // --- Nội dung ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'] ?? "Không rõ tên",
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['description'] ??
                        "Dịch vụ chất lượng tại salon TaoBook",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 13.5,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${item['price']}",
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.5,
                        ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            i < rating.round()
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            color: Colors.orangeAccent,
                            size: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // --- Mũi tên ---
            const Padding(
              padding: EdgeInsets.only(left: 8, right: 6),
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.deepOrange,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Animation xuất hiện mượt ---
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
