import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlu_project_1/features/chat_ai/screens/chat_ai.dart';
import 'package:vlu_project_1/features/home/screens/home_screen.dart';
import 'package:vlu_project_1/features/medicien/screens/medicien_screen.dart';
import 'package:vlu_project_1/features/personalization/screens/profile/profile_screen.dart';
import '../core/services/medicine_statistic_page.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  NavigationMenuState createState() => NavigationMenuState();
}

class NavigationMenuState extends State<NavigationMenu> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          currentIndex: controller.selectedIndex.value,
          onTap: (index) {
            setState(() {
              controller.selectedIndex.value = index; // Cập nhật selectedIndex
            });
          },
          selectedItemColor: Colors.red[400], // Màu khi chọn mục
          unselectedItemColor: Colors.grey, // Màu khi chưa chọn mục
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
          showSelectedLabels: true, // Chỉ hiển thị nhãn khi được chọn
          showUnselectedLabels: false, // Không hiển thị nhãn khi chưa được chọn
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'List',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Statistics',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final screens = <Widget>[];

  NavigationController() {
    screens.addAll([
      const HomeScreen(),
      const MedicineScreen(),
      const ChatAi(),
      const MedicineStatisticsPage(),
      const ProfileScreen(),
    ]);
  }
}
