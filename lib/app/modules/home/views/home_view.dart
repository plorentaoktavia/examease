import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testgo/app/controllers/auth_controller.dart';
import 'package:testgo/app/modules/jadwal/views/jadwal_view.dart';
import 'package:testgo/app/modules/pengumuman/views/pengumuman_view.dart';

import '../../dashboard/views/dashboard_view.dart';
import '../../pendaftaran/views/pendaftaran_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final cAuth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return DashboardAdmin();
  }
}

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({Key? key}) : super(key: key);

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  final cAuth = Get.find<AuthController>();
  int _index = 0;

  List<Map<String, dynamic>> _fragment = [
    {
      'title': 'Beranda',
      'view': DashboardView(),
      'icon': Icons.home,
      // 'add': () => DashboardAddView()
    },
    {
      'title': 'Pendaftaran',
      'view': PendaftaranView(),
      'icon': Icons.app_registration,
      // 'add': () => AddView()
    },
    {
      'title': 'Jadwal Ujian',
      'view': JadwalView(),
      'icon': Icons.schedule,
      // 'add': () => JadwalCombasedView()
    },
    {
      'title': 'Pengumuman',
      'view': PengumumanView(),
      'icon': Icons.announcement,
      // 'add': () => PengumumanAddView()
    },
    {
      'title': 'Logout',
      'icon': Icons.logout,
    },
  ];

  void showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                cAuth.logout();
                setState(() {
                  _index = 0; // Reset to the home screen after logout
                });
              },
              child: Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Colors.redAccent,
          titleSpacing: 30,
          title: Text(
            _fragment[_index]['title'],
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: _index,
        children: _fragment.map<Widget>((item) {
          if (item['view'] != null) {
            return item['view'] as Widget;
          } else {
            return Container(); // Placeholder for non-view items
          }
        }).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (int newIndex) {
          setState(() {
            _index = newIndex;
          });

          // Handle logout when tapping on the last item (Logout)
          if (newIndex == _fragment.length - 1) {
            showLogoutConfirmation();
          }
        },
        items: _fragment
            .map(
              (item) => BottomNavigationBarItem(
                icon: Icon(item['icon']),
                label: item['title'],
              ),
            )
            .toList(),
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
