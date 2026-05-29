import 'package:flutter/material.dart';
import 'package:travel_booking/models/place.dart';
import 'package:travel_booking/features/payment/screens/payment_screen.dart';

class BookingScreen extends StatefulWidget {
  final Place place;
  const BookingScreen({super.key, required this.place});


  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int people = 1;

  @override
  Widget build(BuildContext context) {
    int price = 500000;
    int total = price * people;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                widget.place.image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey,
                    child: const Icon(Icons.image, size: 50),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            Text(
              widget.place.name,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(widget.place.location),

            const SizedBox(height: 10),


            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                Text(widget.place.rating.toString()),
              ],
            ),

            const SizedBox(height: 20),

            const Text("Số người",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<int>(
                value: people,
                isExpanded: true,
                underline: const SizedBox(),
                items: [1, 2, 3, 4, 5]
                    .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text("$e người"),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() => people = value!);
                },
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Tổng tiền
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Tổng tiền",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(
                    "$total VND",
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 🔹 Button thanh toán
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Thanh toán"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PaymentScreen(
                        total: total,
                        bookingDetails: {
                          'place': widget.place.name,
                          'guests': people,
                          'checkin': 'Hôm nay', 
                          'checkout': 'Ngày mai',
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}