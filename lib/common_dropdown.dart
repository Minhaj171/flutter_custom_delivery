import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

Widget customAppCommonDropdown({
  required final String name,
  required final dynamic data,
  required final ValueChanged<dynamic> onItemSelected,
  final String? hint,
  final VoidCallback? onAddNewItem,
  final String? navigationButtonName,
  final bool? isRequired,
  final int? initSelectedValue,
  final bool isNavigateButtonRequired = false,
  final bool isSearchViewRequired = false,
  final bool isEnabled = true,
  final double? width,
  final String? errorMessage,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(
            name,
            style: GoogleFonts.openSans(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            maxLines: 3,
          ),
          Visibility(
            visible: isRequired!,
            child: "*"
                .text
                .size(12)
                .textStyle(GoogleFonts.openSans(letterSpacing: .5))
                .color(Colors.red)
                .bold
                .make()
                .box
                .margin(const EdgeInsets.only(left: 1))
                .make(),
          ),
        ],
      ),
      const SizedBox(
        height: 5,
      ),
      GroupedDropdown(
        name: name,
        hint: hint!,
        data: data,
        onItemSelected: onItemSelected,
        onAddNewItem: onAddNewItem,
        navigationButtonName: navigationButtonName,
        isNavigateButtonRequired: isNavigateButtonRequired,
        isSearchButtonRequired: isSearchViewRequired,
        isEnabled: isEnabled,
        initSelectedValue: initSelectedValue,
        width: width,
        errorMessage: errorMessage,
      ),
    ],
  );
}

class GroupedDropdown extends StatefulWidget {
  final String name;
  final String hint;
  final dynamic data;
  final ValueChanged<dynamic> onItemSelected;
  final VoidCallback? onAddNewItem;
  final String? navigationButtonName;
  final bool isNavigateButtonRequired;
  final bool isSearchButtonRequired;
  final int? initSelectedValue;
  final bool isEnabled;
  final double? width;
  final String? errorMessage;

  const GroupedDropdown({
    required this.name,
    required this.data,
    required this.onItemSelected,
    this.onAddNewItem,
    this.navigationButtonName,
    this.hint = '',
    this.initSelectedValue,
    this.isNavigateButtonRequired = false,
    this.isSearchButtonRequired = false,
    this.isEnabled = true,
    this.width,
    this.errorMessage,
    super.key,
  });

  @override
  _GroupedDropdownState createState() => _GroupedDropdownState();
}

class _GroupedDropdownState extends State<GroupedDropdown> {
  String? _selectedItem;
  final TextEditingController _searchController = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isDropdownOpen = false;
  dynamic _filteredData;

  @override
  void initState() {
    super.initState();
    _filteredData = _getFilteredData();
    _searchController.addListener(_filterItems);

    if (widget.initSelectedValue != null) {
      final initialValue = _findInitialValue(widget.initSelectedValue!);
      if (initialValue != null) {
        _selectedItem = initialValue;
      }
    }
  }

  String? _findInitialValue(int id) {
    if (widget.data is Map<String, List<dynamic>>) {
      for (var group in (widget.data as Map<String, List<dynamic>>).values) {
        for (var item in group) {
          if (item is Map<String, dynamic> && item['id'] == id) {
            return item['name'];
          }
        }
      }
    } else {
      for (var item in widget.data) {
        if (item is Map<String, dynamic> && item['id'] == id) {
          return item['name'];
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: widget.isEnabled ? _toggleDropdown : null, // Disable tap if not enabled
        child: Container(
          width: widget.width,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: widget.errorMessage != null? Colors.red : Colors.grey),
            borderRadius: BorderRadius.circular(4),
            color: widget.isEnabled ? Colors.white : Colors.grey[100], // Change background color if disabled
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _selectedItem ?? widget.hint,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: widget.isEnabled
                        ? (_selectedItem != null ? Colors.black : Colors.grey)
                        : Colors.grey, // Text color change if disabled
                  ),
                ),
              ),
              if (widget.isEnabled && _selectedItem != null)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedItem = null;
                      widget.onItemSelected(null);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.close,
                      color: Colors.grey[800],
                      size: 22,
                    ),
                  ),
                ),
              Icon(
                _isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: widget.isEnabled ? Colors.black : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  dynamic _getFilteredData() {
    if (widget.data is Map<String, List<dynamic>>) {
      return Map<String, List<dynamic>>.from(widget.data);
    } else {
      return List<dynamic>.from(widget.data);
    }
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (widget.data is Map<String, List<dynamic>>) {
        _filteredData = _filterMapData(query);
      } else {
        _filteredData = _filterListData(query);
      }
    });
    _overlayEntry?.markNeedsBuild();
  }

  Map<String, List<dynamic>> _filterMapData(String query) {
    return (widget.data as Map<String, List<dynamic>>).map((group, items) {
      final filteredItems = items.where((item) => _matchesQuery(item, query)).toList();
      return MapEntry(group, filteredItems);
    })..removeWhere((key, value) => value.isEmpty);
  }

  List<dynamic> _filterListData(String query) {
    return (widget.data as List<dynamic>).where((item) => _matchesQuery(item, query)).toList();
  }

  bool _matchesQuery(dynamic item, String query) {
    if (item is String) {
      return item.toLowerCase().contains(query);
    } else if (item is Map<String, dynamic>) {
      return item['name']?.toLowerCase().contains(query) ?? false;
    }
    return false;
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size buttonSize = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return GestureDetector(
          onTap: _removeOverlay,
          behavior: HitTestBehavior.translucent,
          child: Stack(
            children: [
              Positioned(
                width: buttonSize.width,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  offset: Offset(0, buttonSize.height + 5.0),
                  child: Material(
                    elevation: 4.0,
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          widget.isSearchButtonRequired
                              ? _buildSearchField()
                              : Container(),
                          _buildDropdownList(),
                          widget.isNavigateButtonRequired
                              ? _buildAddNewItem()
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isDropdownOpen = true;
    });
  }

  void _removeOverlay() {
    if (_isDropdownOpen) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      setState(() {
        _isDropdownOpen = false;
        _searchController.clear();
        _filteredData = _getFilteredData();
      });
    }
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
      ),
    );
  }

  Widget _buildDropdownList() {
    if (_filteredData is Map<String, List<dynamic>>) {
      return Expanded(
        child: ListView.builder(
          itemCount: (_filteredData as Map<String, List<dynamic>>).length,
          itemBuilder: (context, index) {
            return _buildGroupedItemList(index);
          },
        ),
      );
    } else {
      final orderedList = _filteredData as List<dynamic>;
      // Move selected item to the top if exists
      if (_selectedItem != null) {
        final selectedIndex = orderedList.indexWhere((item) =>
        item is String && item == _selectedItem ||
            (item is Map<String, dynamic> && item['name'] == _selectedItem));
        if (selectedIndex != -1) {
          final selectedItem = orderedList.removeAt(selectedIndex);
          orderedList.insert(0, selectedItem);
        }
      }

      return Expanded(
        child: orderedList.isNotEmpty
            ? ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: orderedList.length,
          itemBuilder: (context, index) {
            return _buildListItem(orderedList[index], index == 0);
          },
        )
            : const Center(
          child: Text('No items found'),
        ),
      );
    }
  }

  Widget _buildGroupedItemList(int index) {
    final groupName = (_filteredData as Map<String, List<dynamic>>).keys.elementAt(index);
    final items = (_filteredData as Map<String, List<dynamic>>)[groupName];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.grey[300],
          child: Text(
            groupName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items?.length,
          itemBuilder: (context, index) {
            return _buildListItem(items![index], index == 0 && _selectedItem == null);
          },
        ),
      ],
    );
  }

  Widget _buildListItem(dynamic item, bool isDefaultSelection) {
    final itemName = item is String ? item : item['name'];
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.isEnabled
            ? () {
          setState(() {
            _selectedItem = itemName;
            widget.onItemSelected(item);
            _removeOverlay();
          });
        }
            : null, // Disable tap if not enabled
        child: Container(
          color: _selectedItem == itemName
              ? Colors.blue.withOpacity(0.1)
              : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(itemName),
        ),
      ),
    );
  }
  Widget _buildAddNewItem() {
    return Column(
      children: [
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.add, color: Colors.blue),
          title: Text(
            widget.navigationButtonName ?? '',
            style: const TextStyle(color: Colors.blue),
          ),
          onTap: () async {
            print('callback work ');
            _removeOverlay();
             widget.onAddNewItem?.call();
          },
        ),
      ],
    );
  }

}
