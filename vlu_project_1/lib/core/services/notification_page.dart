// ignore_for_file: avoid_print, unnecessary_null_comparison, deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vlu_project_1/core/services/medicine_statistic_page.dart';
import 'notification_services.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key, this.payload});

  final String? payload;

  @override
  NotificationPageState createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
  bool isMedicineTaken = false;
  DateTime? notificationTime;
  StreamSubscription<String>? _notificationSubscription;
  
  @override
  void initState() {
    super.initState();
    _initializeState();
    _notificationSubscription = NotifyHelper.selectedNotificationSubject.listen((payload) async {
      final prefs = await SharedPreferences.getInstance();
      bool isProcessed = prefs.getBool('isNotificationProcessed') ?? false;

      if (!isProcessed) {
        _handlePayload(payload);
      }
    });
  }
  void _initializeState() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isMedicineTaken = prefs.getBool('medicineTaken');

    if (isMedicineTaken == null) {
      prefs.setBool('medicineTaken', false);
    }

    setState(() {
      isMedicineTaken = prefs.getBool('medicineTaken') ?? false;
    });
  }
    
  @override
  void dispose() {
    _notificationSubscription?.cancel();
    super.dispose();
  }

  void _handlePayload(String? payload) async {
    if (payload != null) {
      try {
        final prefs = await SharedPreferences.getInstance();
        bool? isMedicineTaken = prefs.getBool('medicineTaken');

        // Đặt mặc định là false nếu chưa có
        if (isMedicineTaken == null) {
          prefs.setBool('medicineTaken', false);
        }
      } catch (e) {
        print("Lỗi khi xử lý payload: $e");
      }
    }
  }

  void _updateMedicineStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().toIso8601String();

    bool? currentStatus = prefs.getBool('medicineTaken');
    if (currentStatus == status) {
      print("Trạng thái 'medicineTaken' đã được cập nhật, không cần cập nhật lại.");
      return;
    }

    prefs.setBool('medicineTaken', status);
    prefs.setString('medicineTime', now);

    print("Cập nhật trạng thái uống thuốc: $status");

    if (mounted) {
      setState(() {
        isMedicineTaken = status;
      });
    }

    _updateStatistics(status);
  }


  void _updateStatistics(bool status, {bool isDecrement = false}) async {
  final prefs = await SharedPreferences.getInstance();
  List<String>? stats = prefs.getStringList('medicineStats');
  stats ??= ['0', '0']; // [đã uống, chưa uống]

  print("Trước khi cập nhật: $stats");
  print("Status: $status, isDecrement: $isDecrement");

  if (status) {
    // Tăng số lượng "đã uống thuốc"
    stats[0] = (int.parse(stats[0]) + 1).toString();
  } else {
    if (isDecrement) {
      print("Giảm số lượng chưa uống thuốc");
      // Giảm số lượng "chưa uống thuốc"
      stats[1] = (int.parse(stats[1]) - 1).toString();
    } else {
      print("Tăng số lượng chưa uống thuốc");
      // Tăng số lượng "chưa uống thuốc"
      stats[1] = (int.parse(stats[1]) + 1).toString();
    }
  }

  // Đảm bảo không có giá trị âm
  if (int.parse(stats[1]) < 0) {
    stats[1] = '0';
  }

  print("Sau khi cập nhật: $stats");

  // Lưu lại giá trị cập nhật
  prefs.setStringList('medicineStats', stats);
}



  void _markMedicineAsTaken() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isMedicineTaken = prefs.getBool('medicineTaken');

    print("Trạng thái trước đó (medicineTaken): $isMedicineTaken");

    if (isMedicineTaken == false || isMedicineTaken == null) {
      // Nếu chưa uống thuốc, giảm số lượng "chưa uống thuốc"
      _updateStatistics(false, isDecrement: true);
      // Cập nhật trạng thái thuốc đã được uống
      _updateMedicineStatus(true);
    } 

    prefs.setBool('isNotificationProcessed', false);
    prefs.remove('medicineTaken');

    List<String>? stats = prefs.getStringList('medicineStats');
    print("medicineStats sau khi uống thuốc: $stats");
  }




  goToStatisticsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MedicineStatisticsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông báo nhắc nhở"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              SystemNavigator.pop();
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.payload != null) _buildNotifiedReminderCard(widget.payload!),
            if (widget.payload == null)
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  "Lời nhắc chưa tới",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ),
            const SizedBox(height: 24.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(10.0),
              child: isMedicineTaken
                  ? const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Bạn đã uống thuốc!",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    )
                  : const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Bạn chưa uống thuốc!",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 24.0),
            Center(
              child: SizedBox(
                height: 60,
                width: 250,
                child: ElevatedButton(
                  onPressed: isMedicineTaken ? null : _markMedicineAsTaken,
                  child: const Text('Đã uống thuốc'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotifiedReminderCard(String payload) {
    final parts = payload.split('|');
    if (parts.length < 4) {
      return const Text("Chưa tới giờ uống thuốc");
    }
    final title = parts[0];
    final note = parts[1];
    final eventDate = parts[2];
    final eventTime = parts[3];
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.2),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.alarm,
                      size: 60.0,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      "Nhắc nhở của bạn",
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[800],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),
              _buildInfoRow("Tiêu đề :", title, Colors.blueGrey[900]!),
              const SizedBox(height: 16.0),
              _buildInfoRow("Ghi chú :", note, Colors.blueGrey[600]!),
              const SizedBox(height: 16.0),
              _buildInfoRow("Ngày :", eventDate, Colors.blueGrey[600]!),
              const SizedBox(height: 16.0),
              _buildInfoRow("Thời gian :", eventTime, Colors.blueGrey[600]!),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[100],
                  ),
                  onPressed: () {
                    goToStatisticsPage();
                  },
                  child: const Text('Xem thống kê', style: TextStyle(color: Colors.black)),
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              color: textColor,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}