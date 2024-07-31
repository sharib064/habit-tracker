import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget {
  final String text;
  final bool isCompleted;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? editHabit;
  final void Function(BuildContext)? deleteHabit;
  const HabitTile(
      {super.key,
      required this.text,
      required this.isCompleted,
      required this.onChanged,
      required this.editHabit,
      required this.deleteHabit});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: editHabit,
            backgroundColor: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(8),
            icon: Icons.edit,
          ),
          const SizedBox(
            width: 5,
          ),
          SlidableAction(
            onPressed: deleteHabit,
            backgroundColor: Colors.red,
            icon: Icons.delete,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(
            width: 5,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          if (onChanged != null) {
            onChanged!(!isCompleted);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: isCompleted
                ? Colors.green
                : Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: ListTile(
            title: Text(
              text,
              style: TextStyle(
                color: isCompleted
                    ? Colors.white
                    : Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            leading: Checkbox(
              side: BorderSide(
                  color: Theme.of(context).colorScheme.inversePrimary),
              checkColor: Colors.white,
              value: isCompleted,
              onChanged: onChanged,
              activeColor: Colors.green,
            ),
          ),
        ),
      ),
    );
  }
}
