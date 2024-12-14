

// ignore_for_file: avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vlu_project_1/core/services/notification_services.dart';
import 'package:vlu_project_1/core/utils/assets/theme.dart';
import 'package:vlu_project_1/features/home/controllers/task_controller.dart';
import 'package:vlu_project_1/features/home/models/task.dart';
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

    // Đảm bảo quyền chỉ được yêu cầu ở đây
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
      // Kiểm tra lại sau khi yêu cầu cấp quyền
      if (!await Permission.storage.isGranted) {
        print("Người dùng từ chối quyền lưu trữ.");
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
                    if (startTime.contains("PM") && hour != 12) {
                      hour += 12;
                    }
                    NotifyHelper.showScheduleNotification(task: task ,hour :hour, minutes: minute);

                    if ((task.repeat == 'Hằng ngày') ||
                      (task.date == DateFormat('dd/MM/yyyy').format(selectedDate)) ||
                      (task.repeat == 'Hằng tuần' &&
                          selectedDate.difference(DateFormat('dd/MM/yyyy').parse(task.date)).inDays % 7 == 0) ||
                      (task.repeat == 'Hằng tháng' &&
                          DateFormat('dd/MM/yyyy').parse(task.date).day == selectedDate.day)) 
                    {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 800),
                        child: SlideAnimation(
                          verticalOffset: 300,
                          child: FadeInAnimation(
                            child: Dismissible(
                              key: Key(task.id.toString()),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                _taskController.deleteask(task: task);
                                Loaders.successSnackBar(title: "Xóa nhiệm vụ", message: "Nhiệm vụ đã bị xóa.");
                              },
                              background: Container(
                                color: Colors.red, // Màu nền khi lướt qua
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () => _showBottomSheet(context, task),
                                child: TaskTile(task: task),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return _noTaskMsg();
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


  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        height: task.isCompleted == 1
            ? MediaQuery.of(context).size.height * 0.24
            : MediaQuery.of(context).size.height * 0.32,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[300],
              ),
            ),
            const Spacer(),
            task.isCompleted == 1
                ? Container()
                : _bottomSheetButton(
                    label: "Nhắc nhở hoàn thành",
                    onTap: () {
                      NotifyHelper.cancelNotififcationWithID(task.id!);
                      _taskController.markTaskAsCompleted(task : task);
                      Get.back();
                      Loaders.successSnackBar(title: "Nhắc nhở", message:"Đã đóng");
                    },
                    clr: Colors.blue,
                  ),
            const SizedBox(height: 5),
            _bottomSheetButton(
              label: "Xóa nhắc nhở",
              onTap: () {
                _taskController.deleteask(task : task);
                Get.back();
              },
              clr: Colors.red[300]!,
            ),
            const SizedBox(height: 20),
            _bottomSheetButton(
              label: "Đóng",
              onTap: () {
                Get.back();
              },
              clr: Colors.white,
              isClose: true,
            ),
            const SizedBox(height: 10),
          ],
        ),
      )
    ));
  }

  _bottomSheetButton({
    required String label,
    required Function() onTap,
    required Color clr,
    bool isClose = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: isClose ? Colors.grey[600]! : clr,
            ),
            borderRadius: BorderRadius.circular(25),
            color: isClose ? Colors.transparent : clr),
        child: Center(
          child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}