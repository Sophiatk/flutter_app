import 'package:flutter/material.dart';
import 'package:flutter_app/models/habit_model.dart';
import 'package:flutter_app/models/category_model.dart';
import 'package:flutter_app/data/dummy_data.dart';
import 'package:flutter_app/widgets/habit_card.dart';

class HomeScreen extends StatefulWidget {
  final List<Habit> habits;
  final List<Category> categories;
  final VoidCallback onAddHabit;

  const HomeScreen({
    super.key,
    required this.habits,
    required this.categories,
    required this.onAddHabit,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Habit> _habits;

  @override
  void initState() {
    super.initState();
    _habits = List.from(widget.habits);
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.habits != widget.habits) {
      setState(() {
        _habits = List.from(widget.habits);
      });
    }
  }

  void _toggleHabit(int index) {
    setState(() {
      _habits[index].isDone = !_habits[index].isDone;
    });
  }

  void _deleteHabit(int index) {
    final deletedHabit = _habits[index];
    setState(() {
      _habits.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Habit deleted',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF7D4F50),
        duration: const Duration(seconds: 4),
        dismissDirection: DismissDirection.horizontal,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        action: SnackBarAction(
          label: 'Undo',
          textColor: const Color(0xFFD1BE9C),
          onPressed: () {
            setState(() {
              _habits.insert(index, deletedHabit);
            });
          },
        ),
      ),
    );
  }

  Category? _getCategoryById(String categoryId) {
    try {
      return widget.categories.firstWhere((c) => c.id == categoryId);
    } catch (e) {
      return null;
    }
  }

  void _changeHabitCategory(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        color: const Color(0xFFF9EAE1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Change Category',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.categories.length,
                itemBuilder: (context, catIndex) {
                  final category = widget.categories[catIndex];
                  final isSelected = _habits[index].categoryId == category.id;
                  return ListTile(
                    leading: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: category.color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Colors.black, width: 2)
                            : null,
                      ),
                    ),
                    title: Text(category.name),
                    trailing:
                        isSelected ? const Icon(Icons.check) : null,
                    onTap: () {
                      setState(() {
                        _habits[index] = _habits[index]
                            .copyWith(categoryId: category.id);
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habitify'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: _habits.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No habits yet',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add your first habit to get started',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: _habits.length,
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: isMobile ? 0 : 16,
                ),
                itemBuilder: (context, index) {
                  final category = _getCategoryById(_habits[index].categoryId);
                  return HabitCard(
                    habit: _habits[index],
                    category: category,
                    onToggle: () => _toggleHabit(index),
                    onDelete: () => _deleteHabit(index),
                    onChangeCategory: () => _changeHabitCategory(index),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onAddHabit,
        tooltip: 'Add habit',
        child: const Icon(Icons.add),
      ),
    );
  }
}
