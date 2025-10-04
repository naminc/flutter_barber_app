import 'package:flutter/material.dart';
import 'package:taobook/screens/select_barber_screen.dart';

class SelectServiceScreen extends StatelessWidget {
  final List<Map<String, dynamic>> services = [
    {
      'id': 1,
      'name': 'Cắt tóc nam',
      'price': 100000,
      'image': 'assets/images/services/1.jpg',
    },
    {
      'id': 2,
      'name': 'Cạo mặt',
      'price': 50000,
      'image': 'assets/images/services/1.jpg',
    },
    {
      'id': 3,
      'name': 'Gội đầu thư giãn',
      'price': 80000,
      'image': 'assets/images/services/1.jpg',
    },
    {
      'id': 4,
      'name': 'Nhuộm tóc',
      'price': 200000,
      'image': 'assets/images/services/1.jpg',
    },
    {
      'id': 5,
      'name': 'Massage mặt',
      'price': 150000,
      'image': 'assets/images/services/1.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final mainColor = Colors.deepOrange;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () => Navigator.pop(context),
        backgroundColor: mainColor,
        child: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 10),
          const Text(
            "💈 Chọn dịch vụ bạn muốn",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),

          // List dịch vụ
          ...services.map((service) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {},
                child: Row(
                  children: [
                    // Hình ảnh dịch vụ
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                      child: Image.asset(
                        service['image'],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Thông tin
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service['name'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: mainColor,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "${service['price']} VND",
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: const [
                                Icon(Icons.star, color: Colors.amber, size: 16),
                                Icon(Icons.star, color: Colors.amber, size: 16),
                                Icon(Icons.star, color: Colors.amber, size: 16),
                                Icon(
                                  Icons.star_half,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Nút đặt
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  SelectBarberScreen(service: service),
                            ),
                          );
                        },
                        child: const Text("Đặt ngay"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
