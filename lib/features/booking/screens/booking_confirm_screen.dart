import 'package:flutter/material.dart';
import 'package:travel_booking/features/payment/screens/payment_screen.dart';

class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Xác nhận đặt phòng", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF003580),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Chi tiết đặt phòng của bạn",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildInfoRow("Tên khách sạn:", "The BackPacker Hotel"),
            _buildInfoRow("Ngày nhận phòng:", "15/04/2026"),
            _buildInfoRow("Số đêm:", "2 đêm"),
            const Divider(height: 40),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Tổng thanh toán:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("1.200.000 VNĐ", style: TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentScreen(
                        total: 1200000,
                        bookingDetails: {
                          'place': 'The BackPacker Hotel',
                          'guests': 2,
                          'checkin': '15/04/2026',
                          'checkout': '17/04/2026',
                        },
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF003580)),
                child: const Text("Hoàn tất thanh toán", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}