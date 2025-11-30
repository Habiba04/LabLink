import 'package:flutter/material.dart';

class FilterBar extends StatelessWidget {
  final List<String> items;
  final String selected;
  final ValueChanged<String> onSelected;

  const FilterBar({
    required this.items,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double pillWidth = (constraints.maxWidth - 8) / items.length;

        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(25),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                left: items.indexOf(selected) * pillWidth,
                top: 0,
                bottom: 0,
                child: Container(
                  width: pillWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),

              Row(
                children: items.map((text) {
                  bool isActive = selected == text;
                  return GestureDetector(
                    onTap: () => onSelected(text),
                    child: SizedBox(
                      width: pillWidth,
                      height: 30,
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: isActive
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: Colors.black87,
                          ),
                          child: Text(text),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
