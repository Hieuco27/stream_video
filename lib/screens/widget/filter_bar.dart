import 'package:flutter/material.dart';
import 'select_popup.dart';

/// Thanh bộ lọc: Chọn BKS + Chọn Kênh + Nút Xem
/// Widget này chỉ hiển thị UI, mọi logic xử lý được truyền qua callbacks.
class FilterBar extends StatelessWidget {
  final String selectedBks;
  final String selectedKenh;
  final List<String> listBks;
  final List<String> listKenh;
  final ValueChanged<String> onBksChanged;
  final ValueChanged<String> onKenhChanged;
  final VoidCallback onPlay;

  const FilterBar({
    super.key,
    required this.selectedBks,
    required this.selectedKenh,
    required this.listBks,
    required this.listKenh,
    required this.onBksChanged,
    required this.onKenhChanged,
    required this.onPlay,
  });

  void _showBksPopup(BuildContext context) async {
    final result = await SelectPopup.show(
      context,
      items: listBks,
      initialValue: selectedBks,
    );
    if (result != null) {
      onBksChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          // Nút chọn BKS
          Expanded(
            flex: 35,
            child: GestureDetector(
              onTap: () => _showBksPopup(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E5E5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                          children: [
                            const TextSpan(
                              text: 'BKS: ',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            TextSpan(
                              text: selectedBks,
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, size: 20),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Nút chọn Kênh
          Expanded(
            flex: 35,
            child: PopupMenuButton<String>(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              offset: const Offset(0, 45),
              onSelected: onKenhChanged,
              itemBuilder: (BuildContext context) => listKenh.map((String kh) {
                return PopupMenuItem<String>(
                  value: kh,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 4.0,
                    ),
                    child: Text(
                      kh,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                );
              }).toList(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E5E5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Kênh: ',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            TextSpan(
                              text: selectedKenh,
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, size: 20),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Nút Xem
          Expanded(
            flex: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFAED569),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              onPressed: onPlay,
              child: const Text('Xem', style: TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}
