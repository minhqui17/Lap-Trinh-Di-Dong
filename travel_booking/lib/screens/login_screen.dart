import 'package:flutter/material.dart';
import 'package:travel_booking/Data/du_lieu_nguoi_dung.dart';
import 'home_screen.dart';
import 'Admin_screen.dart';
class ManHinhDangNhap extends StatefulWidget {
  const ManHinhDangNhap({super.key});

  @override
  State<ManHinhDangNhap> createState() => _ManHinhDangNhapState();
}

class _ManHinhDangNhapState extends State<ManHinhDangNhap> {
  final _emailController = TextEditingController();
  final _matKhauController = TextEditingController();
  final DuLieuNguoiDung _dbHelper = DuLieuNguoiDung();

  void _thong_bao(String noiDung) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(noiDung)));
  }

  void _xu_ly_dang_nhap() async {
    String email = _emailController.text;
    String pass = _matKhauController.text;

    if (email.isEmpty || pass.isEmpty) {
      _thong_bao("Vui lòng không để trống thông tin!");
      return;
    }
    if (email == "admin" && pass == "123") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminScreen()),
      );
      return;
    }

    var user = await _dbHelper.dang_nhap(email, pass);
    if (user != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else {
      bool tonTai = await _dbHelper.kiem_tra_ton_tai(email);
      if (tonTai) {
        _thong_bao("Mật khẩu không chính xác!");
      } else {
        _thong_bao("Tài khoản chưa tồn tại. Vui lòng nhấn Đăng ký!");
      }
    }
  }

  void _xu_ly_dang_ky() async {
    String email = _emailController.text;
    String pass = _matKhauController.text;

    if (email.isEmpty || pass.isEmpty) {
      _thong_bao("Nhập email và mật khẩu để đăng ký!");
      return;
    }

    int kq = await _dbHelper.dang_ky(email, pass);
    if (kq == -1) {
      _thong_bao("Email này đã được đăng ký trước đó!");
    } else {
      _thong_bao("Đăng ký thành công! Giờ bạn có thể Đăng nhập.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Ảnh nền từ assets/images/Panel.jpg
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Panel.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Lớp phủ tối để dễ nhìn chữ
          Container(color: Colors.black.withOpacity(0.3)),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  const Text(
                    "TRAVEL APP",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5
                    ),
                  ),
                  const SizedBox(height: 40),

                  _o_nhap_lieu(_emailController, "Email", Icons.person_outline),
                  const SizedBox(height: 15),
                  _o_nhap_lieu(_matKhauController, "Mật khẩu", Icons.lock_outline, anNoiDung: true),

                  const SizedBox(height: 30),

                  // Nút Đăng nhập
                  _nut_bam("ĐĂNG NHẬP", Colors.blueAccent, _xu_ly_dang_nhap),
                  const SizedBox(height: 10),

                  // Nút Đăng ký
                  _nut_bam("ĐĂNG KÝ MỚI", Colors.orangeAccent.withOpacity(0.8), _xu_ly_dang_ky),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _o_nhap_lieu(TextEditingController controller, String goiY, IconData icon, {bool anNoiDung = false}) {
    return TextField(
      controller: controller,
      obscureText: anNoiDung,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white),
        hintText: goiY,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _nut_bam(String chu, Color mau, VoidCallback hanhDong) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: mau,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: hanhDong,
        child: Text(chu, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}