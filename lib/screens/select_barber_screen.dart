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
        setState(() {
          barbers = data["data"];
        });
      }
    } catch (e) {
      debugPrint("Lỗi khi tải danh sách thợ: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
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
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: barbers.length,
              itemBuilder: (context, index) {
                final barber = barbers[index];
                return GestureDetector(
                  onTap: () {
                    print("➡️ Chọn thợ: ${barber['name']} (id=${barber['id']})");

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TimeSelectionScreen(
                          service: widget.service,
                          barber: {
                            "id": int.tryParse("${barber['id']}") ?? 0,
                            "name": barber['name'] ?? '',
                            "image": barber['image'] ?? '',
                            "rating": barber['rating'] ?? '',
                            "description": barber['description'] ?? '',
                          },
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                          child: Image.network(
                            barber['image'] ?? '',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.person, size: 40),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
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
                                  barber['description'] ??
                                      'Thợ cắt tóc chuyên nghiệp',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.star,
                                        size: 16, color: Colors.orangeAccent),
                                    const SizedBox(width: 4),
                                    Text(
                                      barber['rating'].toString(),
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black87),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
