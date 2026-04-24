import 'package:flutter/material.dart';
import 'package:flutter_app/models/habit_model.dart';
import 'package:flutter_app/models/category_model.dart';
import 'package:flutter_app/widgets/color_picker.dart';

class AddHabitScreen extends StatefulWidget {
  final Function(Habit) onAddHabit;
  final List<Category> categories;
  final Function(Category) onAddCategory;

  const AddHabitScreen({
    super.key,
    required this.onAddHabit,
    required this.categories,
    required this.onAddCategory,
  });

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _newCategoryController = TextEditingController();
  late String _selectedCategoryId;
  late List<Category> _categories;
  Color _selectedNewCategoryColor = const Color(0xFFAA998F);
  bool _isAddingNewCategory = false;

  @override
  void initState() {
    super.initState();
    _categories = List.from(widget.categories);
    _selectedCategoryId = _categories.isNotEmpty ? _categories.first.id : '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _newCategoryController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newHabit = Habit(
        id: DateTime.now().toString(),
        name: _nameController.text.trim(),
        categoryId: _selectedCategoryId,
        isDone: false,
      );

      widget.onAddHabit(newHabit);
      Navigator.of(context).pop();
    }
  }

  void _addNewCategory() {
    if (_newCategoryController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a category name')),
      );
      return;
    }

    final newCategory = Category(
      id: DateTime.now().toString(),
      name: _newCategoryController.text.trim(),
      color: _selectedNewCategoryColor,
    );

    widget.onAddCategory(newCategory);
    setState(() {
      _categories.add(newCategory);
      _selectedCategoryId = newCategory.id;
      _isAddingNewCategory = false;
      _newCategoryController.clear();
      _selectedNewCategoryColor = const Color(0xFFAA998F);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Category "${newCategory.name}" added!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Habit'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 20 : 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Habit Name',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'e.g., Morning Run',
                      prefixIcon: const Icon(Icons.edit),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a habit name';
                      }
                      if (value.trim().length < 2) {
                        return 'Habit name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Category',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  if (!_isAddingNewCategory)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DropdownButtonFormField<String>(
                          value: _selectedCategoryId.isNotEmpty
                              ? _selectedCategoryId
                              : null,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.category),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          items: _categories.map((category) {
                            return DropdownMenuItem(
                              value: category.id,
                              child: Row(
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: category.color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(category.name),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategoryId = value ?? '';
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _isAddingNewCategory = true;
                            });
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add New Category'),
                        ),
                      ],
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _newCategoryController,
                          decoration: InputDecoration(
                            hintText: 'Category name',
                            prefixIcon: const Icon(Icons.label),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a category name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        ColorPickerWidget(
                          selectedColor: _selectedNewCategoryColor,
                          onColorSelected: (color) {
                            setState(() {
                              _selectedNewCategoryColor = color;
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        ElevatedButton.icon(
                          onPressed: _addNewCategory,
                          icon: const Icon(Icons.check),
                          label: const Text('Create Category'),
                        ),
                        const SizedBox(height: 8),

                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _isAddingNewCategory = false;
                              _newCategoryController.clear();
                              _selectedNewCategoryColor =
                                  const Color(0xFFAA998F);
                            });
                          },
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                  const SizedBox(height: 32),

                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Save Habit',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 12),

                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
