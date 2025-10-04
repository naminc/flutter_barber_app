import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mainColor = Colors.deepOrange.shade700;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Liên hệ hỗ trợ"),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon support
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.deepOrange.shade100,
                child: const Icon(
                  Icons.support_agent,
                  color: Colors.deepOrange,
                  size: 50,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ==== Họ và tên ====
            TextFormField(
              decoration: InputDecoration(
                labelText: "Họ và tên",
                prefixIcon: Icon(Icons.person, color: mainColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: mainColor, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: mainColor.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(12),
                ),
                labelStyle: TextStyle(color: mainColor),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email, color: mainColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: mainColor, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: mainColor.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(12),
                ),
                labelStyle: TextStyle(color: mainColor),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Số điện thoại",
                prefixIcon: Icon(Icons.phone, color: mainColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: mainColor, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: mainColor.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(12),
                ),
                labelStyle: TextStyle(color: mainColor),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Nội dung cần hỗ trợ",
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: mainColor, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: mainColor.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(12),
                ),
                labelStyle: TextStyle(color: mainColor),
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Đã gửi yêu cầu hỗ trợ!")),
                  );
                },
                icon: const Icon(Icons.send),
                label: const Text("Gửi hỗ trợ", style: TextStyle(fontSize: 16)),
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
