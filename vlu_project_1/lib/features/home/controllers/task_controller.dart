// ignore_for_file: unused_local_variable

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

  void addTask({required Task? task}) async {
    await dbHelper.insert(task);
    getTasks();
  }

  void deleteask({required Task task}) async {
    await NotifyHelper.cancelNotififcationWithID(task.id!);
    await dbHelper.delete(task.id!);
    getTasks();
  }

  void markTaskAsCompleted({required Task task}) async {
    var value = await dbHelper.update(task.id!);
    getTasks();
  }

  void deleteAllTask() async {
    await NotifyHelper.cancelAllNotififcation();
    await dbHelper.deleteAll();
    taskList.clear();
    update();
  }
}