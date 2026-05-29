import 'dart:io';
import 'dart:convert';

// Khởi tạo danh sách dữ liệu mẫu
List<Map<String, dynamic>> bookings = [
  {'id': '#BK2501', 'name': 'Nguyễn Văn A', 'place': 'Phú Quốc', 'checkin': '10/05/2025', 'checkout': '15/05/2025', 'guests': 2, 'total': 3600000, 'status': 'confirmed'},
  {'id': '#BK2502', 'name': 'Trần Thị B', 'place': 'Đà Lạt', 'checkin': '15/05/2025', 'checkout': '18/05/2025', 'guests': 3, 'total': 1800000, 'status': 'pending'},
  {'id': '#BK2503', 'name': 'Lê Minh C', 'place': 'Nha Trang', 'checkin': '08/05/2025', 'checkout': '11/05/2025', 'guests': 2, 'total': 2250000, 'status': 'confirmed'},
];

Future<void> main() async {
  final server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
  print('✅ API Server đang chạy tại: http://localhost:8080/bookings');
  print('Dùng http://10.0.2.2:8080/bookings nếu bạn test trên máy ảo Android.');

  await for (HttpRequest request in server) {
    // CORS headers để gọi từ web (nếu cần)
    request.response.headers.add('Access-Control-Allow-Origin', '*');
    request.response.headers.add('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
    request.response.headers.add('Access-Control-Allow-Headers', 'Origin, Content-Type, Accept');

    if (request.method == 'OPTIONS') {
      request.response.statusCode = HttpStatus.ok;
      await request.response.close();
      continue;
    }

    try {
      if (request.uri.path == '/bookings') {
        if (request.method == 'GET') {
          // Lấy danh sách
          request.response
            ..statusCode = HttpStatus.ok
            ..headers.contentType = ContentType.json
            ..write(jsonEncode(bookings));
        } else if (request.method == 'POST') {
          // Thêm mới
          String content = await utf8.decoder.bind(request).join();
          Map<String, dynamic> data = jsonDecode(content);
          
          // Tạo ID tự động
          data['id'] = '#BK${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
          
          bookings.insert(0, data); // Thêm lên đầu
          
          request.response
            ..statusCode = HttpStatus.created
            ..headers.contentType = ContentType.json
            ..write(jsonEncode(data));
        }
      } else if (request.uri.path.startsWith('/bookings/')) {
        // Cập nhật trạng thái
        String idStr = request.uri.path.split('/').last;
        String id = Uri.decodeComponent(idStr); // Giải mã %23 thành #
        
        if (request.method == 'PUT') {
          String content = await utf8.decoder.bind(request).join();
          Map<String, dynamic> data = jsonDecode(content);
          
          int index = bookings.indexWhere((b) => b['id'] == id);
          if (index != -1) {
            bookings[index]['status'] = data['status'];
            request.response
              ..statusCode = HttpStatus.ok
              ..headers.contentType = ContentType.json
              ..write(jsonEncode(bookings[index]));
          } else {
            request.response.statusCode = HttpStatus.notFound;
          }
        }
      } else {
        request.response.statusCode = HttpStatus.notFound;
      }
    } catch (e) {
      print('Lỗi xử lý request: $e');
      request.response.statusCode = HttpStatus.internalServerError;
    }

    await request.response.close();
  }
}
