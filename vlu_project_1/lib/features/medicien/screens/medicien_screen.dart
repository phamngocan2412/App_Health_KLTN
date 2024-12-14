// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:vlu_project_1/shared/widgets/custom_search_bar.dart';
import '../controllers/medicine_controller.dart';
import '../models/medicien.dart';
import 'widgets/medicien_card.dart';
import 'widgets/medicien_form_dialog.dart';
import 'widgets/medicien_json.dart';
import 'widgets/text_recognition.dart';
import 'widgets/text_recognition_history.dart';

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({super.key});

  @override
  MedicineScreenState createState() => MedicineScreenState();
}

class MedicineScreenState extends State<MedicineScreen> with SingleTickerProviderStateMixin {
  final MedicineController medicineController = MedicineController();
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Khởi tạo TabController với 2 tab
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image.asset('assets/images/logo.png', height: 30,),
        elevation: 2,
        shadowColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Thêm ghi chú',
            splashRadius: 28,
            splashColor: Colors.grey.withOpacity(0.2),
            hoverColor: Colors.grey.withOpacity(0.1),
            onPressed: () {
              _showMedicineForm();
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.black),
            tooltip: 'Danh sách của hệ thống',
            splashRadius: 28,
            splashColor: Colors.grey.withOpacity(0.2),
            hoverColor: Colors.grey.withOpacity(0.1),
            onPressed: () {
              _showSystemMedicineList();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Danh sách"),
            Tab(text: "Scan For Text"),
            Tab(text: "Show Text"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Danh sách thuốc
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomSearchBar(
                  searchController: searchController,
                  hintText: 'Tìm kiếm thuốc...',
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  onClear: () {
                    setState(() {
                      searchQuery = '';
                      searchController.clear();
                    });
                  },
                ),
              ),
              Expanded(
              child: StreamBuilder<List<Medicine>>(
                stream: searchQuery.isEmpty
                    ? medicineController.getMedicines()
                    : medicineController.searchMedicines(searchQuery),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    debugPrint('Lỗi: ${snapshot.error}');
                    return Center(child: Text('Lỗi: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/list_view.png',
                            width: 300,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                          const Text(
                            'Không tìm thấy thuốc nào',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    final medicines = snapshot.data!;
                    return ListView.builder(
                      itemCount: medicines.length,
                      itemBuilder: (context, index) {
                        final medicine = medicines[index];
                        return MedicineCard(
                          medicine: medicine,
                          onEdit: () => _showMedicineForm(medicine: medicine),
                          onDelete: () => medicineController.deleteMedicine(medicine.id),
                        );
                      },
                    );
                  }
                },
              ),
            ),

            ],
          ),

          // Tab 2: Scan for Text
          const TextRecognitionWidget(),
          // Tab 3: Show Text
          RecognizedTextList(),
        ],
      ),
    );
  }

  void _showMedicineForm({Medicine? medicine}) {
    showDialog(
      context: context,
      builder: (context) => MedicineFormDialog(medicine: medicine),
    );
  }

  void _showSystemMedicineList() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const MedicineJson(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const curve = Curves.easeInOut;

          var fadeAnimation = CurvedAnimation(parent: animation, curve: curve);
          var scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(
            parent: animation,
            curve: curve,
          ));

          return FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: child,
            ),
          );
        },
      ),
    );
  }
}
