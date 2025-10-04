import 'package:flutter/material.dart';
import 'package:taobook/screens/time_selection_screen.dart';

class SelectBarberScreen extends StatelessWidget {
  final Map<String, dynamic> service;

  const SelectBarberScreen({super.key, required this.service});

  final List<Map<String, dynamic>> barbers = const [
    {'name': 'Anh Nam', 'image': 'assets/images/services/1.jpg', 'rating': 4.8},
    {
      'name': 'Anh Hùng',
      'image': 'assets/images/services/1.jpg',
      'rating': 4.6,
    },
    {
      'name': 'Anh Tuấn',
      'image': 'assets/images/services/1.jpg',
      'rating': 4.7,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final mainColor = Colors.deepOrange;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chọn thợ"),
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
          Text(
            "✂️ Chọn thợ cho dịch vụ: ${service['name']}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),

          ...barbers.map((barber) {
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
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.asset(
                    barber['image'],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  barber['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    Text("${barber['rating']} ⭐"),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TimeSelectionScreen(
                          service: service, // cái service từ trang trước
                          barber: barber, // cái barber bạn đang chọn
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Chọn"),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
