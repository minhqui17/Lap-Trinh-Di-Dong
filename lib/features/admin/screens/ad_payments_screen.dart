import 'package:flutter/material.dart';

// Màn hình quản lý thanh toán
// Chức năng: xem lịch sử giao dịch, lọc theo phương thức thanh toán
class AdPaymentsScreen extends StatefulWidget {
  const AdPaymentsScreen({super.key});

  @override
  State<AdPaymentsScreen> createState() => _AdPaymentsScreenState();
}

class _AdPaymentsScreenState extends State<AdPaymentsScreen> {
  // Phương thức thanh toán đang lọc
  String _selectedMethod = 'Tất cả';

  // Dữ liệu mẫu lịch sử giao dịch
  final List<Map<String, dynamic>> _transactions = [
    {'id': 'GD89012', 'name': 'Nguyễn Văn A', 'method': 'MoMo', 'amount': 3600000, 'time': '03/05 14:32', 'status': 'success'},
    {'id': 'GD89011', 'name': 'Lê Minh C', 'method': 'VNPay', 'amount': 2250000, 'time': '02/05 09:15', 'status': 'success'},
    {'id': 'GD89010', 'name': 'Phạm Thu D', 'method': 'Thẻ tín dụng', 'amount': 1000000, 'time': '02/05 08:40', 'status': 'refunded'},
    {'id': 'GD89009', 'name': 'Hoàng Văn E', 'method': 'Chuyển khoản', 'amount': 4500000, 'time': '01/05 16:22', 'status': 'success'},
    {'id': 'GD89008', 'name': 'Võ Thị F', 'method': 'MoMo', 'amount': 1950000, 'time': '01/05 11:05', 'status': 'pending'},
    {'id': 'GD89007', 'name': 'Đặng Minh G', 'method': 'Thẻ tín dụng', 'amount': 2100000, 'time': '30/04 15:30', 'status': 'success'},
  ];

  // Các phương thức thanh toán để lọc
  final List<String> _methods = ['Tất cả', 'MoMo', 'VNPay', 'Thẻ tín dụng', 'Chuyển khoản'];

  // Lọc giao dịch theo phương thức
  List<Map<String, dynamic>> get _filtered {
    if (_selectedMethod == 'Tất cả') return _transactions;
    return _transactions.where((t) => t['method'] == _selectedMethod).toList();
  }

  // Tính tổng doanh thu (chỉ tính giao dịch thành công)
  int get _totalRevenue {
    return _transactions
        .where((t) => t['status'] == 'success')
        .fold(0, (sum, t) => sum + (t['amount'] as int));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        children: [
          // Ô tổng doanh thu
          _buildRevenueBox(),

          // Các chip lọc phương thức
          _buildMethodFilter(),

          // Danh sách giao dịch
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                return _buildTransactionCard(_filtered[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Ô hiển thị tổng doanh thu tháng
  Widget _buildRevenueBox() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A56DB), Color(0xFF0F6E56)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Doanh thu tháng này',
            style: TextStyle(fontSize: 13, color: Colors.white70),
          ),
          const SizedBox(height: 6),
          Text(
            '₫${_formatMoney(_totalRevenue)}',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Text(
            'Chỉ tính giao dịch thành công',
            style: TextStyle(fontSize: 11, color: Colors.white54),
          ),
        ],
      ),
    );
  }

  // Các chip chọn phương thức thanh toán
  Widget _buildMethodFilter() {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _methods.length,
        itemBuilder: (context, index) {
          final method = _methods[index];
          final isSelected = method == _selectedMethod;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(method),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedMethod = method),
              selectedColor: const Color(0xFF1A56DB),
              labelStyle: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
            ),
          );
        },
      ),
    );
  }

  // Card 1 giao dịch
  Widget _buildTransactionCard(Map<String, dynamic> tx) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Icon phương thức thanh toán
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _methodColor(tx['method']).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(_methodIcon(tx['method']), style: const TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(width: 12),

            // Tên khách + mã giao dịch
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tx['name'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(
                    '${tx['id']} · ${tx['method']}',
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 2),
                  Text(tx['time'], style: TextStyle(fontSize: 11, color: Colors.grey[400])),
                ],
              ),
            ),

            // Số tiền + trạng thái
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₫${_formatMoney(tx['amount'])}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                _buildStatusBadge(tx['status']),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Icon emoji theo phương thức
  String _methodIcon(String method) {
    switch (method) {
      case 'MoMo': return '💜';
      case 'VNPay': return '💙';
      case 'Thẻ tín dụng': return '💳';
      default: return '🏦';
    }
  }

  // Màu theo phương thức
  Color _methodColor(String method) {
    switch (method) {
      case 'MoMo': return const Color(0xFFAE1F75);
      case 'VNPay': return const Color(0xFF0B3E8F);
      case 'Thẻ tín dụng': return const Color(0xFF635BFF);
      default: return const Color(0xFF0F6E56);
    }
  }

  // Badge trạng thái giao dịch
  Widget _buildStatusBadge(String status) {
    Color color;
    String label;
    switch (status) {
      case 'success':
        color = Colors.green;
        label = 'Thành công';
        break;
      case 'pending':
        color = Colors.orange;
        label = 'Đang xử lý';
        break;
      case 'refunded':
        color = Colors.blue;
        label = 'Hoàn tiền';
        break;
      default:
        color = Colors.red;
        label = 'Thất bại';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
    );
  }

  // Format tiền
  String _formatMoney(int amount) {
    if (amount >= 1000000) return '${(amount / 1000000).toStringAsFixed(1)}M';
    return '${(amount / 1000).toStringAsFixed(0)}K';
  }
}