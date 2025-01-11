// ignore_for_file: unused_local_variable, avoid_print

import 'package:get/get.dart';
import 'package:vlu_project_1/core/services/notification_services.dart';
import 'package:vlu_project_1/features/home/models/database_helper.dart';
import 'package:vlu_project_1/features/home/models/task.dart';


class TaskController extends GetxController {
  RxList taskList = <Task>[].obs;
  DBHelper dbHelper = DBHelper();

  Future<void> getTasks() async {
    final tasks = await dbHelper.query();

    taskList.assignAll(tasks.map((e) => Task.fromMap(e)).toList());

    update();
  }

  Future<void> getTasksByRepeat(String repeat) async {
    final tasks = await dbHelper.queryByRepeat(repeat);
    taskList.assignAll(tasks.map((e) => Task.fromMap(e)).toList());
    update();
  }

  void addTask({required Task? task}) async {
    await dbHelper.insert(task);
    getTasks();
  }

  void deleteTask({required Task task}) async {
    await NotifyHelper.cancelNotififcationWithID(task.id!);
    await dbHelper.delete(task.id!);
    getTasks();
  }

  Future<void> updateTask(Task task) async {
    int result = await DBHelper().update(task);
    if (result > 0) {
      print("Cập nhật thành công task với id: ${task.id}");
      int index = taskList.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        taskList[index] = task; 
        update(); 
      }
    } else {
      print("Cập nhật thất bại.");
    }
  }




  void deleteAllTask() async {
    await NotifyHelper.cancelAllNotififcation();
    await dbHelper.deleteAll();
    taskList.clear();
    update();
  }
}
