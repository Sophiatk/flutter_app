import 'package:flutter/material.dart';
import 'package:flutter_app/data/dummy_data.dart';
import 'package:flutter_app/models/habit_model.dart';
import 'package:flutter_app/models/category_model.dart';
import 'package:flutter_app/screens/home_screen.dart';
import 'package:flutter_app/screens/add_habit_screen.dart';
import 'package:flutter_app/screens/stats_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF7D4F50);
    const Color secondaryColor = Color(0xFFCC8B86);
    const Color tertiaryColor = Color(0xFFAA998F);

    return MaterialApp(
      title: 'Habitify',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.light,
          primary: primaryColor,
          secondary: secondaryColor,
          tertiary: tertiaryColor,
        ),
        scaffoldBackgroundColor: const Color(0xFFF9EAE1),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
        ),
      ),
      home: const HabitifyApp(),
    );
  }
}

class HabitifyApp extends StatefulWidget {
  const HabitifyApp({super.key});

  @override
  State<HabitifyApp> createState() => _HabitifyAppState();
}

class _HabitifyAppState extends State<HabitifyApp> {
  int _currentIndex = 0;
  late List<Habit> _habits;
  late List<Category> _categories;

  @override
  void initState() {
    super.initState();
    _habits = List.from(dummyHabits);
    _categories = List.from(dummyCategories);
  }

  void _addHabit(Habit habit) {
    setState(() {
      _habits.add(habit);
    });
  }

  void _addCategory(Category category) {
    setState(() {
      _categories.add(category);
    });
  }

  void _navigateToAddHabit() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddHabitScreen(
          onAddHabit: _addHabit,
          categories: _categories,
          onAddCategory: _addCategory,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(
        habits: _habits,
        categories: _categories,
        onAddHabit: _navigateToAddHabit,
      ),
      StatsScreen(
        habits: _habits,
        categories: _categories,
      ),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
        ],
      ),
    );
  }
}
