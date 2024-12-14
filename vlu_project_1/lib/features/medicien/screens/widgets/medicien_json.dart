// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

class MedicineJson extends StatefulWidget {
  const MedicineJson({super.key});

  @override
  MedicineJsonState createState() => MedicineJsonState();
}

class MedicineJsonState extends State<MedicineJson> {
  List<dynamic> thuocList = [];
  final TextEditingController tenThuocController = TextEditingController();
  final TextEditingController benhController = TextEditingController();
  final TextEditingController lieuLuongController = TextEditingController();
  final TextEditingController thoiGianUongController = TextEditingController();
  final TextEditingController congDungController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadThuocData();
  }

  Future<void> loadThuocData() async {
    String jsonString = await rootBundle.loadString('assets/medicien/benh.json');
    setState(() {
      thuocList = jsonDecode(jsonString)['thuoc'];
    });
  }

  void addThuoc() {
    if (tenThuocController.text.isNotEmpty) {
      setState(() {
        thuocList.add({
          "ten_thuoc": tenThuocController.text,
          "benh": benhController.text,
          "lieu_luong": lieuLuongController.text,
          "thoi_gian_uong": thoiGianUongController.text,
          "cong_dung": congDungController.text,
        });
      });
      tenThuocController.clear();
      benhController.clear();
      lieuLuongController.clear();
      thoiGianUongController.clear();
      congDungController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        elevation: 2,
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Thông tin thuốc'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: AnimationLimiter(
              child: ListView.builder(
                itemCount: thuocList.length,
                itemBuilder: (context, index) {
                  var thuoc = thuocList[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 800),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Card(
                          color: Colors.grey[200],
                          margin: const EdgeInsets.all(10.0),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  thuoc['ten_thuoc'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                const SizedBox(height: 4.0),
                                Text('Bệnh: ${thuoc['benh']}'),
                                Text('Liều lượng: ${thuoc['lieu_luong']}'),
                                Text('Thời gian uống: ${thuoc['thoi_gian_uong']}'),
                                Text('Công dụng: ${thuoc['cong_dung']}'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
