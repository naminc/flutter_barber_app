import 'package:flutter/material.dart';
import 'package:taobook/screens/time_selection_screen.dart';

class SelectBarberScreen extends StatelessWidget {
  final Map<String, dynamic> service;

  const SelectBarberScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final mainColor = Colors.deepOrange;

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
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
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

            // ===== Barber 1 =====
            _buildBarberCard(
              context,
              name: "Anh Nam",
              image: "assets/images/barber/1.jpg",
              rating: 4.8,
              mainColor: mainColor,
              service: service,
            ),

            // ===== Barber 2 =====
            _buildBarberCard(
              context,
              name: "Anh Hùng",
              image: "assets/images/barber/1.jpg",
              rating: 4.6,
              mainColor: mainColor,
              service: service,
            ),

            // ===== Barber 3 =====
            _buildBarberCard(
              context,
              name: "Anh Tuấn",
              image: "assets/images/barber/1.jpg",
              rating: 4.7,
              mainColor: mainColor,
              service: service,
            ),
          ],
        ),
      ),
    );
  }

  // === Widget Card của thợ ===
  Widget _buildBarberCard(
    BuildContext context, {
    required String name,
    required String image,
    required double rating,
    required Color mainColor,
    required Map<String, dynamic> service,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: CustomPaint(
        painter: DashedBorderPainter(color: mainColor, radius: 18),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: Image.asset(
                  image,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Column(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          "$rating ⭐",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
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
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;

  DashedBorderPainter({required this.color, this.radius = 12});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashWidth = 6;
    const dashSpace = 3;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius),
        ),
      );

    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}