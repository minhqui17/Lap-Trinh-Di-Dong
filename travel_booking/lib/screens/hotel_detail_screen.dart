import 'package:flutter/material.dart';
import 'package:travel_booking/screens/booking_confirm_screen.dart';
import '../models/place.dart';
import 'booking_confirm_screen.dart';

class HotelDetailScreen extends StatelessWidget {
  final Place place;

  const HotelDetailScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.favorite_border, color: Colors.blue), onPressed: () {}),
          IconButton(icon: const Icon(Icons.share, color: Colors.blue), onPressed: () {}),
          IconButton(icon: const Icon(Icons.map_outlined, color: Colors.blue), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Tiêu đề & Địa chỉ (Dùng place.location thay vì address)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(place.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.blue, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          place.location, // Đã đổi theo module mới
                          style: const TextStyle(color: Colors.blue, fontSize: 13, decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            _buildImageGrid(),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFF003580), borderRadius: BorderRadius.circular(8)),
                        child: Text("${place.rating}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      Text(
                        "${place.price} VND / đêm",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Text("Giới thiệu chỗ nghỉ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
                  const SizedBox(height: 8),
                  Text(
                    "Nằm ở vị trí thuận tiện ở Đà Nẵng, ${place.name} cung cấp chỗ nghỉ chất lượng cao. Chỗ nghỉ này nằm tại ${place.location}, thuận tiện di chuyển đến các điểm tham quan.",
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 20),

                  // 🔹 Nút Đặt ngay (Sửa lỗi Navigator từ image_4311a5.png và image_4366fc.png)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // FIX lỗi Navigator: thêm Navigator.push và dấu phẩy context
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BookingConfirmationScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003580),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      child: const Text("Đặt ngay", style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),

            _buildAmenities(),
            _buildGeniusBanner(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGrid() {
    return Container(
      height: 220,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              // Dùng ảnh từ biến place.image (module mới)
              child: Image.asset(place.image, fit: BoxFit.cover, height: double.infinity),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.asset('assets/images/DaLat.jpg', fit: BoxFit.cover, width: double.infinity),
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.asset('assets/images/VungTau.jpg', fit: BoxFit.cover),
                      ),
                      Container(
                        color: Colors.black.withOpacity(0.3),
                        child: const Center(
                          child: Text("+12 ảnh", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ... (Giữ nguyên các hàm _buildAmenities và _buildGeniusBanner từ code trước)
  Widget _buildAmenities() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Các tiện nghi được ưa chuộng nhất", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 20,
            runSpacing: 10,
            children: [
              _amenityItem(Icons.pool, "Hồ bơi"),
              _amenityItem(Icons.wifi, "WiFi"),
              _amenityItem(Icons.local_airport, "Đưa đón"),
              _amenityItem(Icons.smoke_free, "Không hút thuốc"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _amenityItem(IconData icon, String label) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 18, color: Colors.green),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(fontSize: 13)),
    ]);
  }

  Widget _buildGeniusBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
      child: const Row(children: [
        Expanded(child: Text("Đăng nhập Genius để giảm 10%.", style: TextStyle(fontSize: 13))),
        Icon(Icons.card_giftcard, color: Colors.blue),
      ]),
    );
  }
}