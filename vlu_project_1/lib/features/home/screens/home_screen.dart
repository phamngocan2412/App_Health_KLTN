

// ignore_for_file: avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vlu_project_1/core/services/notification_services.dart';
import 'package:vlu_project_1/core/utils/assets/theme.dart';
import 'package:vlu_project_1/features/home/controllers/task_controller.dart';
import 'package:vlu_project_1/features/home/screens/add_task_bar.dart';
import 'package:vlu_project_1/features/home/screens/widget_home/header_field.dart';
import 'package:vlu_project_1/features/home/screens/widget_home/home_app_bar.dart';
import 'package:vlu_project_1/features/home/screens/widget_home/list_calendar.dart';
import 'package:vlu_project_1/features/home/screens/widget_home/task_tile.dart';
import 'package:vlu_project_1/permission_manager.dart';
import 'package:vlu_project_1/shared/size_config.dart';
import 'package:vlu_project_1/shared/widgets/loaders.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  late NotifyHelper notifyHelper;
  final TaskController _taskController = Get.put(TaskController());
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _checkFilePermissions();
    });

    selectedDate = DateTime.now();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    _taskController.getTasks();
  }

  Future<void> _checkFilePermissions() async {
    if (!await Permission.storage.isGranted) {
      if (mounted) {
        await PermissionManager.checkAndRequestStoragePermission(context);
      }
      if (!await Permission.storage.isGranted) {
        print("Người dùng từ chối quyền lưu trữ.");
      }
    }
    
    if (!await Permission.scheduleExactAlarm.isGranted) {
      if (mounted) {
        await PermissionManager.requestAlarmPermission(context);
      }
      if (!await Permission.scheduleExactAlarm.isGranted) {
        print("Người dùng từ chối quyền đồng hồ.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: const THomeAppBar(),
      body: Column(
        children: [
          HeaderField(onTap: () async {
            await Get.to(() => const AddTaskPage());
            _taskController.getTasks();
          }),
          ListCalendar(
            onDateChange: (date) {
            setState(() {
              selectedDate = date; 
            });
          }),
          const SizedBox(height: 40,),
          _showTasks(),
        ],
      ),
    );
  }
  //Tasks List
  _showTasks() {
    return Expanded(
      child: Obx(
        () => RefreshIndicator(
          onRefresh: () => _taskController.getTasks(),
          child: _taskController.taskList.isEmpty
              ? _noTaskMsg()
              : ListView.builder(
                  scrollDirection:
                      SizeConfig.orientation == Orientation.landscape
                          ? Axis.horizontal
                          : Axis.vertical,
                  itemCount: _taskController.taskList.length,
                  itemBuilder: (context, index) {
                    var task = _taskController.taskList[index];
                    String startTime = task.startTime.toString();
                    List<String> timeParts = startTime.replaceAll(RegExp(r'\s+'), '').split(":");
                    int hour = int.parse(timeParts[0]);
                    int minute = int.parse(timeParts[1].substring(0, 2));
                    NotifyHelper.showScheduleNotification(task: task ,hour :hour, minutes: minute);

                    if ((task.repeat == 'Hằng ngày') ||
                      (task.date == DateFormat('dd/MM/yyyy').format(selectedDate)) ||
                      (task.repeat == 'Hằng tuần' &&
                          selectedDate.difference(DateFormat('dd/MM/yyyy').parse(task.date)).inDays % 7 == 0) ||
                      (task.repeat == 'Hằng tháng' &&
                          DateFormat('dd/MM/yyyy').parse(task.date).day == selectedDate.day)) 
                    {
                      return Dismissible(
                        key: Key(task.id.toString()),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          _taskController.deleteTask(task: task);
                          Loaders.successSnackBar(title: "Xóa nhiệm vụ", message: "Nhiệm vụ đã bị xóa.");
                        },
                        background: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8), 
                          decoration: BoxDecoration(
                            color: Colors.red, 
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 30,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Xóa",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        child: TaskTile(task: task),
                      );

                    } else {
                      return Container();
                    }
                  }
              ),
        ),
      ),
    );
  }


  _noTaskMsg() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/task.svg',
              height: 90,
              semanticsLabel: 'Task',
              color: primaryClr.withOpacity(0.5),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
              child: Text(
                "Chưa có danh sách nhắc nhở nào",
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}