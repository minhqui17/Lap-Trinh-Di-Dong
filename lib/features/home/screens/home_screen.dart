import 'package:flutter/material.dart';
import 'package:travel_booking/services/place_service.dart';
import 'package:travel_booking/widgets/place_card.dart';
import 'package:travel_booking/widgets/loading_widget.dart';
import 'package:travel_booking/models/place.dart';
import 'package:travel_booking/features/auth/screens/login_screen.dart';
import 'package:travel_booking/features/profile/screens/profile_screen.dart';
import 'package:travel_booking/features/places/screens/map_screen.dart';
import 'package:travel_booking/features/places/screens/place_detail_screen.dart';
import 'package:travel_booking/features/booking/screens/hotel_list_booking.dart';
import 'package:travel_booking/features/chat/screens/chat_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final PlaceService _placeService = PlaceService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF003580),
        elevation: 0,
        title: const Text(
          "HUIT Booking",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_outlined, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
          // 🔹 Popup Menu xử lý Profile và Đăng xuất
          PopupMenuButton<String>(
            icon: const Icon(Icons.person_outline, color: Colors.white),
            onSelected: (value) {
              if (value == 'logout') {
                // Quay về màn hình đăng nhập và xóa sạch lịch sử stack trang
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const ManHinhDangNhap()),
                      (route) => false,
                );
              } else if (value == 'profile') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Row(children: [Icon(Icons.account_circle_outlined), SizedBox(width: 10), Text('Hồ sơ')]),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(children: [Icon(Icons.logout, color: Colors.red), SizedBox(width: 10), Text('Đăng xuất')]),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBanner(context), // Truyền context để chuyển trang
            const SizedBox(height: 24),
            _buildSectionHeader("Địa điểm được quan tâm hiện nay"),
            _buildPopularDestinations(),
            _buildWhyChooseUs(),
            _buildOffers(),
            _buildGeniusBanner(),
            _buildQuickPlanning(),
            const SizedBox(height: 24),
            _buildSectionHeader("Nhà ở mà khách yêu thích"),
            const SizedBox(height: 12),
            _buildFavoritePlaces(_placeService),
            const SizedBox(height: 30),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MapScreen()),
          );
        },
        backgroundColor: const Color(0xFF003580),
        child: const Icon(Icons.map, color: Colors.white),
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  // 🔹 Thanh tìm kiếm: Khi bấm vào sẽ nhảy sang trang danh sách khách sạn
  Widget _buildSearchBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF003580),
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HotelListBooking()));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange, width: 3),
          ),
          child: const Row(
            children: [
              Icon(Icons.bed_outlined, color: Colors.grey),
              SizedBox(width: 10),
              Text("Bạn muốn đến đâu?", style: TextStyle(color: Colors.grey, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopularDestinations() {
    final List<Map<String, String>> destinations = [
      {'name': 'Đà Lạt', 'img': 'assets/images/DaLat.jpg'},
      {'name': 'Hà Nội', 'img': 'assets/images/HaNoi.jpg'},
      {'name': 'TP. HCM', 'img': 'assets/images/HCM.jpg'},
      {'name': 'Nha Trang', 'img': 'assets/images/NhaTrang.jpg'},
      {'name': 'Vũng Tàu', 'img': 'assets/images/VungTau.jpg'},
    ];

    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16, top: 15),
        itemCount: destinations.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(destinations[index]['img']!, width: 70, height: 70, fit: BoxFit.cover),
                ),
                const SizedBox(height: 8),
                Text(destinations[index]['name']!, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWhyChooseUs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Text("Vì sao lại chọn HUIT Booking?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 140,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _whyCard(Icons.edit_calendar, "Đặt bây giờ", "Thanh toán tại chỗ"),
              _whyCard(Icons.thumb_up_alt_outlined, "300tr đánh giá", "Đáng tin cậy"),
              _whyCard(Icons.support_agent, "Hỗ trợ 24/7", "Luôn sẵn sàng"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _whyCard(IconData icon, String title, String sub) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue, size: 28),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text(sub, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildOffers() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("An tâm nghỉ dưỡng", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("Giảm ít nhất 15% hôm nay.", style: TextStyle(fontSize: 13)),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset('assets/images/VungTau.jpg', width: 80, height: 80, fit: BoxFit.cover),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGeniusBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
      child: const Row(
        children: [
          Expanded(child: Text("Đăng nhập để tiết kiệm 10% với Genius.", style: TextStyle(fontWeight: FontWeight.bold))),
          Icon(Icons.card_giftcard, size: 40, color: Colors.blue),
        ],
      ),
    );
  }

  Widget _buildQuickPlanning() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 4),
          child: Text("Kế hoạch nhanh chóng", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _planningCard("Đà Lạt", "234 km", "assets/images/DaLat.jpg"),
              _planningCard("Vũng Tàu", "95 km", "assets/images/VungTau.jpg"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _planningCard(String name, String dist, String img) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset(img, width: 80, height: 80, fit: BoxFit.cover)),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildFavoritePlaces(PlaceService service) {
    return FutureBuilder<List<Place>>(
      future: service.getPlaces(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const LoadingWidget();
        if (!snapshot.hasData) return const SizedBox();

        return SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final place = snapshot.data![index];
              return SizedBox(
                width: 200,
                child: PlaceCard(
                  place: place,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PlaceDetailScreen(place: place)));
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}