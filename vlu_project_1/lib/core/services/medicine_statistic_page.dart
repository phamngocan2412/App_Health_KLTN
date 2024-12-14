// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/home/controllers/task_controller.dart';
import '../../features/home/models/database_helper.dart';
import '../../features/home/models/task.dart'; // Giả sử bạn có một class để quản lý SQLite



class MedicineStatisticsPage extends StatefulWidget {
  const MedicineStatisticsPage({super.key});

  @override
  MedicineStatisticsPageState createState() => MedicineStatisticsPageState();
}

class MedicineStatisticsPageState extends State<MedicineStatisticsPage> {
  List<int> medicineStats = [0, 0]; 
  List<int> reminderStats = [0, 0, 0, 0];
  List<Task> taskList = []; 

  @override
  void initState() {
    super.initState();
    _loadMedicineStats();
    _loadTasks();
  }
  

  // Tải dữ liệu thống kê từ SharedPreferences
  _loadMedicineStats() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? stats = prefs.getStringList('medicineStats');
    if (stats != null && stats.isNotEmpty) {
      setState(() {
        medicineStats = stats.map((e) => int.parse(e)).toList();
      });
    } else {
      setState(() {
        medicineStats = [0, 0];
      });
    }
  }

  _loadTasks() async {
    var tasks = await DBHelper().query(); 
    setState(() {
      taskList = tasks.map((e) => Task.fromMap(e)).toList();
      _updateReminderStats();
    });
  }

  void _showDeleteConfirmation(String title, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text(title, style: const TextStyle(fontSize: 20),)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: onConfirm,
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  // Hàm xóa lịch sử
  clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('medicineStats');
    setState(() {
      medicineStats = [0, 0]; 
    });
  }

  _updateReminderStats() {
    List<int> stats = [0, 0, 0, 0];
    for (var task in taskList) {
      if (task.repeat == 'Không') {
        stats[0]++;
      } else if (task.repeat == 'Hằng ngày') {
        stats[1]++;
      } else if (task.repeat == 'Hằng tuần') {
        stats[2]++;
      } else if (task.repeat == 'Hằng tháng') {
        stats[3]++;
      }
    }
    setState(() {
      reminderStats = stats;
    });
  }

  // Hiển thị biểu đồ nhắc nhở
  Widget _buildReminderChart() {
    return SizedBox(
      height: 250,
      child: reminderStats.every((stat) => stat == 0)
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notification_add_outlined, color: Colors.grey, size: 50),
                  SizedBox(height: 10),
                  Text(
                    'Chưa có nhắc nhở',
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                ],
              ),
            )
          : PieChart(
              dataMap: {
                'Không nhắc nhở': reminderStats[0].toDouble(),
                'Hằng ngày': reminderStats[1].toDouble(),
                'Hằng tuần': reminderStats[2].toDouble(),
                'Hằng tháng': reminderStats[3].toDouble(),
              },
              colorList: [
                Colors.blue[400]!,
                Colors.green[400]!,
                Colors.orange[400]!,
                Colors.red[400]!,
              ],
              chartRadius: MediaQuery.of(context).size.width / 3,
              ringStrokeWidth: 24,
              animationDuration: const Duration(milliseconds: 800),
              chartValuesOptions: const ChartValuesOptions(
                showChartValues: true,
                showChartValuesOutside: true,
                showChartValuesInPercentage: true,
                showChartValueBackground: false,
              ),
              legendOptions: const LegendOptions(
                showLegends: true,
              ),
            ),
    );
  }


  // Hiển thị thẻ thống kê nhắc nhở
  Widget _buildReminderCard(String title, int value) {
    return Card(
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),
            ),
            Text(
              '$value lần',
              style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 30,
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Thống kê"),
              ],
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.delete),
              onSelected: (value) {
                if (value == 'medicine') {
                  _showDeleteConfirmation('Xóa tất cả thống kê uống thuốc', () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('medicineStats');
                    setState(() {
                      medicineStats = [0, 0]; 
                    });
                    Navigator.of(context).pop();
                  });
                } else if (value == 'reminders') {
                  _showDeleteConfirmation('Xóa tất cả thống kê nhắc nhở', () async {
                    TaskController().deleteAllTask();
                    setState(() {
                      reminderStats = [0, 0, 0, 0];
                    });
                    Navigator.of(context).pop();
                  });
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'medicine',
                  child: Text('Xóa tất cả thống kê uống thuốc'),
                ),
                const PopupMenuItem(
                  value: 'reminders',
                  child: Text('Xóa tất cả thống kê nhắc nhở'),
                ),
              ],
            ),
          ],
        ),
        elevation: 2,
        shadowColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildPieChart(), 
              const SizedBox(height: 16.0),
                _buildStatisticCard('Đã uống thuốc', medicineStats[0]),
              const SizedBox(height: 12.0),
                _buildStatisticCard('Chưa uống thuốc', medicineStats[1]),
              const SizedBox(height: 16.0),
              _buildReminderChart(),
              const SizedBox(height: 16.0),
                _buildReminderCard('Không nhắc nhở', reminderStats[0]),
                const SizedBox(height: 12.0),
                _buildReminderCard('Hằng ngày', reminderStats[1]),
                const SizedBox(height: 12.0),
                _buildReminderCard('Hằng tuần', reminderStats[2]),
                const SizedBox(height: 12.0),
                _buildReminderCard('Hằng tháng', reminderStats[3]),
              const SizedBox(height: 40.0),
            ],
          ),
        ),
      ),
    );
  }

  // Hiển thị thẻ thống kê
  Widget _buildStatisticCard(String title, int value) {
    return Card(
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),
            ),
            Text(
              '$value lần',
              style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  // Biểu đồ tròn thống kê số lần uống thuốc
  Widget _buildPieChart() {
    return SizedBox(
      height: 250,
      child: medicineStats[0] == 0 && medicineStats[1] == 0
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_chart_outlined, color: Colors.grey, size: 50),
                  SizedBox(height: 10),
                  Text(
                    'Chưa có dữ liệu',
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                ],
              ),
            )
          : PieChart(
              dataMap: {
                'Đã uống thuốc': medicineStats[0].toDouble(),
                'Chưa uống thuốc': medicineStats[1].toDouble(),
              },
              colorList: [
                Colors.green[400]!,
                Colors.red[400]!,
              ],
              chartRadius: MediaQuery.of(context).size.width / 3,
              ringStrokeWidth: 24,
              animationDuration: const Duration(milliseconds: 800),
              chartValuesOptions: const ChartValuesOptions(
                showChartValues: true,
                showChartValuesOutside: true,
                showChartValuesInPercentage: true,
                showChartValueBackground: false,
              ),
              legendOptions: const LegendOptions(
                showLegends: true,
              ),
            ),
    );
  }

}
