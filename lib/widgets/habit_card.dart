import 'package:flutter/material.dart';
import 'package:flutter_app/models/habit_model.dart';
import 'package:flutter_app/models/category_model.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final Category? category;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback? onChangeCategory;

  const HabitCard({
    super.key,
    required this.habit,
    required this.category,
    required this.onToggle,
    required this.onDelete,
    this.onChangeCategory,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColor = category?.color ?? Colors.grey;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Checkbox(
          value: habit.isDone,
          onChanged: (_) => onToggle(),
          activeColor: categoryColor,
        ),
        title: Text(
          habit.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            decoration: habit.isDone ? TextDecoration.lineThrough : null,
            color: habit.isDone ? const Color(0xFF7D4F50).withOpacity(0.6) : null,
          ),
        ),
        subtitle: GestureDetector(
          onTap: onChangeCategory,
          child: Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: categoryColor.withOpacity(0.25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              category?.name ?? 'Unknown',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: categoryColor.withOpacity(0.85),
              ),
            ),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
          tooltip: 'Delete habit',
        ),
      ),
    );
  }
}
