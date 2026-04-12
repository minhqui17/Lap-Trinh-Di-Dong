import 'package:flutter/material.dart';
import '../models/place.dart';
import 'hotel_detail_screen.dart';

class HotelListBooking extends StatelessWidget {
  const HotelListBooking({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Kết quả tìm kiếm",
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Thanh thông tin tổng quan
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    "Đà Nẵng: 1.619 chỗ nghỉ phù hợp",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    _buildTopButton("Xem ngang"),
                    const SizedBox(width: 8),
                    _buildTopButton("Xem dọc"),
                  ],
                )
              ],
            ),
          ),

          // 2. Nút Sắp xếp
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.swap_vert, size: 18),
              label: const Text("Sắp xếp theo: Lựa chọn hàng đầu của chúng tôi"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                side: BorderSide(color: Colors.grey.shade400),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // 3. Danh sách khách sạn
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildHotelCard(
                  context,
                  id: "1",
                  name: "The BackPacker Hotel",
                  imageUrl: "assets/images/HCM.jpg",
                  rating: 9.2,
                  ratingText: "Tuyệt hảo",
                  reviews: 291,
                  address: "41 Đường Nguyễn Đình, Đà Nẵng",
                  description: "Nằm ở Đà Nẵng, cách Bãi biển Mỹ Khê 8 phút đi bộ, cung cấp hồ bơi ngoài trời...",
                  price: 1200000,
                  stars: 4,
                ),
                _buildHotelCard(
                  context,
                  id: "2",
                  name: "Chung cư Mường Thanh - Cute",
                  imageUrl: "assets/images/DaLat.jpg",
                  rating: 8.5,
                  ratingText: "Rất tốt",
                  reviews: 150,
                  address: "Sơn Trà, Đà Nẵng",
                  description: "Căn hộ có hồ bơi ban công và Wi-Fi miễn phí. Vị trí cực kỳ thuận tiện...",
                  price: 850000,
                  isNew: true,
                ),
                _buildHotelCard(
                  context,
                  id: "3",
                  name: "POSIKI Hotel & Dorm",
                  imageUrl: "assets/images/VungTau.jpg",
                  rating: 6.4,
                  ratingText: "Điểm đánh giá",
                  reviews: 1354,
                  address: "Sông Hàn, Đà Nẵng",
                  description: "Cung cấp các phòng có điều hòa, dịch vụ phòng và Wi-Fi miễn phí...",
                  price: 450000,
                  stars: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildHotelCard(
      BuildContext context, {
        required String id,
        required String name,
        required String imageUrl,
        required double rating,
        required String ratingText,
        required int reviews,
        required String address,
        required String description,
        required int price,
        int stars = 0,
        bool isNew = false,
      }) {

    // 🔹 QUAN TRỌNG: Tạo model Place từ dữ liệu để truyền đi
    final place = Place(
      id: id,
      name: name,
      location: address,
      rating: rating,
      image: imageUrl,
      price: price,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100, width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 18,
                  child: Icon(Icons.favorite_border, color: Colors.blue.shade800, size: 20),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(name, style: TextStyle(color: Colors.blue.shade800, fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 4),
                              if (stars > 0) Row(children: List.generate(stars, (i) => const Icon(Icons.star, color: Colors.orange, size: 12))),
                            ],
                          ),
                          Text("$address", style: const TextStyle(color: Colors.blue, fontSize: 11, decoration: TextDecoration.underline)),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(ratingText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            Text("$reviews đánh giá", style: const TextStyle(color: Colors.grey, fontSize: 10)),
                          ],
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: Colors.blue.shade900, borderRadius: BorderRadius.circular(4)),
                          child: Text("$rating", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 8),
                if (isNew)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(4)),
                    child: const Text("Mới trên Booking.com", style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                Text(description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Colors.black87)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${price} VND", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
                    ElevatedButton(
                      onPressed: () {
                        // 🔹 Điều hướng: Đảm bảo KHÔNG có 'const' trước HotelDetailScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HotelDetailScreen(place: place),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      child: const Text("Chọn ngay", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}