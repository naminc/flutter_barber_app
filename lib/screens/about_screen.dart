import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mainColor = Colors.deepOrange.shade700;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Giới thiệu ứng dụng"),
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
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: mainColor.withOpacity(0.1),
              child: Icon(Icons.cut, size: 50, color: mainColor),
            ),
            const SizedBox(height: 12),
            const Text(
              "TaoBook",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text("Phiên bản 1.0.0", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const Text(
                "✨ TaoBook giúp bạn đặt lịch cắt tóc nhanh chóng, "
                "quản lý lịch sử dễ dàng và nhận ưu đãi hấp dẫn từ salon. "
                "Ứng dụng được thiết kế với giao diện hiện đại, "
                "thân thiện và tiện lợi cho người dùng.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
            const SizedBox(height: 30),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "📞 Thông tin liên hệ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: mainColor,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(14),
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
                  CircleAvatar(
                    backgroundColor: mainColor.withOpacity(0.1),
                    child: Icon(Icons.email, color: mainColor),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      "support@taobook.com",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(14),
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
                  CircleAvatar(
                    backgroundColor: mainColor.withOpacity(0.1),
                    child: Icon(Icons.phone, color: mainColor),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      "Hotline: 0347 101 143",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),

            // Website
            Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(14),
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
                  CircleAvatar(
                    backgroundColor: mainColor.withOpacity(0.1),
                    child: Icon(Icons.public, color: mainColor),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      "www.taobook.com",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(14),
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
                  CircleAvatar(
                    backgroundColor: mainColor.withOpacity(0.1),
                    child: Icon(Icons.location_on, color: mainColor),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      "30 Linh Dong, Thu Duc, HCMC",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  
                },
                icon: const Icon(Icons.star_rate_rounded),
                label: const Text("Đánh giá ứng dụng"),
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
    );
  }
}