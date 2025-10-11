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
      if (data["success"] == true) {
        setState(() {
          services = data["data"];
        });
      }
    } catch (e) {
      debugPrint("Lỗi khi tải dịch vụ: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mainColor = Colors.deepOrange;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: FloatingActionButton(
          mini: true,
          onPressed: () => Navigator.pop(context),
          backgroundColor: mainColor,
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.deepOrange),
            )
          : RefreshIndicator(
              onRefresh: loadServices,
              color: mainColor,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final item = services[index];
                  final rating =
                      double.tryParse(item['rating'].toString()) ?? 0.0;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SelectBarberScreen(
                            service: {
                              'id': item['id'],
                              'name': item['name'],
                              'price': item['price'],
                              'image': item['image'],
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
                          // Ảnh dịch vụ
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                            ),
                            child: Image.network(
                              item['image'],
                              width: 110,
                              height: 110,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => Container(
                                width: 110,
                                height: 110,
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.image_not_supported),
                              ),
                            ),
                          ),

                          // Nội dung
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    item['name'],
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
                                      fontSize: 13,
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Giá + sao
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item['price'].toString(),
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
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.orangeAccent,
                                            size: 16,
                                          ),
                                        ),
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
            ),
    );
  }
}
