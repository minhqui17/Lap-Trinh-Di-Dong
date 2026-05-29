import 'package:flutter/material.dart';
import 'package:travel_booking/models/place.dart';
import 'package:travel_booking/features/booking/screens/hotel_list_booking.dart';
import 'package:travel_booking/features/places/screens/map_screen.dart';

class PlaceDetailScreen extends StatelessWidget {
  final Place place;

  const PlaceDetailScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: 16),
                      Icon(Icons.star, color: Colors.orange, size: 16),
                      Icon(Icons.star, color: Colors.orange, size: 16),
                      Icon(Icons.star, color: Colors.orange, size: 16),
                    ],
                  ),
                  Text(
                    place.name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.blue, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "${place.location} - Vị trí tuyệt vời",
                          style: const TextStyle(color: Colors.blue, fontSize: 13),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapScreen(place: place),
                            ),
                          );
                        },
                        icon: const Icon(Icons.map, size: 18),
                        label: const Text("Xem bản đồ"),
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
                  const Text(
                    "Mô tả địa điểm",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Nằm ở vị trí đắc địa, ${place.name} cung cấp chỗ nghỉ có hồ bơi ngoài trời, chỗ đậu xe riêng miễn phí và sân hiên. Chỗ nghỉ này cung cấp lễ tân 24/24, dịch vụ đưa đón sân bay và Wi-Fi miễn phí toàn bộ khuôn viên...",
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 20),


                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HotelListBooking()));
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF003580)),
                      child: const Text("Xem chi tiết ngay", style: TextStyle(color: Colors.white, fontSize: 16)),
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
      height: 250,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              children: [
                Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(8))),
                const SizedBox(height: 8),
                Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(8))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenities() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Các tiện nghi được ưa chuộng nhất", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Wrap(
            spacing: 20,
            runSpacing: 10,
            children: [
              _amenityItem(Icons.pool, "Hồ bơi ngoài trời"),
              _amenityItem(Icons.wifi, "WiFi miễn phí"),
              _amenityItem(Icons.local_airport, "Đưa đón sân bay"),
              _amenityItem(Icons.smoke_free, "Phòng không hút thuốc"),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _amenityItem(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Colors.green),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  Widget _buildGeniusBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Đăng nhập để tiết kiệm", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Tiết kiệm ít nhất 10% tại chỗ nghỉ này khi đăng nhập", style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          Icon(Icons.card_giftcard, color: Colors.blue, size: 40),
        ],
      ),
    );
  }
}