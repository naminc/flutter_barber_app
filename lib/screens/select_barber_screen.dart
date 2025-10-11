import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:taobook/screens/time_selection_screen.dart';

class SelectBarberScreen extends StatefulWidget {
  final Map<String, dynamic> service;

  const SelectBarberScreen({super.key, required this.service});

  @override
  State<SelectBarberScreen> createState() => _SelectBarberScreenState();
}

class _SelectBarberScreenState extends State<SelectBarberScreen> {
  List<dynamic> barbers = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    loadBarbers();
  }

  Future<void> loadBarbers() async {
    try {
      final response = await http.get(
        Uri.parse("https://nidez.net/api/barbers/get_barbers.php"),
      );
      final data = jsonDecode(response.body);
      if (data["success"] == true) {
        setState(() {
          barbers = data["data"];
        });
      } else {
        setState(() => hasError = true);
      }
    } catch (e) {
      debugPrint("❌ Lỗi tải thợ: $e");
      setState(() => hasError = true);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mainColor = Colors.deepOrange;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: mainColor,
        elevation: 0,
        title: const Text(
          "💈 Chọn thợ",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.deepOrange),
            )
          : hasError
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.redAccent,
                    size: 60,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Không thể tải danh sách thợ 😢",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                        hasError = false;
                      });
                      loadBarbers();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text("Thử lại"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: loadBarbers,
              color: mainColor,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: barbers.length,
                itemBuilder: (context, index) {
                  final barber = barbers[index];
                  return _buildBarberCard(
                    context,
                    name: barber['name'],
                    image: barber['image'],
                    rating: double.tryParse(barber['rating'].toString()) ?? 0.0,
                    description:
                        barber['description'] ?? "Thợ cắt tóc chuyên nghiệp.",
                    mainColor: mainColor,
                    service: widget.service,
                  );
                },
              ),
            ),
    );
  }

  // === Card của từng thợ ===
  Widget _buildBarberCard(
    BuildContext context, {
    required String name,
    required String image,
    required double rating,
    required String description,
    required Color mainColor,
    required Map<String, dynamic> service,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              image,
              height: 190,
              width: double.infinity,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stack) => Container(
                height: 190,
                color: Colors.grey.shade200,
                child: const Icon(
                  Icons.person_off,
                  size: 60,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ).copyWith(bottom: 16),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (i) => Icon(
                      i < rating.round()
                          ? Icons.star
                          : Icons.star_border_outlined,
                      color: Colors.amber,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TimeSelectionScreen(
                            service: service,
                            barber: {
                              'name': name,
                              'image': image,
                              'rating': rating,
                            },
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.check),
                    label: const Text(
                      "Chọn thợ này",
                      style: TextStyle(fontWeight: FontWeight.bold),
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
        ],
      ),
    );
  }
}
