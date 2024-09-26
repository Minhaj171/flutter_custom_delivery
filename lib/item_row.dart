import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'custom_chip.dart';

class HotSalesPage extends StatefulWidget {
  const HotSalesPage({super.key});
  @override
  State<HotSalesPage> createState() => _HotSalesPageState();
}

class _HotSalesPageState extends State<HotSalesPage> {
  final List<Map<String, dynamic>> chipData = [
    {'icon': Icons.headphones, 'label': 'Headset', 'isSelected': true},
    {'icon': Icons.earbuds, 'label': 'Earphone', 'isSelected': false},
    {'icon': Icons.speaker, 'label': 'Speaker', 'isSelected': false},
    {'icon': Icons.smart_display, 'label': 'Smart Display', 'isSelected': false},
  ];
  List<Map<String, dynamic>> items2 = [
    {
      'itemId': 1,
      'productPhoto':
      'https://adminapi.applegadgetsbd.com/storage/media/large/MacBook-Air-M2-15-inch-8-CPU-10-GPU-Silver-4066.jpg',
      'productName': 'MacBook Air M1',
      'categoryName': 'Laptops',
      'brandName': 'Apple',
      'typeName': 'Product',
      'status': 'true',
      'productId': '12345',
      'sellingPrice': 999.99,
      'totalStock': 10,
      'isFromItemGroup': false,
    },
    {
      'itemId': 2,
      'productPhoto':
      'https://dvf83rt16ac4w.cloudfront.net/upload/product/20211110_1636549088_550946.png',
      'productName': 'MacBook Pro M1',
      'categoryName': 'Laptops',
      'brandName': 'Apple',
      'typeName': 'Product',
      'status': 'true',
      'productId': '67890',
      'sellingPrice': 1299.99,
      'totalStock': 5,
      'isFromItemGroup': false,
    },
    {
      'itemId': 3,
      'productPhoto': 'https://via.placeholder.com/150',
      'productName': 'MacBook Air M1',
      'categoryName': 'Laptops',
      'brandName': 'Apple',
      'typeName': 'Product',
      'status': 'true',
      'productId': '12345',
      'sellingPrice': 999.99,
      'totalStock': 10,
      'isFromItemGroup': false,
    },
    {
      'itemId': 4,
      'productPhoto': 'https://via.placeholder.com/150',
      'productName': 'MacBook Pro M1',
      'categoryName': 'Laptops',
      'brandName': 'Apple',
      'typeName': 'Product',
      'status': 'true',
      'productId': '67890',
      'sellingPrice': 1299.99,
      'totalStock': 5,
      'isFromItemGroup': false,
    },
  ];
  final List<Map<String, dynamic>> items = [
    {
      'itemId': 1,
      'productPhoto': 'https://adminapi.applegadgetsbd.com/storage/media/large/MacBook-Air-M2-15-inch-8-CPU-10-GPU-Silver-4066.jpg',
      'productName': 'MacBook Air M1',
      'brandName': 'Apple',
      'sellingPrice': 999.99,
    },
    // More items...
  ];
  final List<Map<String, dynamic>> categories = [
    {'imageUrl': 'https://adminapi.applegadgetsbd.com/...', 'label': 'Walton'},
    {'imageUrl': 'https://adminapi.applegadgetsbd.com/...', 'label': 'Pran'},
    // More categories...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: searchBarWithCategories(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              buildChipList(),
              Divider(height: 1, color: Colors.grey[200]),
              buildTitleWithSwitch('Products', (value) {}),
              buildCategoryChips(),
              SizedBox(height: 10),
              buildItemsGrid(context, items2),
              buildTitleWithSwitch('Services', (value) {}),
              buildItemsGrid(context, items),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => (),
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
    );
  }

  Widget buildChipList() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: chipData.length,
        itemBuilder: (context, index) {
          final chip = chipData[index];
          return CustomChip(data: chip, onClick: (value){});
        },
      ),
    );
  }

  Widget buildTitleWithSwitch(String title, Function(bool) onChanged) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Transform.scale(
          scale: 0.5,
          child: Switch(value: true, onChanged: onChanged),
        ),
        const Spacer(),
        Text(
          'See all',
          style: GoogleFonts.openSans(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget buildCategoryChips() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return categoryChip(category['imageUrl'], category['label']);
        },
      ),
    );
  }

  Widget buildItemsGrid(BuildContext context, List<Map<String, dynamic>> items) {
    // Determine the number of items to display (maximum 4)
    int itemCount = items.length > 4 ? 4 : items.length;

    // Calculate dynamic height based on item count and screen size
    double screenHeight = MediaQuery.of(context).size.height;
    double itemHeight = screenHeight * 0.32; // Each item takes 25% of screen height

    // Calculate the number of rows dynamically
    int numRows = (itemCount / 2).ceil();
    double gridHeight = itemHeight * numRows;

    return SizedBox(
      height: gridHeight, // Set dynamic height based on the number of rows
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(), // Prevent scrolling inside the grid
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 items per row
          mainAxisSpacing: 16,
          crossAxisSpacing: 10,
          childAspectRatio: 0.75, // Adjust for item layout
        ),
        itemCount: itemCount, // Limit item count to maximum 4
        itemBuilder: (context, index) {
          final item = items[index];
          return itemsPageCard(
            productPhoto: item['productPhoto'],
            productName: item['productName'],
            brandName: item['brandName'],
            sellingPrice: item['sellingPrice'],
          );
        },
      ),
    );
  }

  Widget searchBarWithCategories() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Action for back button
          },
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search for a product, cloth...",
                      hintStyle: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ),
                const Icon(Icons.search, color: Colors.grey),
              ],
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () {
            // Action for filter button
          },
        ),
      ],
    );
  }

  Widget categoryChip(String imageUrl, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Chip(
        elevation: 10,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey[300]!, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        avatar: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget itemsPageCard({
    required String productPhoto,
    required String productName,
    required String brandName,
    required double sellingPrice,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              image: DecorationImage(image: NetworkImage(productPhoto), fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(productName, style: GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text("Brand: $brandName", style: GoogleFonts.openSans(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 5),
                Text("\$ $sellingPrice", style: GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(12)),
                  child: const Text('Stock Available', style: TextStyle(color: Colors.white, fontSize: 10)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}

