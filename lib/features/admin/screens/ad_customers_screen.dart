import 'package:flutter/material.dart';

// Màn hình quản lý khách hàng
// Chức năng: xem danh sách, tìm kiếm, xem chi tiết hồ sơ
class AdCustomersScreen extends StatefulWidget {
  const AdCustomersScreen({super.key});

  @override
  State<AdCustomersScreen> createState() => _AdCustomersScreenState();
}

class _AdCustomersScreenState extends State<AdCustomersScreen> {
  String _searchQuery = '';

  // Dữ liệu mẫu khách hàng
  final List<Map<String, dynamic>> _customers = [
    {'name': 'Nguyễn Văn A', 'avatar': 'NV', 'email': 'a.nguyen@gmail.com', 'phone': '0901 234 567', 'bookings': 12, 'spent': 28400000, 'tier': 'VIP', 'joined': '01/2024'},
    {'name': 'Trần Thị B', 'avatar': 'TB', 'email': 'b.tran@gmail.com', 'phone': '0912 345 678', 'bookings': 5, 'spent': 9200000, 'tier': 'Thường', 'joined': '03/2024'},
    {'name': 'Lê Minh C', 'avatar': 'LM', 'email': 'c.le@gmail.com', 'phone': '0923 456 789', 'bookings': 8, 'spent': 15600000, 'tier': 'VIP', 'joined': '11/2023'},
    {'name': 'Phạm Thu D', 'avatar': 'PT', 'email': 'd.pham@gmail.com', 'phone': '0934 567 890', 'bookings': 2, 'spent': 3000000, 'tier': 'Mới', 'joined': '04/2025'},
    {'name': 'Hoàng Văn E', 'avatar': 'HV', 'email': 'e.hoang@gmail.com', 'phone': '0945 678 901', 'bookings': 15, 'spent': 42000000, 'tier': 'VIP', 'joined': '06/2023'},
  ];

  // Lọc theo tên hoặc email
  List<Map<String, dynamic>> get _filtered {
    if (_searchQuery.isEmpty) return _customers;
    return _customers.where((c) {
      return c['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c['email'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        children: [
          // Ô tìm kiếm
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm theo tên hoặc email...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),

          // Số lượng kết quả
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${_filtered.length} khách hàng',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ),
          ),

          // Danh sách khách hàng
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                return _buildCustomerCard(_filtered[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Card 1 khách hàng
  Widget _buildCustomerCard(Map<String, dynamic> customer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: InkWell(
        // Bấm vào card → xem chi tiết
        onTap: () => _showProfile(customer),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Avatar chữ cái đầu tên
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFFE6F1FB),
                child: Text(
                  customer['avatar'],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF185FA5),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Tên + email
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer['name'],
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      customer['email'],
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 4),
                    // Số đặt chỗ + tổng chi tiêu
                    Row(
                      children: [
                        const Icon(Icons.receipt_outlined, size: 13, color: Colors.grey),
                        const SizedBox(width: 3),
                        Text(
                          '${customer['bookings']} đơn',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.payments_outlined, size: 13, color: Colors.grey),
                        const SizedBox(width: 3),
                        Text(
                          '₫${_formatMoney(customer['spent'])}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Badge hạng khách hàng
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildTierBadge(customer['tier']),
                  const SizedBox(height: 6),
                  Text(
                    'Từ ${customer['joined']}',
                    style: TextStyle(fontSize: 10, color: Colors.grey[400]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Badge hạng: VIP / Thường / Mới
  Widget _buildTierBadge(String tier) {
    Color color;
    switch (tier) {
      case 'VIP':
        color = const Color(0xFFBA7517);
        break;
      case 'Mới':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(tier, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }

  // Hộp thoại xem hồ sơ khách hàng
  void _showProfile(Map<String, dynamic> customer) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar lớn
            CircleAvatar(
              radius: 36,
              backgroundColor: const Color(0xFFE6F1FB),
              child: Text(
                customer['avatar'],
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF185FA5)),
              ),
            ),
            const SizedBox(height: 10),

            // Tên + hạng
            Text(customer['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            _buildTierBadge(customer['tier']),
            const SizedBox(height: 16),

            // Thống kê nhỏ
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMiniStat('Đặt chỗ', '${customer['bookings']}'),
                _buildMiniStat('Chi tiêu', '₫${_formatMoney(customer['spent'])}'),
                _buildMiniStat('Tham gia', customer['joined']),
              ],
            ),
            const Divider(height: 24),

            // Thông tin liên hệ
            _buildInfoRow(Icons.email_outlined, customer['email']),
            const SizedBox(height: 6),
            _buildInfoRow(Icons.phone_outlined, customer['phone']),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  // Ô thống kê nhỏ trong dialog
  Widget _buildMiniStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }

  // Dòng thông tin có icon
  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  String _formatMoney(int amount) {
    if (amount >= 1000000) return '${(amount / 1000000).toStringAsFixed(1)}M';
    return '${(amount / 1000).toStringAsFixed(0)}K';
  }
}