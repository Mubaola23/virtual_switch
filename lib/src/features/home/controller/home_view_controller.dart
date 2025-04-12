import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:virtual_switch/src/features/home/model/post_model.dart';

class HomeViewController extends ChangeNotifier {
  HomeViewController() {
    fetchData();
  }
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  final List<PostModel> allData = [];
  List<PostModel> filteredData = [];
  bool isLoading = true;
  bool isError = false;
  String searchQuery = '';
  bool showFilterSheet = false;
  String selectedCategory = 'All';
  String sortBy = 'newest';
  final List<String> categories = [
    'All',
    'Technology',
    'Science',
    'Business',
    'Health',
  ];

  final TextEditingController searchController = TextEditingController();

  updateFilterBottomSheet({bool val = false}) {
    showFilterSheet = val;
    notifyListeners();
  }

  Future<void> fetchData() async {
    try {
      isLoading = true;
      isError = false;
      notifyListeners();

      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        // Process the data after getting response form api request
        final processedData =
            jsonData.map((item) {
              final randomCategory =
                  categories[(1 + (item['id'] % (categories.length - 1)))
                      .toInt()];
              final daysAgo = (item['id'] % 30) + 1;
              final date = DateTime.now().subtract(Duration(days: daysAgo));

              return PostModel.fromJson({
                'id': item['id'],
                'title': item['title'],
                'body': item['body'],
                'category': randomCategory,
                'date': date.toIso8601String(),
                'imageUrl':
                    'https://rickandmortyapi.com/api/character/avatar/${item['id']}.jpeg',
              });
            }).toList();

        allData.clear();
        allData.addAll(List<PostModel>.from(processedData));
        applyFilters();
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        isError = true;
        notifyListeners();
        throw Exception('Unable to fetch data');
      }
    } catch (e) {
      isLoading = false;
      isError = true;
      notifyListeners();
    }
  }

  void applyFilters() {
    selectedCategory = selectedCategory;
    sortBy = sortBy;
    // Filter by search query
    var result =
        allData.where((item) {
          final title = item.title.toLowerCase();
          final body = item.body.toString().toLowerCase();
          final query = searchQuery.toLowerCase();

          return title.contains(query) || body.contains(query);
        }).toList();

    // Filter by category
    if (selectedCategory != 'All') {
      result =
          result.where((item) => item.category == selectedCategory).toList();
    }

    // Sort the data
    result.sort((a, b) {
      final dateA = a.date;
      final dateB = b.date;

      return sortBy == 'newest'
          ? dateB.compareTo(dateA)
          : dateA.compareTo(dateB);
    });

    filteredData = result;
    notifyListeners();
  }

  void onSearchChanged(String query) {
    searchQuery = query;
    applyFilters();
    notifyListeners();
  }

  void resetFilters() {
    selectedCategory = 'All';
    sortBy = 'newest';
    searchController.clear();
    searchQuery = '';
    applyFilters();
    notifyListeners();
  }
}
