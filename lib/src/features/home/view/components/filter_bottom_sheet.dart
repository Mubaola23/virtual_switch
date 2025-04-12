import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_switch/src/core/app_colors.dart';
import 'package:virtual_switch/src/features/home/controller/home_view_controller.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeViewController>();

    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Filter & Sort',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Categories
              const Text(
                'Categories',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    controller.categories.map((category) {
                      final isSelected =
                          controller.selectedCategory == category;
                      return FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          setModalState(() {
                            controller.selectedCategory = category;
                          });
                        },
                        backgroundColor: Colors.grey.shade200,
                        selectedColor: primaryColor.shade100,
                        checkmarkColor: primaryColor,
                      );
                    }).toList(),
              ),
              const SizedBox(height: 24),

              // Sort by
              const Text(
                'Sort by',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Newest'),
                      value: 'newest',
                      groupValue: controller.sortBy,
                      onChanged: (value) {
                        setModalState(() {
                          controller.sortBy = value!;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Oldest'),
                      value: 'oldest',
                      groupValue: controller.sortBy,
                      onChanged: (value) {
                        setModalState(() {
                          controller.sortBy = value!;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Apply button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    controller.applyFilters();
                    Navigator.pop(context);
                  },
                  child: const Text('Apply Filters'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    setModalState(() {
                      controller.selectedCategory = 'All';
                      controller.sortBy = 'newest';
                    });
                  },
                  child: const Text('Reset'),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        );
      },
    );
  }
}
