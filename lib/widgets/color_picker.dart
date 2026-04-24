import 'package:flutter/material.dart';

class ColorPickerWidget extends StatefulWidget {
  final Color selectedColor;
  final Function(Color) onColorSelected;

  const ColorPickerWidget({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  State<ColorPickerWidget> createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  late Color _selectedColor;

  static final List<Color> colorPalette = [
    const Color(0xFFAA998F),
    const Color(0xFFD1BE9C),
    const Color(0xFF7D4F50),
    const Color(0xFFF9EAE1),
    const Color(0xFFCC8B86),
    const Color(0xFF6B5B95),
    const Color(0xFF88B04B),
    const Color(0xFFF7CAC9),
    const Color(0xFF92A8D1),
    const Color(0xFF955251),
    const Color(0xFFB5A92E),
    const Color(0xFF009B77),
  ];

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.selectedColor;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Color',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: colorPalette.length,
          itemBuilder: (context, index) {
            final color = colorPalette[index];
            final isSelected = color.value == _selectedColor.value;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = color;
                });
                widget.onColorSelected(color);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.transparent,
                    width: 3,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      )
                    : null,
              ),
            );
          },
        ),
      ],
    );
  }
}
