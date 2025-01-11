// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vlu_project_1/features/home/models/task.dart';
import 'package:vlu_project_1/features/home/screens/add_task_bar.dart';
import 'package:vlu_project_1/shared/size_config.dart';

class TaskTile extends StatelessWidget {
  final Task? task;

  const TaskTile({super.key, this.task});

  @override
  Widget build(BuildContext context) {
    if (task == null) {
      return Container();
    }

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        width: SizeConfig.screenWidth * 0.78,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: _getBGClr(task?.color ?? 0),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tiêu đề: ${task?.title ?? ""}",
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey[200],
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            task?.startTime ?? "",
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontSize: 13, color: Colors.grey[100]),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Ghi chú: ${task?.note ?? ""} - Lặp lại: ${task?.repeat ?? "Không lặp"}",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(fontSize: 15, color: Colors.grey[100]),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 60,
                  width: 0.5,
                  color: Colors.grey[200]!.withOpacity(0.7),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    Get.to(() => AddTaskPage(task: task));
                  },
                ),
              ],
            ),       
          ],
        ),
      ),
    );
  }



  _getBGClr(int no) {
    switch (no) {
      case 0:
        return Colors.blue;
      case 1: 
        return Colors.red[600];
      case 2:
        return Colors.indigo[600];
      case 3:
        return Colors.orange[600];
      case 4:
        return Colors.purple[600];
      default:
        return Colors.blue;
    }
  }
}