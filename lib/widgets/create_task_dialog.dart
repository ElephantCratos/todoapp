import 'package:flutter/material.dart';

class CreateTaskDialog extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController titleController;
  final TextEditingController dateController;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const CreateTaskDialog({
    super.key,
    required this.controller,
    required this.titleController,
    required this.dateController,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 350,
        width: 350,
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: "Заголовок задачи",
              ),
              maxLength: 100,
            ),
            TextField(
              controller: dateController,
              keyboardType: TextInputType.datetime,
              decoration: const InputDecoration(
                hintText: "Дата",
              ),
              maxLength: 100,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: "Описание задачи",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                  maxLength: 100,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                if (titleController.text.trim().isNotEmpty &&
                    controller.text.trim().isNotEmpty) {
                  onSave();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Заполните все поля!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text("Save"),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {
                titleController.clear();
                controller.clear();
                onCancel();
              },
              child: const Text("Cancel"),
            ),
          ],
        ),
      ],
    );
  }
}
