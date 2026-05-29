import 'package:flutter/material.dart';
import 'screens/ad_dashboard_screen.dart';
import 'screens/ad_places_screen.dart';
import 'screens/ad_bookings_screen.dart';
import 'screens/ad_payments_screen.dart';
import 'screens/ad_customers_screen.dart';
import 'screens/ad_reviews_screen.dart';
import 'screens/ad_settings_screen.dart';

class AdShell extends StatefulWidget {
  const AdShell({super.key});

  @override
  State<AdShell> createState() => _AdShellState();
}

class _AdShellState extends State<AdShell> {
  int _selectedIndex = 0;

  final List<_NavItem> _navItems = const [
    _NavItem('Dashboard',    Icons.dashboard_outlined,       Icons.dashboard,            'Tổng quan'),
    _NavItem('Địa điểm',    Icons.place_outlined,           Icons.place,                'Quản lý địa điểm'),
    _NavItem('Đặt chỗ',     Icons.calendar_today_outlined,  Icons.calendar_today,       'Đặt chỗ'),
    _NavItem('Thanh toán',  Icons.payment_outlined,         Icons.payment,              'Thanh toán'),
    _NavItem('Khách hàng',  Icons.people_outline,           Icons.people,               'Khách hàng'),
    _NavItem('Đánh giá',    Icons.star_outline,             Icons.star,                 'Đánh giá'),
    _NavItem('Cài đặt',     Icons.settings_outlined,        Icons.settings,             'Cài đặt'),
  ];

  // Số badge thông báo cho từng tab (null = không có)
  final List<int?> _badges = [null, null, 3, null, null, 2, null];

  final List<Widget> _screens = const [
    AdDashboardScreen(),
    AdPlacesScreen(),
    AdBookingsScreen(),
    AdPaymentsScreen(),
    AdCustomersScreen(),
    AdReviewsScreen(),
    AdSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          _navItems[_selectedIndex].pageTitle,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.grey[700]),
            onPressed: () {},
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.notifications_outlined, color: Colors.grey[700]),
                onPressed: () {},
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.file_download_outlined, color: Colors.grey[700]),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              // Logo
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
                ),
                child: Row(children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A56DB),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.flight_takeoff, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('VietTravel', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      Text('Admin Panel', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ]),
              ),

              const SizedBox(height: 8),
              // Nav section label
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'TỔNG QUAN',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[400],
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
              _NavTile(
                item: _navItems[0],
                index: 0,
                selected: _selectedIndex == 0,
                badge: _badges[0],
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedIndex = 0);
                },
              ),

              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'QUẢN LÝ',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[400],
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
              ...List.generate(5, (i) {
                final idx = i + 1;
                return _NavTile(
                  item: _navItems[idx],
                  index: idx,
                  selected: _selectedIndex == idx,
                  badge: _badges[idx],
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _selectedIndex = idx);
                  },
                );
              }),

              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'HỆ THỐNG',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[400],
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
              _NavTile(
                item: _navItems[6],
                index: 6,
                selected: _selectedIndex == 6,
                badge: null,
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedIndex = 6);
                },
              ),

              const Spacer(),
              // Bottom user info
              Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6FA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(children: [
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: Color(0xFFE6F1FB),
                    child: Text('AD', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF185FA5))),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Admin', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        Text('Quản trị viên', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.logout, size: 16, color: Colors.grey[500]),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: _screens[_selectedIndex],
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon, activeIcon;
  final String pageTitle;
  const _NavItem(this.label, this.icon, this.activeIcon, this.pageTitle);
}

class _NavTile extends StatelessWidget {
  final _NavItem item;
  final int index;
  final bool selected;
  final int? badge;
  final VoidCallback onTap;
  const _NavTile({required this.item, required this.index, required this.selected, required this.badge, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF1A56DB).withOpacity(0.08) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(children: [
            Icon(selected ? item.activeIcon : item.icon,
                size: 18, color: selected ? const Color(0xFF1A56DB) : Colors.grey[600]),
            const SizedBox(width: 10),
            Expanded(child: Text(item.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  color: selected ? const Color(0xFF1A56DB) : Colors.grey[700],
                ))),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                child: Text('$badge', style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
          ]),
        ),
      ),
    );
  }
}