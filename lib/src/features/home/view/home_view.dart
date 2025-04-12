import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:virtual_switch/src/core/app_colors.dart';
import 'package:virtual_switch/src/core/helper.dart';
import 'package:virtual_switch/src/features/home/controller/home_view_controller.dart';
import 'package:virtual_switch/src/features/home/model/post_model.dart';
import 'package:virtual_switch/src/features/home/view/components/empty_data_widget.dart';
import 'package:virtual_switch/src/features/home/view/components/filter_bottom_sheet.dart';
import 'package:virtual_switch/src/features/home/view/item_details_screen.dart';

class DataExplorerScreen extends StatefulWidget {
  const DataExplorerScreen({super.key});

  @override
  State<DataExplorerScreen> createState() => _DataExplorerScreenState();
}

class _DataExplorerScreenState extends State<DataExplorerScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeViewController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Virtual Books',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Search and filter bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon:
                          controller.searchQuery.isNotEmpty
                              ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  controller.searchController.clear();
                                  controller.onSearchChanged('');
                                },
                              )
                              : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onChanged: controller.onSearchChanged,
                  ),
                ),
                const SizedBox(width: 8),
                Material(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      controller.updateFilterBottomSheet(val: true);

                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) {
                          return FilterBottomSheet();
                        },
                      ).then((_) {
                        controller.updateFilterBottomSheet(val: false);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: const Icon(Icons.filter_list, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Active filters display
          if (controller.selectedCategory != 'All' ||
              controller.sortBy != 'newest') ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    'Filters: ${controller.selectedCategory != 'All' ? controller.selectedCategory : ''}'
                    '${controller.selectedCategory != 'All' && controller.sortBy != 'newest' ? ', ' : ''}'
                    '${controller.sortBy != 'newest' ? 'Sorted by ${controller.sortBy.toUpperCase()}' : ''}',
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      color: primaryColor,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    icon: const Icon(Icons.clear, size: 18),
                    label: const Text('Reset'),
                    onPressed: controller.resetFilters,
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
            ),
          ],

          Expanded(
            child:
                controller.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : controller.isError
                    ? ErrorWidget(controller.fetchData)
                    : controller.filteredData.isEmpty
                    ? EmptyDataWidget(onPressed: controller.resetFilters)
                    : _buildDataList(
                      onRefresh: controller.fetchData,
                      filteredData: controller.filteredData,
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataList({
    required Future<void> Function() onRefresh,
    required List<PostModel> filteredData,
  }) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: filteredData.length,
        itemBuilder: (context, index) {
          final item = filteredData[index];

          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              onTap: () {
                _showItemDetails(item);
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.image_not_supported),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            toBeginningOfSentenceCase(item.title),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            toBeginningOfSentenceCase(item.body),
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Chip(
                                label: Text(
                                  toBeginningOfSentenceCase(item.category),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: primaryColor,
                                padding: EdgeInsets.zero,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                              const Spacer(),
                              Text(
                                formatDate(item.date.toString()),
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showItemDetails(PostModel item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ItemDetailsScreen(item: item)),
    );
  }
}
