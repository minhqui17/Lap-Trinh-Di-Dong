import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003580),
        title: const Text("Hồ sơ của tôi", style: TextStyle(color: Colors.white)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Phần Header: Avatar và Tên
            Container(
              color: const Color(0xFF003580),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: const Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 60, color: Color(0xFF003580)),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Sinh viên HUIT",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "sinhvien@huit.edu.vn",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Các mục tùy chọn
            _buildProfileItem(Icons.card_giftcard, "Phần thưởng & Ưu đãi", "Genius Cấp 1"),
            _buildProfileItem(Icons.account_balance_wallet_outlined, "Ví", "0 đ"),
            _buildProfileItem(Icons.favorite_border, "Danh sách yêu thích", ""),
            _buildProfileItem(Icons.settings_outlined, "Cài đặt", ""),
            _buildProfileItem(Icons.help_outline, "Hỗ trợ khách hàng", ""),

            const Divider(),

            // Nút đăng xuất
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Đăng xuất", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onTap: () {
                // Xử lý đăng xuất ở đây
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String trailing) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing.isNotEmpty)
            Text(trailing, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
      onTap: () {},
    );
  }
}