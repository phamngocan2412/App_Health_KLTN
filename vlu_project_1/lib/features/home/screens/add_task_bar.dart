// ignore_for_file: avoid_print, curly_braces_in_flow_control_structures, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vlu_project_1/features/home/controllers/task_controller.dart';
import 'package:vlu_project_1/features/home/models/task.dart';
import 'package:vlu_project_1/features/home/screens/widget_add/color_custom.dart';
import 'package:vlu_project_1/features/home/screens/widget_home/button_add.dart';
import 'package:vlu_project_1/features/home/screens/widget_home/input_filed.dart';
import 'package:vlu_project_1/permission_manager.dart';
import 'package:vlu_project_1/shared/size.dart';
import 'package:vlu_project_1/shared/widgets/loaders.dart';
import 'package:vlu_project_1/shared/widgets/text_string.dart';


class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController taskController = Get.put(TaskController());

  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  final ValueNotifier<DateTime> selectedDate = ValueNotifier(DateTime.now());
  late String startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String selectedRepeat = "Không";
  List<String> repeatList = ["Không", "Hằng ngày", "Hằng tuần", "Hằng tháng"];
  int selectedColor = 0;

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Đảm bảo quyền chỉ được yêu cầu ở đây
    Future.delayed(Duration.zero, () {
      _checkNotiPermissions();
    });
  }

  Future<void> _checkNotiPermissions() async {
    if (!await Permission.notification.isGranted) {
      if (mounted) {
        await PermissionManager.checkAndRequestNotificationPermission(context);
      }
      // Kiểm tra lại sau khi yêu cầu cấp quyền
      if (!await Permission.notification.isGranted) {
        print("Người dùng từ chối quyền thông báo.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _customAppBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: TSize.spaceBtwSections),
              _buildInputField(TText.formTitle, titleController, const Icon(Icons.title_outlined)),
              _buildInputField(TText.noteTitle, noteController, const Icon(Icons.pending_outlined)),
              InputDateFiled(
                hint: TText.dateTitle,
                text: DateFormat('dd/MM/yyyy').format(selectedDate.value),
                widget: IconButton(
                  onPressed: () => _getDateFromUser(),
                  icon: const Icon(Icons.date_range_outlined),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputDateFiled(
                      hint: TText.startTime,
                      text: startTime,
                      widget: IconButton(
                        onPressed: () => _getTimeFromUser(isStartTime: true),
                        icon: const Icon(Icons.access_time_rounded),
                      ),
                    ),
                  ),
                ],
              ),
              InputDateFiled(
                text: selectedRepeat,
                hint: TText.repeatTitle,
                widget: DropdownButton<String>(
                  isExpanded: true,
                  value: selectedRepeat,
                  alignment: AlignmentDirectional.bottomStart,
                  dropdownColor: Colors.lightBlue[50],
                  items: repeatList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    );
                  }).toList(),
                  icon: const Padding(
                    padding: EdgeInsets.only(right: 15.0),
                    child: Icon(Icons.keyboard_arrow_down_outlined),
                  ),
                  elevation: 4,
                  underline: Container(height: 0),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedRepeat = newValue ?? 'Không';
                    });
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ColorPickerWidget(
                    initialSelectedColor: selectedColor,
                    onColorSelected: (int colorIndex) {
                      setState(() {
                        selectedColor = colorIndex;
                      });
                    },
                  ),
                  ButtonAdd(
                    label: TText.creatTask,
                    onTap: () async {
                      await _validateDate();
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String hint, TextEditingController controller, Icon icon) {
    return InputField(
      hint: hint,
      text: TText.subTitle,
      icon: icon,
      controller: controller,
    );
  }

  AppBar _customAppBar() {
    return AppBar(
      elevation: 2,
      shadowColor: Colors.black,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: const Text('Thêm Nhắc Nhở'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () => Get.back(),
      ),
    );
  }

  Future<void> _validateDate() async {
    if (titleController.text.isNotEmpty && noteController.text.isNotEmpty) {
      await _addTaskToDb();
      Get.back();
      Loaders.successSnackBar(title: "Thêm nhắc nhở", message: "Bạn đã thêm một nhắc nhở: ${titleController.text}");
    } else {
      Loaders.warningSnackBar(
        title: "Yêu cầu",
        message: "Tất cả các trường là bắt buộc!",
      );
    }
  }

  Future<void> _addTaskToDb() async {
    taskController.addTask(
      task: Task(
        id: null,
        title: titleController.text,
        note: noteController.text,
        isCompleted: 0,
        date: DateFormat('dd/MM/yyyy').format(selectedDate.value),
        startTime: startTime,
        color: selectedColor,
        repeat: selectedRepeat,
      ),
    );
  }

  Future<void> _getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2015),
      lastDate: DateTime(2150),
      initialDate: DateTime.now(),
      errorFormatText: 'Nhập đúng định dạng ngày',
      errorInvalidText: 'Ngày không hợp lệ, vui lòng chọn trong khoảng thời gian hợp lệ',
      helpText: 'Chọn ngày',
      cancelText: "Thoát",
      confirmText: "Ok",
    );
    if (pickerDate != null) {
      setState(() {
        selectedDate.value = pickerDate;
      });
    }
  }

  Future<void> _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      String formattedTime = pickedTime.format(context);
      if (isStartTime) {
        setState(() {
          startTime = formattedTime;
        });
      }
    }
  }
}
