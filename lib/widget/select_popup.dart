import 'package:flutter/material.dart';
import 'package:stream_video/core/app_theme.dart';

class SelectPopup extends StatefulWidget {
  final List<String> items;
  final String? initialValue;

  const SelectPopup({super.key, required this.items, this.initialValue});

  /// Hiển thị popup tìm kiếm và chọn item
  static Future<String?> show(
    BuildContext context, {
    required List<String> items,
    String? initialValue,
  }) {
    return showDialog<String>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) =>
          SelectPopup(items: items, initialValue: initialValue),
    );
  }

  @override
  State<SelectPopup> createState() => _SelectPopupState();
}

class _SelectPopupState extends State<SelectPopup> {
  late List<String> _filteredItems;
  final TextEditingController _searchController = TextEditingController();
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _selectedValue = widget.initialValue;
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems = widget.items
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ô tìm kiếm
            Container(
              decoration: BoxDecoration(
                gradient: AppGradients.primaryButton,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterItems,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm...',
                  hintStyle: const TextStyle(color: Colors.black54),
                  prefixIcon: const Icon(Icons.search, color: Colors.black54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Danh sách hiển thị có thể cuộn
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _filteredItems.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = _filteredItems[index];
                  final isSelected = item == _selectedValue;
                  return ListTile(
                    title: Text(item),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedValue = item;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 10),

            // Nút Trở lại & Xác nhận
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 151, 151, 151),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Trở lại',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFAED569),
                  ),
                  onPressed: () {
                    Navigator.pop(context, _selectedValue);
                  },
                  child: const Text(
                    'Xác nhận',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
