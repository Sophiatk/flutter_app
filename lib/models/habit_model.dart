class Habit {
  final String id;
  final String name;
  final String categoryId;
  bool isDone;

  Habit({
    required this.id,
    required this.name,
    required this.categoryId,
    this.isDone = false,
  });

  // Create a copy with modifications
  Habit copyWith({
    String? id,
    String? name,
    String? categoryId,
    bool? isDone,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      isDone: isDone ?? this.isDone,
    );
  }
}
