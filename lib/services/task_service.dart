import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TaskService {
  List<List<dynamic>> toDoList = [];

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksData = prefs.getString('todoList');
    if (tasksData != null) {
      toDoList = List<List<dynamic>>.from(
        json.decode(tasksData).where((item) {
          return item is List &&
              item.length == 4 &&
              item[1].toString().trim().isNotEmpty &&
              item[2].toString().trim().isNotEmpty &&
              item[3].toString().trim().isNotEmpty;
        }).toList(),
      );
    }
  }

  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String tasksData = json.encode(toDoList);
    await prefs.setString('todoList', tasksData);
  }

  void toggleTaskStatus(int index) {
    toDoList[index][0] = !toDoList[index][0];
  }

  void editTask(int index, String name, String title, String date) {
    toDoList[index][1] = name;
    toDoList[index][2] = title;
    toDoList[index][3] = date;
  }

  void addTask(String name, String title, String date) {
    toDoList.add([false, name, title, date]);
  }

  void deleteTask(int index) {
    toDoList.removeAt(index);
  }
}
