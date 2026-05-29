import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// Màn hình Dashboard - trang tổng quan của admin
// Hiển thị: số liệu tổng hợp + biểu đồ doanh thu + đặt chỗ gần đây
class AdDashboardScreen extends StatelessWidget {
  const AdDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề trang
            const Text(
              'Tổng quan',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Chào mừng trở lại, Admin',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),

            // 4 ô số liệu nằm ngang
            _buildMetricRow(context),
            const SizedBox(height: 20),

            // Biểu đồ doanh thu theo tháng
            _buildRevenueChart(),
            const SizedBox(height: 16),

            // Danh sách đặt chỗ gần đây
            _buildRecentBookings(),
          ],
        ),
      ),
    );
  }

  // Widget hiển thị 4 ô số liệu: doanh thu, đặt chỗ, khách hàng, đánh giá
  Widget _buildMetricRow(BuildContext context) {
    // Dữ liệu mẫu cho 4 metric
    final metrics = [
      {'label': 'Doanh thu', 'value': '₫248.5M', 'delta': '+12.4%', 'up': true, 'color': const Color(0xFF1A56DB), 'icon': Icons.trending_up},
      {'label': 'Đặt chỗ', 'value': '1,284', 'delta': '+8.1%', 'up': true, 'color': const Color(0xFF0F6E56), 'icon': Icons.calendar_today},
      {'label': 'Khách hàng', 'value': '347', 'delta': '+5.7%', 'up': true, 'color': const Color(0xFF854F0B), 'icon': Icons.person_add},
      {'label': 'Đánh giá TB', 'value': '4.7 ★', 'delta': '-0.1', 'up': false, 'color': const Color(0xFF993C1D), 'icon': Icons.star},
    ];

    final isMobile = MediaQuery.of(context).size.width < 600;

    if (isMobile) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.4,
        ),
        itemCount: metrics.length,
        itemBuilder: (context, index) {
          final m = metrics[index];
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        m['label'] as String,
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(m['icon'] as IconData, size: 16, color: m['color'] as Color),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  m['value'] as String,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Icon(
                      (m['up'] as bool) ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 11,
                      color: (m['up'] as bool) ? Colors.green : Colors.red,
                    ),
                    Text(
                      m['delta'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        color: (m['up'] as bool) ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }

    return Row(
      children: metrics.map((m) {
        // Mỗi ô metric chiếm phần bằng nhau (flex: 1)
        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon và label
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      m['label'] as String,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Icon(m['icon'] as IconData, size: 18, color: m['color'] as Color),
                  ],
                ),
                const SizedBox(height: 8),

                // Giá trị chính (số lớn)
                Text(
                  m['value'] as String,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),

                // Phần trăm thay đổi so với tháng trước
                Row(
                  children: [
                    Icon(
                      (m['up'] as bool) ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 12,
                      color: (m['up'] as bool) ? Colors.green : Colors.red,
                    ),
                    Text(
                      m['delta'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        color: (m['up'] as bool) ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // Widget biểu đồ đường doanh thu 12 tháng
  Widget _buildRevenueChart() {
    // Dữ liệu doanh thu mỗi tháng (đơn vị: triệu đồng)
    final List<double> monthlyData = [148, 162, 155, 175, 183, 210, 225, 198, 215, 238, 248, 260];

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
          const Text(
            'Doanh thu 12 tháng',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                // Tắt đường lưới dọc, chỉ giữ ngang
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: Colors.grey.withOpacity(0.1),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  // Trục dưới: hiển thị T1 → T12
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        const months = ['T1','T2','T3','T4','T5','T6','T7','T8','T9','T10','T11','T12'];
                        return Text(
                          months[value.toInt()],
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                  // Trục trái: hiển thị giá trị (đơn vị M)
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      getTitlesWidget: (value, _) => Text(
                        '${value.toInt()}M',
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ),
                  ),
                  // Tắt trục phải và trên
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true, // Đường cong mượt
                    color: const Color(0xFF1A56DB),
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false), // Ẩn chấm tròn
                    // Tô màu nhạt phía dưới đường
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF1A56DB).withOpacity(0.08),
                    ),
                    // Chuyển list data thành FlSpot (x, y)
                    spots: monthlyData
                        .asMap()
                        .entries
                        .map((e) => FlSpot(e.key.toDouble(), e.value))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget danh sách đặt chỗ gần đây
  Widget _buildRecentBookings() {
    // Dữ liệu mẫu các đơn đặt chỗ
    final bookings = [
      {'name': 'Nguyễn Văn A', 'place': 'Phú Quốc', 'date': '03/05', 'status': 'confirmed'},
      {'name': 'Trần Thị B', 'place': 'Đà Lạt', 'date': '03/05', 'status': 'pending'},
      {'name': 'Lê Minh C', 'place': 'Nha Trang', 'date': '02/05', 'status': 'confirmed'},
      {'name': 'Phạm Thu D', 'place': 'Hà Nội', 'date': '02/05', 'status': 'cancelled'},
    ];

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
          const Text(
            'Đặt chỗ gần đây',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          // Vẽ từng dòng trong danh sách
          ...bookings.map((b) => _buildBookingRow(b)),
        ],
      ),
    );
  }

  // Widget 1 dòng đặt chỗ
  Widget _buildBookingRow(Map<String, dynamic> booking) {
    // Xác định màu badge dựa theo trạng thái
    Color statusColor;
    String statusLabel;
    switch (booking['status']) {
      case 'confirmed':
        statusColor = Colors.green;
        statusLabel = 'Xác nhận';
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusLabel = 'Chờ xử lý';
        break;
      default:
        statusColor = Colors.red;
        statusLabel = 'Đã huỷ';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Tên khách hàng
          Expanded(
            child: Text(
              booking['name'],
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
          // Địa điểm
          Expanded(
            child: Text(
              booking['place'],
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ),
          // Ngày đặt
          Text(
            booking['date'],
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
          const SizedBox(width: 12),
          // Badge trạng thái
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              statusLabel,
              style: TextStyle(fontSize: 11, color: statusColor, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}