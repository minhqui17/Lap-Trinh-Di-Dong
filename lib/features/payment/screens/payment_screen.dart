import 'package:flutter/material.dart';
import 'package:travel_booking/features/home/screens/home_screen.dart';
import 'package:travel_booking/services/api_service.dart';

class PaymentScreen extends StatefulWidget {
  final int total;
  final Map<String, dynamic>? bookingDetails;

  const PaymentScreen({super.key, required this.total, this.bookingDetails});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String method = "Momo";
  bool loading = false;
  TextEditingController email = TextEditingController();

  int countdown = 60;
  int qrIndex = 1;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    countdown = 60;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        countdown--;
        if (countdown == 0) {
          qrIndex++;
          countdown = 60;
        }
      });
      return true;
    });
  }

  void pay() async {
    if (email.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập email nhận hóa đơn")),
      );
      return;
    }

    setState(() => loading = true);
    // Giả lập thời gian xử lý thanh toán
    await Future.delayed(const Duration(seconds: 2));

    // Gọi API lưu đơn đặt phòng
    if (widget.bookingDetails != null) {
      Map<String, dynamic> data = Map.from(widget.bookingDetails!);
      data['total'] = widget.total;
      data['status'] = 'pending';
      data['name'] = email.text.split('@').first; // Lấy tạm tên từ email nếu chưa có
      
      bool success = await ApiService.createBooking(data);
      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Có lỗi khi lưu đơn, vui lòng thử lại!")),
        );
      }
    }

    setState(() => loading = false);

    if (!mounted) return;

    // Hiển thị thông báo và điều hướng về Home
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Thành công"),
        content: Text(
          "Thanh toán bằng $method thành công!\nHóa đơn đã gửi về ${email.text}\nĐơn đặt phòng đang chờ Admin xác nhận.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Xóa sạch lịch sử các trang trước và về Home
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
              );
            },
            child: const Text("Về trang chủ"),
          ),
        ],
      ),
    );
  }

  Widget buildPaymentDetail() {
    if (method == "Momo") {
      return Column(
        children: [
          const Text("Quét mã Momo để thanh toán", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          // Sử dụng Image.asset thay vì network cho ảnh trong folder assets
          Image.asset(
            'assets/images/momo_qr${qrIndex % 3 + 1}.png',
            height: 180,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 150,
                color: Colors.grey[300],
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.qr_code_2, size: 50, color: Colors.black54),
                    Text("QR Momo Demo", style: TextStyle(fontSize: 12)),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          Text("Mã hết hạn sau: $countdown s", style: const TextStyle(color: Colors.red)),
        ],
      );
    } else if (method == "Bank") {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Ngân hàng: Vietcombank", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("Số tài khoản: 123456789"),
          Text("Chủ tài khoản: NGUYEN VAN KAI"),
          Text("Nội dung: Thanh toan phong"),
        ],
      );
    } else {
      return const Text("Vui lòng thanh toán tiền mặt tại quầy lễ tân.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thanh toán", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF003580),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Tổng số tiền:", style: TextStyle(fontSize: 16)),
                    Text(
                      "${widget.total} VND",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Chọn phương thức thanh toán:", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            RadioListTile(
              title: const Text("Ví điện tử Momo"),
              value: "Momo",
              groupValue: method,
              onChanged: (v) => setState(() => method = v!),
            ),
            RadioListTile(
              title: const Text("Chuyển khoản ngân hàng"),
              value: "Bank",
              groupValue: method,
              onChanged: (v) => setState(() => method = v!),
            ),
            RadioListTile(
              title: const Text("Thanh toán tiền mặt"),
              value: "Cash",
              groupValue: method,
              onChanged: (v) => setState(() => method = v!),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: buildPaymentDetail(),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email nhận hóa đơn",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: loading ? null : pay,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003580),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Xác nhận thanh toán", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}