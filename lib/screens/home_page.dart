import 'package:flutter/material.dart';

import '../widgets/create_task_dialog.dart';
import '../widgets/todo_tile.dart';
import '../services/task_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final TaskService taskService = TaskService();
  int _filterIndex = 0;

  @override
  void initState() {
    super.initState();
    taskService.loadTasks().then((_) {
      setState(() {});
    });
  }

  void checkboxChanged(bool? value, int index) {
    setState(() {
      taskService.toggleTaskStatus(index);
    });
    taskService.saveTasks();
  }

  void createTask() {
    showDialog(
      context: context,
      builder: (context) {
        return CreateTaskDialog(
          controller: _controller,
          titleController: _titleController,
          dateController: _dateController,
          onSave: () {
            saveTask();
          },
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void editTask(int index) {
    _controller.text = taskService.toDoList[index][1];
    _titleController.text = taskService.toDoList[index][2];
    _dateController.text = taskService.toDoList[index][3];
    showDialog(
      context: context,
      builder: (context) {
        return CreateTaskDialog(
          controller: _controller,
          titleController: _titleController,
          dateController: _dateController,
          onSave: () {
            if (_titleController.text.trim().isNotEmpty &&
                _controller.text.trim().isNotEmpty &&
                _dateController.text.trim().isNotEmpty) {
              setState(() {
                taskService.editTask(index, _controller.text,
                    _titleController.text, _dateController.text);
                _controller.clear();
                _titleController.clear();
                _dateController.clear();
              });
              taskService.saveTasks();
              Navigator.of(context).pop();
            }
          },
          onCancel: () {
            _controller.clear();
            _titleController.clear();
            _dateController.clear();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void saveTask() {
    if (_titleController.text.trim().isNotEmpty &&
        _controller.text.trim().isNotEmpty &&
        _dateController.text.trim().isNotEmpty) {
      setState(() {
        taskService.addTask(
            _controller.text, _titleController.text, _dateController.text);
        _controller.clear();
        _titleController.clear();
        _dateController.clear();
      });
      taskService.saveTasks();
      Navigator.of(context).pop();
    }
  }

  void deleteTask(int index) {
    setState(() {
      taskService.deleteTask(index);
    });
    taskService.saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    List<List<dynamic>> filteredTasks;
    if (_filterIndex == 0) {
      filteredTasks = taskService.toDoList;
    } else if (_filterIndex == 1) {
      filteredTasks =
          taskService.toDoList.where((task) => task[0] == true).toList();
    } else {
      filteredTasks =
          taskService.toDoList.where((task) => task[0] == false).toList();
    }

    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Список дел'),
        actions: [
          IconButton(
            icon: Icon(_filterIndex == 0
                ? Icons.filter_list
                : (_filterIndex == 1
                    ? Icons.check_circle
                    : Icons.circle_outlined)),
            onPressed: () {
              setState(() {
                _filterIndex = (_filterIndex + 1) % 3;
              });
            },
          ),
        ],
      ),
      floatingActionButton:
          FloatingActionButton(onPressed: createTask, child: const Text("+")),
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80.0),
        itemCount: filteredTasks.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            isDone: filteredTasks[index][0],
            name: filteredTasks[index][1],
            title: filteredTasks[index][2],
            date: filteredTasks[index][3],
            changeStatus: (value) => checkboxChanged(
                value, taskService.toDoList.indexOf(filteredTasks[index])),
            deleteFunction: (context) =>
                deleteTask(taskService.toDoList.indexOf(filteredTasks[index])),
            editFunction: () =>
                editTask(taskService.toDoList.indexOf(filteredTasks[index])),
          );
        },
      ),
    );
  }
}
