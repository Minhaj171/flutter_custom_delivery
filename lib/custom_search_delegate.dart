import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
  // Simulating a list of search data
  final List<String> searchItems = [
    'Apple',
    'Banana',
    'Orange',
    'Mango',
    'Pineapple',
    'Grapes',
  ];

  // Sample categories to filter by
  final List<String> categories = ['All', 'Fruits', 'Citrus', 'Berries'];

  String selectedCategory = 'All'; // Default filter

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<String> filteredList = applyFilters(searchItems);

    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(filteredList[index]),
          onTap: () {
            close(context, filteredList[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> filteredList = applyFilters(searchItems);

    return Column(
      children: [
        // Filter dropdown for categories
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<String>(
            value: selectedCategory,
            items: categories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (String? newValue) {
              selectedCategory = newValue!;
              // Trigger a rebuild when the filter changes
              showSuggestions(context);
            },
          ),
        ),
        // Display filtered suggestions
        Expanded(
          child: ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(filteredList[index]),
                onTap: () {
                  query = filteredList[index];
                  showResults(context);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // Function to apply filters based on selected category and query
  List<String> applyFilters(List<String> items) {
    List<String> filteredItems = items
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();

    // Apply category filter (example logic)
    if (selectedCategory == 'Citrus') {
      filteredItems =
          filteredItems.where((item) => item == 'Orange' || item == 'Mango').toList();
    } else if (selectedCategory == 'Berries') {
      filteredItems =
          filteredItems.where((item) => item == 'Grapes').toList();
    }

    return filteredItems;
  }
}