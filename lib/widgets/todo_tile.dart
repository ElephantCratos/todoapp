import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ToDoTile extends StatelessWidget {
  final bool isDone;
  final String name;
  final String title;
  final String date;
  Function(bool?)? changeStatus;
  Function(BuildContext)? deleteFunction;
  Function()? editFunction;

  ToDoTile({
    super.key,
    required this.isDone,
    required this.name,
    required this.title,
    required this.date,
    required this.changeStatus,
    required this.deleteFunction,
    required this.editFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: isDone,
                      onChanged: changeStatus,
                      activeColor: Colors.black,
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: editFunction,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => deleteFunction?.call(context),
                    ),
                    Text(
                      date,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
