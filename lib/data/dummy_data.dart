import 'package:flutter/material.dart';
import 'package:flutter_app/models/habit_model.dart';
import 'package:flutter_app/models/category_model.dart';

final List<Category> dummyCategories = [
  Category(
    id: '1',
    name: 'Health',
    color: const Color(0xFFCC8B86),
  ),
  Category(
    id: '2',
    name: 'Fitness',
    color: const Color(0xFF88B04B),
  ),
  Category(
    id: '3',
    name: 'Study',
    color: const Color(0xFF92A8D1),
  ),
  Category(
    id: '4',
    name: 'Productivity',
    color: const Color(0xFFB5A92E),
  ),
  Category(
    id: '5',
    name: 'Personal',
    color: const Color(0xFFAA998F),
  ),
];

final List<Habit> dummyHabits = [
  Habit(
    id: '1',
    name: 'Morning Run',
    categoryId: '2',
    isDone: false,
  ),
  Habit(
    id: '2',
    name: 'Study Flutter',
    categoryId: '3',
    isDone: true,
  ),
  Habit(
    id: '3',
    name: 'Drink Water',
    categoryId: '1',
    isDone: false,
  ),
  Habit(
    id: '4',
    name: 'Read a Book',
    categoryId: '4',
    isDone: true,
  ),
  Habit(
    id: '5',
    name: 'Meditate',
    categoryId: '1',
    isDone: false,
  ),
];
