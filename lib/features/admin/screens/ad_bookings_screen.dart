import 'package:flutter/material.dart';
import 'package:travel_booking/services/api_service.dart';

// Màn hình quản lý đặt chỗ
// Chức năng: xem danh sách đơn, lọc theo trạng thái, xác nhận / huỷ đơn
class AdBookingsScreen extends StatefulWidget {
  const AdBookingsScreen({super.key});

  @override
  State<AdBookingsScreen> createState() => _AdBookingsScreenState();
}

class _AdBookingsScreenState extends State<AdBookingsScreen> {
  // Tab đang chọn: 0=Tất cả, 1=Xác nhận, 2=Chờ, 3=Huỷ
  int _selectedTab = 0;

  // Dữ liệu lấy từ API
  List<Map<String, dynamic>> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    setState(() => _isLoading = true);
    final data = await ApiService.getBookings();
    if (mounted) {
      setState(() {
        _bookings = data;
        _isLoading = false;
      });
    }
  }

  // Các tab lọc
  final List<String> _tabs = ['Tất cả', 'Xác nhận', 'Chờ xử lý', 'Đã huỷ'];
  final List<String?> _tabStatus = [null, 'confirmed', 'pending', 'cancelled'];

  // Lấy danh sách đơn theo tab đang chọn
  List<Map<String, dynamic>> get _filtered {
    final status = _tabStatus[_selectedTab];
    if (status == null) return _bookings;
    return _bookings.where((b) => b['status'] == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : Column(
        children: [
          // Thanh tab lọc trạng thái
          _buildTabBar(),

          // Danh sách đơn đặt chỗ
          Expanded(
            child: _filtered.isEmpty
                ? const Center(child: Text('Không có đơn nào', style: TextStyle(color: Colors.grey)))
                : RefreshIndicator(
                    onRefresh: _loadBookings,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filtered.length,
                      itemBuilder: (context, index) {
                        return _buildBookingCard(_filtered[index]);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // Thanh tab: Tất cả / Xác nhận / Chờ xử lý / Đã huỷ
  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: Row(
        children: _tabs.asMap().entries.map((entry) {
          final isSelected = entry.key == _selectedTab;
          return Expanded(
            child: InkWell(
              onTap: () => setState(() => _selectedTab = entry.key),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? const Color(0xFF1A56DB) : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  entry.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? const Color(0xFF1A56DB) : Colors.grey[600],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Card hiển thị 1 đơn đặt chỗ
  Widget _buildBookingCard(Map<String, dynamic> booking) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dòng đầu: mã đơn + badge trạng thái
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  booking['id'],
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                ),
                _buildStatusBadge(booking['status']),
              ],
            ),
            const Divider(height: 16),

            // Tên khách + địa điểm
            Row(
              children: [
                const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(booking['name'], style: const TextStyle(fontSize: 13)),
                const Spacer(),
                const Icon(Icons.place_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(booking['place'], style: const TextStyle(fontSize: 13)),
              ],
            ),
            const SizedBox(height: 8),

            // Ngày check-in → check-out + số khách
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  '${booking['checkin']} → ${booking['checkout']}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const Spacer(),
                const Icon(Icons.people_outline, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text('${booking['guests']} khách', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
            const SizedBox(height: 10),

            // Tổng tiền + nút hành động (chỉ hiện nếu đang chờ)
            Row(
              children: [
                Text(
                  '₫${_formatMoney(booking['total'])}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A56DB)),
                ),
                const Spacer(),

                // Nếu đơn đang chờ → hiện nút Xác nhận và Huỷ
                if (booking['status'] == 'pending') ...[
                  OutlinedButton(
                    onPressed: () => _updateStatus(booking, 'cancelled'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Huỷ', style: TextStyle(fontSize: 12)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _updateStatus(booking, 'confirmed'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Xác nhận', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Badge màu theo trạng thái
  Widget _buildStatusBadge(String status) {
    Color color;
    String label;
    switch (status) {
      case 'confirmed':
        color = Colors.green;
        label = 'Đã xác nhận';
        break;
      case 'pending':
        color = Colors.orange;
        label = 'Chờ xử lý';
        break;
      default:
        color = Colors.red;
        label = 'Đã huỷ';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }

  // Cập nhật trạng thái đơn (xác nhận hoặc huỷ) qua API
  void _updateStatus(Map<String, dynamic> booking, String newStatus) async {
    bool success = await ApiService.updateBookingStatus(booking['id'], newStatus);
    if (success && mounted) {
      setState(() => booking['status'] = newStatus);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(newStatus == 'confirmed' ? 'Đã xác nhận đơn' : 'Đã huỷ đơn')),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi cập nhật, vui lòng thử lại!')),
      );
    }
  }

  // Format tiền: 3600000 → 3.6M
  String _formatMoney(int amount) {
    if (amount >= 1000000) return '${(amount / 1000000).toStringAsFixed(1)}M';
    return '${(amount / 1000).toStringAsFixed(0)}K';
  }
}