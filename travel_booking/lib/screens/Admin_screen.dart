import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/place.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<Place> places = [
    Place(
      id: '1',
      name: 'Hà Nội',
      location: 'Việt Nam',
      rating: 4.7,
      image: 'assets/images/HaNoi.jpg',
      price: 500000,
      reviews: ["Đẹp tuyệt vời!", "Rất đáng đi"],
    ),
    Place(
      id: '2',
      name: 'Nha Trang',
      location: 'Việt Nam',
      rating: 4.7,
      image: 'assets/images/NhaTrang.jpg',
      price: 500000,
      reviews: [],
    ),
    Place(
      id: '3',
      name: 'PhuQuoc',
      location: 'Việt Nam',
      rating: 4.7,
      image: 'assets/images/PhuQuoc.jpg',
      price: 500000,
      reviews: [],
    ),
    Place(
      id: '4',
      name: 'Đà Lạt',
      location: 'Việt Nam',
      rating: 4.7,
      image: 'assets/images/DaLat.jpg',
      price: 500000,
      reviews: [],
    ),
  ];

  // 🔥 DOANH THU
  int get tongDoanhThu =>
      places.fold(0, (sum, item) => sum + item.price);

  // 🔥 DATA BIỂU ĐỒ
  final List<double> monthlyRevenue = [
    5, 8, 6, 10, 12, 15, 18, 14, 16, 20, 22, 25
  ];

  // 🔥 BIỂU ĐỒ
  Widget buildChart() {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text("T${value.toInt() + 1}",
                      style: const TextStyle(fontSize: 10));
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              spots: monthlyRevenue
                  .asMap()
                  .entries
                  .map((e) =>
                  FlSpot(e.key.toDouble(), e.value))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 THÊM REVIEW
  void addReview(int index) {
    final review = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Thêm đánh giá"),
        content: TextField(
          controller: review,
          decoration: const InputDecoration(
            hintText: "Nhập đánh giá...",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                places[index].reviews.add(review.text);
              });
              Navigator.pop(context);
            },
            child: const Text("Gửi"),
          )
        ],
      ),
    );
  }
// 🔥 FORM ADD / EDIT
  void showForm({Place? place, int? index}) {
    final name = TextEditingController(text: place?.name ?? '');
    final location =
    TextEditingController(text: place?.location ?? '');
    final price =
    TextEditingController(text: place?.price.toString() ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(place == null ? "Thêm" : "Sửa"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: name),
            TextField(controller: location),
            TextField(
              controller: price,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (place == null) {
                setState(() {
                  places.add(
                    Place(
                      id: DateTime.now().toString(),
                      name: name.text,
                      location: location.text,
                      rating: 4.5,
                      image: 'assets/images/HaNoi.jpg',
                      price: int.tryParse(price.text) ?? 0,
                      reviews: [],
                    ),
                  );
                });
              } else {
                setState(() {
                  places[index!] = Place(
                    id: place.id,
                    name: name.text,
                    location: location.text,
                    rating: place.rating,
                    image: place.image,
                    price: int.tryParse(price.text) ?? 0,
                    reviews: place.reviews,
                  );
                });
              }

              Navigator.pop(context);
            },
            child: const Text("Lưu"),
          )
        ],
      ),
    );
  }

  void deletePlace(int index) {
    setState(() => places.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quản trị viên")),

      body: Column(
        children: [
          // 🔥 DOANH THU BOX
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "💰 Doanh thu: $tongDoanhThu VND",
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // 🔥 BIỂU ĐỒ
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: buildChart(),
          ),

          const SizedBox(height: 10),

          // 🔥 LIST
          Expanded(
            child: places.isEmpty
                ? const Center(child: Text("Chưa có dữ liệu"))
                : ListView.builder(
              itemCount: places.length,
              itemBuilder: (context, i) {
                final p = places[i];

                return Card(
                  child: ListTile(
                    leading: Image.asset(
                      p.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(p.name),

                    subtitle: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text("${p.location} - ${p.price} VND"),
                        if (p.reviews.isNotEmpty)
                          Text("📝 ${p.reviews.last}"),
                      ],
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.rate_review),
                          onPressed: () => addReview(i),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () =>
                              showForm(place: p, index: i),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => deletePlace(i),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => showForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}