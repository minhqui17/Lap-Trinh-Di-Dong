import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DuLieuNguoiDung {
  static final DuLieuNguoiDung _instance = DuLieuNguoiDung._internal();
  static Database? _database;

  factory DuLieuNguoiDung() => _instance;

  // Sửa lỗi dòng 9: Thêm dấu ngoặc nhọn rỗng
  DuLieuNguoiDung._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _khoi_tao_db();
    return _database!;
  }

  Future<Database> _khoi_tao_db() async {
    String path = join(await getDatabasesPath(), 'nguoi_dung.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE TaiKhoan(id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT UNIQUE, mat_khau TEXT)',
        );
      },
    );
  }

  // Chức năng đăng ký
  Future<int> dang_ky(String email, String matKhau) async {
    final db = await database;
    try {
      return await db.insert('TaiKhoan', {'email': email, 'mat_khau': matKhau});
    } catch (e) {
      return -1;
    }
  }

  // Chức năng đăng nhập
  Future<Map<String, dynamic>?> dang_nhap(String email, String matKhau) async {
    final db = await database;
    List<Map<String, dynamic>> ketQua = await db.query(
      'TaiKhoan',
      where: 'email = ? AND mat_khau = ?',
      whereArgs: [email, matKhau],
    );
    return ketQua.isNotEmpty ? ketQua.first : null;
  }

  // Kiểm tra tồn tại
  Future<bool> kiem_tra_ton_tai(String email) async {
    final db = await database;
    List<Map<String, dynamic>> ketQua = await db.query(
      'TaiKhoan',
      where: 'email = ?',
      whereArgs: [email],
    );
    return ketQua.isNotEmpty;
  }
}