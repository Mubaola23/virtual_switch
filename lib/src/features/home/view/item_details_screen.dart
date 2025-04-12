import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:virtual_switch/src/core/app_colors.dart';
import 'package:virtual_switch/src/core/helper.dart';
import 'package:virtual_switch/src/features/home/model/post_model.dart';

class ItemDetailsScreen extends StatelessWidget {
  final PostModel item;

  const ItemDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Item Details')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                item.imageUrl.toString(),
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Chip(
                        label: Text(
                          toBeginningOfSentenceCase(item.category),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: primaryColor,
                      ),
                      const Spacer(),
                      Text(
                        formatDateAndTime(item.date.toString()),
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Text(
                    toBeginningOfSentenceCase(item.title),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    toBeginningOfSentenceCase(item.body),
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 24),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildDetailRow('ID', '#${item.id}'),
                          const Divider(),
                          _buildDetailRow('Category', item.category),
                          const Divider(),
                          _buildDetailRow(
                            'Published',
                            formatDateAndTime(item.date.toString()),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {},
                tooltip: 'Save',
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {},
                tooltip: 'Share',
              ),
              IconButton(
                icon: const Icon(Icons.bookmark_border),
                onPressed: () {},
                tooltip: 'Bookmark',
              ),
              IconButton(
                icon: const Icon(Icons.download),
                onPressed: () {},
                tooltip: 'Download',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
