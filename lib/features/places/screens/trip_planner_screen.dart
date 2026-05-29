import 'package:flutter/material.dart';
import 'package:travel_booking/models/place.dart';
import 'package:travel_booking/features/booking/screens/booking_screen.dart';

class TripPlannerScreen extends StatefulWidget {
  final List<Place> places;

  const TripPlannerScreen({super.key, required this.places});

  @override
  State<TripPlannerScreen> createState() => _TripPlannerScreenState();
}

class _TripPlannerScreenState extends State<TripPlannerScreen> {
  final TextEditingController start = TextEditingController();
  final TextEditingController end = TextEditingController();

  Place? selectedPlace;


  Future<void> pickPlace({required bool isStart}) async {
    final result = await showModalBottomSheet<Place>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        TextEditingController search = TextEditingController();
        List<Place> filtered = widget.places;

        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                height: 400,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // 🔍 Search
                    TextField(
                      controller: search,
                      decoration: InputDecoration(
                        hintText: "Tìm địa điểm...",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                        setStateModal(() {
                          filtered = widget.places
                              .where((p) => p.name
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    // 📍 List địa điểm
                    Expanded(
                      child: ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final p = filtered[index];
                          return ListTile(
                            leading: Icon(Icons.location_on, color: Colors.red),
                            title: Text(p.name),
                            subtitle: Text(p.location),
                            onTap: () {
                              Navigator.pop(context, p);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        if (isStart) {
          start.text = result.name;
        } else {
          end.text = result.name;
          selectedPlace = result;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          Container(
            color: Colors.grey.shade300,
            child: const Center(
              child: Icon(Icons.map, size: 150, color: Colors.grey),
            ),
          ),


          Positioned(
            top: 60,
            left: 16,
            right: 16,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    // 🔹 Điểm đi
                    GestureDetector(
                      onTap: () => pickPlace(isStart: true),
                      child: AbsorbPointer(
                        child: TextField(
                          controller: start,
                          decoration: const InputDecoration(
                            prefixIcon:
                            Icon(Icons.circle, color: Colors.green),
                            hintText: "Chọn điểm đi",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),

                    const Divider(),

                    // 🔹 Điểm đến
                    GestureDetector(
                      onTap: () => pickPlace(isStart: false),
                      child: AbsorbPointer(
                        child: TextField(
                          controller: end,
                          decoration: const InputDecoration(
                            prefixIcon:
                            Icon(Icons.location_on, color: Colors.red),
                            hintText: "Chọn điểm đến",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 🔹 thông tin route
          if (start.text.isNotEmpty && end.text.isNotEmpty)
            Positioned(
              bottom: 120,
              left: 16,
              right: 16,
              child: Card(
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: const [
                      Text("🚗 Khoảng cách: ~120 km"),
                      SizedBox(height: 5),
                      Text("⏱️ Thời gian: ~2h30p"),
                    ],
                  ),
                ),
              ),
            ),

          // 🔹 nút booking
          Positioned(
            bottom: 30,
            left: 16,
            right: 16,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Tiếp tục Booking"),
              onPressed: () {
                if (selectedPlace == null) return;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        BookingScreen(place: selectedPlace!),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}