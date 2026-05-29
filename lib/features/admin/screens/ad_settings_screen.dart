import 'package:flutter/material.dart';

// Màn hình cài đặt hệ thống
// Chức năng: cài đặt chung, cổng thanh toán, thông báo
class AdSettingsScreen extends StatefulWidget {
  const AdSettingsScreen({super.key});

  @override
  State<AdSettingsScreen> createState() => _AdSettingsScreenState();
}

class _AdSettingsScreenState extends State<AdSettingsScreen> {
  // Tab đang chọn
  int _tabIndex = 0;
  final List<String> _tabs = ['Chung', 'Thanh toán', 'Thông báo'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        children: [
          // Thanh tab
          _buildTabBar(),

          // Nội dung tab tương ứng
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: [
                _buildGeneralTab(),
                _buildPaymentTab(),
                _buildNotifTab(),
              ][_tabIndex],
            ),
          ),
        ],
      ),
    );
  }

  // Thanh tab: Chung / Thanh toán / Thông báo
  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: Row(
        children: _tabs.asMap().entries.map((entry) {
          final isSelected = entry.key == _tabIndex;
          return Expanded(
            child: InkWell(
              onTap: () => setState(() => _tabIndex = entry.key),
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

  // ── TAB CHUNG ──────────────────────────────────────────────────────────────
  Widget _buildGeneralTab() {
    return _SettingsTab();
  }

  // ── TAB THANH TOÁN ─────────────────────────────────────────────────────────
  Widget _buildPaymentTab() {
    return _PaymentTab();
  }

  // ── TAB THÔNG BÁO ──────────────────────────────────────────────────────────
  Widget _buildNotifTab() {
    return _NotifTab();
  }
}

// ── Widget tab Chung ──────────────────────────────────────────────────────────
class _SettingsTab extends StatefulWidget {
  @override
  State<_SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<_SettingsTab> {
  final _nameCtrl = TextEditingController(text: 'VietTravel');
  final _emailCtrl = TextEditingController(text: 'admin@viettravel.vn');
  final _commCtrl = TextEditingController(text: '10');
  bool _maintenance = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Card thông tin ứng dụng
        _buildCard(
          title: 'Thông tin ứng dụng',
          child: Column(
            children: [
              _buildTextField('Tên ứng dụng', _nameCtrl),
              const SizedBox(height: 12),
              _buildTextField('Email liên hệ', _emailCtrl),
              const SizedBox(height: 12),
              _buildTextField('Hoa hồng (%)', _commCtrl, isNumber: true),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Card vận hành
        _buildCard(
          title: 'Vận hành',
          child: _buildSwitchRow(
            'Chế độ bảo trì',
            'Tạm dừng ứng dụng để bảo trì',
            _maintenance,
                (v) => setState(() => _maintenance = v),
          ),
        ),
        const SizedBox(height: 20),

        // Nút lưu
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A56DB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã lưu thay đổi'), backgroundColor: Colors.green),
              );
            },
            child: const Text('Lưu thay đổi', style: TextStyle(fontSize: 15)),
          ),
        ),
      ],
    );
  }
}

// ── Widget tab Thanh toán ─────────────────────────────────────────────────────
class _PaymentTab extends StatefulWidget {
  @override
  State<_PaymentTab> createState() => _PaymentTabState();
}

class _PaymentTabState extends State<_PaymentTab> {
  // Danh sách cổng thanh toán + trạng thái bật/tắt
  final List<Map<String, dynamic>> _gateways = [
    {'name': 'MoMo', 'icon': '💜', 'fee': '1.5%', 'active': true},
    {'name': 'VNPay', 'icon': '💙', 'fee': '1.2%', 'active': true},
    {'name': 'ZaloPay', 'icon': '🟦', 'fee': '1.0%', 'active': false},
    {'name': 'Stripe (Thẻ tín dụng)', 'icon': '💳', 'fee': '2.9% + ₫5K', 'active': true},
    {'name': 'Chuyển khoản ngân hàng', 'icon': '🏦', 'fee': '0%', 'active': true},
  ];

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      title: 'Cổng thanh toán',
      child: Column(
        children: _gateways.asMap().entries.map((entry) {
          final g = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                // Icon
                Text(g['icon'], style: const TextStyle(fontSize: 26)),
                const SizedBox(width: 12),
                // Tên + phí
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(g['name'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      Text(
                        'Phí giao dịch: ${g['fee']}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                // Switch bật/tắt
                Switch(
                  value: g['active'],
                  onChanged: (v) => setState(() => _gateways[entry.key]['active'] = v),
                  activeColor: const Color(0xFF1A56DB),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Widget tab Thông báo ──────────────────────────────────────────────────────
class _NotifTab extends StatefulWidget {
  @override
  State<_NotifTab> createState() => _NotifTabState();
}

class _NotifTabState extends State<_NotifTab> {
  // Trạng thái từng loại thông báo
  bool _newBooking = true;
  bool _paySuccess = true;
  bool _newReview = true;
  bool _newCustomer = false;
  bool _weeklyReport = true;
  bool _lowRating = true;

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      title: 'Cấu hình thông báo',
      child: Column(
        children: [
          _buildSwitchRow('Đặt chỗ mới', 'Khi có đơn đặt chỗ mới', _newBooking, (v) => setState(() => _newBooking = v)),
          _buildSwitchRow('Thanh toán thành công', 'Khi giao dịch hoàn thành', _paySuccess, (v) => setState(() => _paySuccess = v)),
          _buildSwitchRow('Đánh giá mới', 'Khi có đánh giá từ khách', _newReview, (v) => setState(() => _newReview = v)),
          _buildSwitchRow('Khách hàng mới', 'Khi có tài khoản đăng ký', _newCustomer, (v) => setState(() => _newCustomer = v)),
          _buildSwitchRow('Đánh giá thấp', 'Cảnh báo khi có 1-2 sao', _lowRating, (v) => setState(() => _lowRating = v)),
          _buildSwitchRow('Báo cáo hàng tuần', 'Email tóm tắt doanh thu', _weeklyReport, (v) => setState(() => _weeklyReport = v)),
        ],
      ),
    );
  }
}

// ── Shared helpers (dùng chung cho cả 3 tab) ─────────────────────────────────

// Card có tiêu đề + nội dung
Widget _buildCard({required String title, required Widget child}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        const Divider(height: 0),
        const SizedBox(height: 12),
        child,
      ],
    ),
  );
}

// Ô nhập liệu có label
Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      const SizedBox(height: 4),
      TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
        ),
      ),
    ],
  );
}

// Dòng switch có tiêu đề + mô tả
Widget _buildSwitchRow(String label, String subtitle, bool value, void Function(bool) onChanged) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
            ],
          ),
        ),
        Switch(value: value, onChanged: onChanged, activeColor: const Color(0xFF1A56DB)),
      ],
    ),
  );
}