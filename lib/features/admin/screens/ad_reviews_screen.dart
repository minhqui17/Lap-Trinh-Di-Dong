import 'package:flutter/material.dart';

// Màn hình quản lý đánh giá
// Chức năng: xem đánh giá, lọc sao, phản hồi đánh giá
class AdReviewsScreen extends StatefulWidget {
  const AdReviewsScreen({super.key});

  @override
  State<AdReviewsScreen> createState() => _AdReviewsScreenState();
}

class _AdReviewsScreenState extends State<AdReviewsScreen> {
  // Lọc theo số sao: 0 = tất cả
  int _filterStar = 0;

  // Dữ liệu mẫu các đánh giá
  final List<Map<String, dynamic>> _reviews = [
    {'author': 'Nguyễn Văn A', 'avatar': 'NV', 'place': 'Phú Quốc', 'stars': 5, 'text': 'Địa điểm tuyệt vời! Biển xanh, cát trắng rất đẹp.', 'time': '2 giờ trước', 'replied': false, 'reply': ''},
    {'author': 'Trần Thị B', 'avatar': 'TB', 'place': 'Đà Lạt', 'stars': 4, 'text': 'Thời tiết mát mẻ, phong cảnh đẹp. Đường đến hơi khó.', 'time': '1 ngày trước', 'replied': true, 'reply': 'Cảm ơn bạn! Chúng tôi sẽ cải thiện tốt hơn.'},
    {'author': 'Lê Minh C', 'avatar': 'LM', 'place': 'Nha Trang', 'stars': 3, 'text': 'Tạm được, biển hơi đông khách.', 'time': '2 ngày trước', 'replied': false, 'reply': ''},
    {'author': 'Võ Thị F', 'avatar': 'VT', 'place': 'Sapa', 'stars': 2, 'text': 'Thất vọng vì thông tin không khớp thực tế.', 'time': '4 ngày trước', 'replied': false, 'reply': ''},
    {'author': 'Đặng Minh G', 'avatar': 'DM', 'place': 'Đà Nẵng', 'stars': 5, 'text': 'Rất hài lòng! Sẽ giới thiệu cho bạn bè.', 'time': '5 ngày trước', 'replied': false, 'reply': ''},
  ];

  // Lọc theo số sao
  List<Map<String, dynamic>> get _filtered {
    if (_filterStar == 0) return _reviews;
    return _reviews.where((r) => r['stars'] == _filterStar).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        children: [
          // Thanh lọc theo sao
          _buildStarFilter(),

          // Danh sách đánh giá
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                // Lấy index thực trong _reviews để cập nhật đúng phần tử
                final realIndex = _reviews.indexOf(_filtered[index]);
                return _buildReviewCard(_filtered[index], realIndex);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Chip lọc theo số sao: Tất cả / 5★ / 4★ / 3★ / 2★ / 1★
  Widget _buildStarFilter() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Chip "Tất cả"
          _buildFilterChip('Tất cả', 0),
          // Chip từng số sao
          ...List.generate(5, (i) => _buildFilterChip('${5 - i}★', 5 - i)),
        ],
      ),
    );
  }

  // Một chip trong thanh lọc
  Widget _buildFilterChip(String label, int star) {
    final isSelected = _filterStar == star;
    return InkWell(
      onTap: () => setState(() => _filterStar = star),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A56DB) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // Card 1 đánh giá
  Widget _buildReviewCard(Map<String, dynamic> review, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dòng đầu: avatar + tên + địa điểm + thời gian
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFFE6F1FB),
                  child: Text(
                    review['avatar'],
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF185FA5)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${review['author']} · ${review['place']}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      // Hiển thị số sao
                      Text(
                        '★' * (review['stars'] as int) + '☆' * (5 - (review['stars'] as int)),
                        style: const TextStyle(fontSize: 14, color: Color(0xFFBA7517)),
                      ),
                    ],
                  ),
                ),
                Text(review['time'], style: TextStyle(fontSize: 11, color: Colors.grey[400])),
              ],
            ),
            const SizedBox(height: 10),

            // Nội dung đánh giá
            Text(review['text'], style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 10),

            // Nếu đã phản hồi → hiển thị reply
            if (review['replied']) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F1FB).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: const Border(left: BorderSide(color: Color(0xFF1A56DB), width: 3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Phản hồi từ Admin:',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1A56DB)),
                    ),
                    const SizedBox(height: 4),
                    Text(review['reply'], style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ),
            ] else ...[
              // Nếu chưa phản hồi → hiện nút
              ElevatedButton.icon(
                onPressed: () => _showReplyDialog(index),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A56DB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.reply, size: 14),
                label: const Text('Phản hồi', style: TextStyle(fontSize: 12)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Hộp thoại nhập phản hồi
  void _showReplyDialog(int index) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Phản hồi đánh giá'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Hiển thị nội dung đánh giá gốc để tham khảo
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '"${_reviews[index]['text']}"',
                style: TextStyle(fontSize: 12, color: Colors.grey[600], fontStyle: FontStyle.italic),
              ),
            ),
            const SizedBox(height: 12),
            // Ô nhập phản hồi
            TextField(
              controller: ctrl,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Nhập phản hồi...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Huỷ')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A56DB),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (ctrl.text.isNotEmpty) {
                // Lưu phản hồi vào dữ liệu
                setState(() {
                  _reviews[index]['replied'] = true;
                  _reviews[index]['reply'] = ctrl.text;
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Gửi'),
          ),
        ],
      ),
    );
  }
}