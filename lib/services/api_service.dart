import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  // Thay đổi 10.0.2.2 thành localhost nếu chạy trên Web hoặc Windows/macOS.
  // 10.0.2.2 là địa chỉ localhost của máy thật khi gọi từ máy ảo Android.
  static String baseUrl = 'http://10.0.2.2:8080/bookings';

  // Chỉnh URL nếu không phải Android (ví dụ: Windows)
  static void initUrl() {
    try {
      if (!Platform.isAndroid && !Platform.isIOS) {
         baseUrl = 'http://localhost:8080/bookings';
      }
    } catch(e) {
      // Trường hợp chạy trên Web (Platform không khả dụng)
      baseUrl = 'http://localhost:8080/bookings';
    }
  }

  static Future<List<Map<String, dynamic>>> getBookings() async {
    try {
      initUrl();
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      print('Lỗi gọi API getBookings: $e');
    }
    return [];
  }

  static Future<bool> createBooking(Map<String, dynamic> bookingData) async {
    try {
      initUrl();
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bookingData),
      );
      return response.statusCode == 201;
    } catch (e) {
      print('Lỗi gọi API createBooking: $e');
      return false;
    }
  }

  static Future<bool> updateBookingStatus(String id, String status) async {
    try {
      initUrl();
      // Phải encode id vì id có chứa ký tự '#' (ví dụ: #BK2501)
      // Nếu không encode, '#' sẽ bị hiểu là URL fragment và server không nhận được id.
      final encodedId = Uri.encodeComponent(id);
      
      final response = await http.put(
        Uri.parse('$baseUrl/$encodedId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': status}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Lỗi gọi API updateBookingStatus: $e');
      return false;
    }
  }
}
