// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'dart:async';
import 'package:flutter/material.dart';
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
  Timer? timer;  

  @override
  void initState() {
    super.initState();
    // Lắng nghe thông báo từ subject
    NotifyHelper.selectedNotificationSubject.listen((payload) {
      // Xử lý khi có thông báo mới
      if (payload != null) {
        try {
          // Tách chuỗi payload bằng ký tự `|`
          List<String> parts = payload.split('|');
          
          if (parts.length == 4) {
            // Gán giá trị từ payload vào các biến
            String title = parts[0];
            String note = parts[1];
            String date = parts[2];
            String startTime = parts[3];

            // Xử lý trực tiếp với thông tin từ payload
            _startTimer(title, note, date, startTime);
            _saveNotificationTime();
          } else {
            print("Payload không đúng định dạng: $payload");
          }
        } catch (e) {
          print("Lỗi khi xử lý payload: $e");
        }
      }
    });

    if (widget.payload != null) {
      try {
        // Tách chuỗi payload bằng ký tự `|`
        List<String> parts = widget.payload!.split('|');
        
        if (parts.length == 4) {
          // Gán giá trị từ payload vào các biến
          String title = parts[0];
          String note = parts[1];
          String date = parts[2];
          String startTime = parts[3];

          // Xử lý trực tiếp với thông tin từ payload
          _startTimer(title, note, date, startTime);
          _saveNotificationTime();
        } else {
          print("Payload không đúng định dạng: ${widget.payload!}");
        }
      } catch (e) {
        print("Lỗi khi xử lý payload: $e");
      }
    }
  }

  _startTimer(String title, String note, String date, String startTime) {
    startTime = startTime.replaceAll(RegExp(r'\s+'), '');
    List<String> timeParts = startTime.split(":");
    int hour = int.parse(timeParts[0]);

    if (startTime.contains("PM") && hour != 12) {
      hour += 12; 
    } else if (startTime.contains("AM") && hour == 12) {
      hour = 0; 
    }

    int minute = int.parse(timeParts[1].substring(0, 2));

    DateTime currentDate = DateTime.now();

    DateTime startDateTime = DateTime(currentDate.year, currentDate.month, currentDate.day, hour, minute);

    DateTime currentTime = DateTime.now();
    Duration difference = currentTime.difference(startDateTime);

    if (difference.inMinutes >= 2 && !isMedicineTaken) {
      _updateMedicineStatus(false);
    }

    timer = Timer(const Duration(minutes: 1), () {
      if (!isMedicineTaken) {
        _updateMedicineStatus(false);
      }
    });
  }

  _saveNotificationTime() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    setState(() {
      notificationTime = now;
    });
    prefs.setString('notificationTime', now.toIso8601String());
  }

  void _updateMedicineStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().toIso8601String();
    prefs.setBool('medicineTaken', status);
    prefs.setString('medicineTime', now);  

    setState(() {
      isMedicineTaken = status;
    });

    // Cập nhật thống kê
    _updateStatistics(status);
  }

  void _updateStatistics(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? stats = prefs.getStringList('medicineStats');
    stats ??= ['0', '0']; // Mặc định là 0 cho cả hai

    if (status) {
      stats[0] = (int.parse(stats[0]) + 1).toString();  // Đã uống
    } else {
      stats[1] = (int.parse(stats[1]) + 1).toString();  // Chưa uống
    }

    prefs.setStringList('medicineStats', stats);
  }

  _markMedicineAsTaken() async {
    _updateMedicineStatus(true);
    if (timer != null) {
      timer!.cancel();  
    }
  }

  goToStatisticsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MedicineStatisticsPage()),
    );
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();  
    }
    super.dispose();
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
            Navigator.of(context).popUntil((route) => route.isFirst);
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
                        )
            ),
            const SizedBox(height: 24.0),
            Center(
              child: SizedBox(
                height: 60,
                width: 250,
                child: ElevatedButton(
                  onPressed: _markMedicineAsTaken,
                  child: const Text('Đã uống thuốc'),
                ),
              ),
            )
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
