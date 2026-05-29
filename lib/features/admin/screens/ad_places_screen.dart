import 'package:flutter/material.dart';

// Màn hình quản lý địa điểm
// Chức năng: xem danh sách, thêm, sửa, xoá địa điểm
class AdPlacesScreen extends StatefulWidget {
  const AdPlacesScreen({super.key});

  @override
  State<AdPlacesScreen> createState() => _AdPlacesScreenState();
}

class _AdPlacesScreenState extends State<AdPlacesScreen> {
  // Ô tìm kiếm
  String _searchQuery = '';

  // Dữ liệu mẫu danh sách địa điểm
  final List<Map<String, dynamic>> _places = [
    {'icon': '🏙️', 'name': 'Hà Nội', 'region': 'Miền Bắc', 'type': 'Thành phố', 'price': 500000, 'rating': 4.7, 'bookings': 284, 'active': true},
    {'icon': '🏖️', 'name': 'Nha Trang', 'region': 'Miền Trung', 'type': 'Biển', 'price': 750000, 'rating': 4.6, 'bookings': 213, 'active': true},
    {'icon': '🌊', 'name': 'Phú Quốc', 'region': 'Miền Nam', 'type': 'Đảo', 'price': 1200000, 'rating': 4.8, 'bookings': 198, 'active': true},
    {'icon': '🏔️', 'name': 'Đà Lạt', 'region': 'Miền Nam', 'type': 'Núi', 'price': 600000, 'rating': 4.7, 'bookings': 167, 'active': true},
    {'icon': '🏙️', 'name': 'TP. Hồ Chí Minh', 'region': 'Miền Nam', 'type': 'Thành phố', 'price': 450000, 'rating': 4.5, 'bookings': 321, 'active': true},
    {'icon': '⛵', 'name': 'Hạ Long', 'region': 'Miền Bắc', 'type': 'Biển', 'price': 900000, 'rating': 4.9, 'bookings': 145, 'active': false},
  ];

  // Lọc danh sách theo từ khoá tìm kiếm
  List<Map<String, dynamic>> get _filteredPlaces {
    if (_searchQuery.isEmpty) return _places;
    return _places
        .where((p) => p['name'].toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        children: [
          // Thanh tìm kiếm + nút thêm
          _buildFilterBar(),

          // Danh sách địa điểm
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredPlaces.length,
              itemBuilder: (context, index) {
                return _buildPlaceCard(_filteredPlaces[index], index);
              },
            ),
          ),
        ],
      ),

      // Nút thêm địa điểm mới (nút tròn góc phải dưới)
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        backgroundColor: const Color(0xFF1A56DB),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Thanh lọc: ô tìm kiếm + nút thêm
  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Tìm địa điểm...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
        onChanged: (value) => setState(() => _searchQuery = value),
      ),
    );
  }

  // Card hiển thị 1 địa điểm
  Widget _buildPlaceCard(Map<String, dynamic> place, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Icon emoji địa điểm
            Text(place['icon'], style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 14),

            // Tên + thông tin
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place['name'],
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${place['region']} · ${place['type']}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // Giá
                      Text(
                        '₫${_formatPrice(place['price'])}/ngày',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 12),
                      // Đánh giá sao
                      const Icon(Icons.star, size: 13, color: Color(0xFFBA7517)),
                      Text(
                        '${place['rating']}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Cột bên phải: switch + nút
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Switch bật/tắt hiển thị địa điểm
                Switch(
                  value: place['active'],
                  onChanged: (value) {
                    setState(() => _places[index]['active'] = value);
                  },
                  activeColor: const Color(0xFF1A56DB),
                ),
                Row(
                  children: [
                    // Nút sửa
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20, color: Colors.blue),
                      onPressed: () => _showForm(place: place, index: index),
                    ),
                    // Nút xoá
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                      onPressed: () => _confirmDelete(index),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Format số tiền: 1200000 → 1.2M
  String _formatPrice(int price) {
    if (price >= 1000000) return '${(price / 1000000).toStringAsFixed(1)}M';
    if (price >= 1000) return '${(price / 1000).toStringAsFixed(0)}K';
    return price.toString();
  }

  // Hộp thoại xác nhận xoá
  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xoá địa điểm'),
        content: Text('Bạn có chắc muốn xoá "${_places[index]['name']}" không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Huỷ'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              setState(() => _places.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text('Xoá'),
          ),
        ],
      ),
    );
  }

  // Hộp thoại thêm / sửa địa điểm
  // place != null → đang sửa, place == null → đang thêm mới
  void _showForm({Map<String, dynamic>? place, int? index}) {
    final nameCtrl = TextEditingController(text: place?['name'] ?? '');
    final priceCtrl = TextEditingController(text: place?['price']?.toString() ?? '');
    String region = place?['region'] ?? 'Miền Bắc';

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(place == null ? 'Thêm địa điểm' : 'Sửa địa điểm'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tên địa điểm
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Tên địa điểm'),
              ),
              const SizedBox(height: 12),

              // Giá mỗi ngày
              TextField(
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Giá/ngày (VND)'),
              ),
              const SizedBox(height: 12),

              // Dropdown chọn khu vực
              DropdownButtonFormField<String>(
                value: region,
                decoration: const InputDecoration(labelText: 'Khu vực'),
                items: ['Miền Bắc', 'Miền Trung', 'Miền Nam']
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (v) => setDialogState(() => region = v!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Huỷ'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A56DB),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final newPlace = {
                  'icon': place?['icon'] ?? '🏙️',
                  'name': nameCtrl.text,
                  'region': region,
                  'type': place?['type'] ?? 'Thành phố',
                  'price': int.tryParse(priceCtrl.text) ?? 0,
                  'rating': place?['rating'] ?? 4.5,
                  'bookings': place?['bookings'] ?? 0,
                  'active': place?['active'] ?? true,
                };
                setState(() {
                  if (index != null) {
                    // Sửa địa điểm cũ
                    _places[index] = newPlace;
                  } else {
                    // Thêm địa điểm mới vào cuối danh sách
                    _places.add(newPlace);
                  }
                });
                Navigator.pop(context);
              },
              child: Text(place == null ? 'Thêm' : 'Lưu'),
            ),
          ],
        ),
      ),
    );
  }
}