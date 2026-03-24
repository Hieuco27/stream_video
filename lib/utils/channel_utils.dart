class ChannelUtils {
  /// Chuyển đổi tên kênh (VD: 'Kênh 1', 'Kênh 4') thành index mảng (0, 3)
  /// Trả về -1 nếu là 'Tất cả' hoặc text không hợp lệ.
  static int parseChannelIndex(String channelName) {
    if (channelName == 'Tất cả') return -1;
    
    // Xoá chữ "Kênh", dọn dẹp khoảng trắng dư thừa
    final numberString = channelName.replaceAll('Kênh', '').trim();
    
    // Chuyển chữ thành số
    final number = int.tryParse(numberString);
    
    // Vì Kênh 1 tương ứng với index 0 trong mảng _players
    if (number != null && number > 0) {
      return number - 1; 
    }
    
    return -1; // Trả về -1 nếu format sai (chữ rác)
  }
}
