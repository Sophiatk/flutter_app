import 'package:flutter/material.dart';
import 'package:flutter_app/models/habit_model.dart';
import 'package:flutter_app/models/category_model.dart';

class StatsScreen extends StatelessWidget {
  final List<Habit> habits;
  final List<Category> categories;

  const StatsScreen({
    super.key,
    required this.habits,
    required this.categories,
  });

  Category? _getCategoryById(String categoryId) {
    try {
      return categories.firstWhere((c) => c.id == categoryId);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalHabits = habits.length;
    final completedHabits = habits.where((h) => h.isDone).length;
    final incompleteHabits = totalHabits - completedHabits;
    final completionPercentage = totalHabits == 0
        ? 0
        : (completedHabits / totalHabits * 100).toStringAsFixed(1);

    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Overview',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 16),

                GridView.count(
                  crossAxisCount: isMobile ? 2 : 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _StatCard(
                      label: 'Total Habits',
                      value: totalHabits.toString(),
                      icon: Icons.list,
                      color: const Color(0xFF7D4F50),
                    ),
                    _StatCard(
                      label: 'Completed',
                      value: completedHabits.toString(),
                      icon: Icons.check_circle,
                      color: const Color(0xFF88B04B),
                    ),
                    _StatCard(
                      label: 'Incomplete',
                      value: incompleteHabits.toString(),
                      icon: Icons.cancel,
                      color: const Color(0xFFB5534A),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                Text(
                  'Completion Rate',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 150,
                          width: 150,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                height: 150,
                                width: 150,
                                child: CircularProgressIndicator(
                                  value: totalHabits == 0
                                      ? 0
                                      : completedHabits / totalHabits,
                                  strokeWidth: 8,
                                  backgroundColor: Colors.grey[300],
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(
                                    Color.lerp(
                                      const Color(0xFFCC8B86),
                                      const Color(0xFFD1BE9C),
                                      totalHabits == 0
                                          ? 0
                                          : completedHabits / totalHabits,
                                    )!,
                                  ),
                                ),
                              ),
                              Text(
                                '$completionPercentage%',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '$completedHabits out of $totalHabits habits completed',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color: const Color(0xFF7D4F50),
                                fontWeight: FontWeight.w600,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                if (habits.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'By Category',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 16),
                      _buildCategoryStats(habits),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryStats(List<Habit> habits) {
    final categoriesInUse = <String, List<Habit>>{};
    for (var habit in habits) {
      categoriesInUse.putIfAbsent(habit.categoryId, () => []).add(habit);
    }

    return Column(
      children: categoriesInUse.entries.map((entry) {
        final categoryId = entry.key;
        final categoryHabits = entry.value;
        final category = _getCategoryById(categoryId);
        final completed = categoryHabits.where((h) => h.isDone).length;
        final total = categoryHabits.length;

        return Card(
          elevation: 1,
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: category?.color ?? Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          category?.name ?? 'Unknown',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '$completed/$total',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF7D4F50),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: total == 0 ? 0 : completed / total,
                    minHeight: 8,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      category?.color ?? Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
