import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/utils/channel_utils.dart';

void main() {
  // group() dùng để gom nhóm các bài test có chung mục đích lại với nhau cho gọn
  group('Kiểm thử hàm xử lý chữ Kênh thành Index (ChannelUtils)', () {
    // Bài test 1: Chuẩn mực
    test('Nên đối dịch "Kênh 1" thành rổ index 0', () {
      // 1. Chuẩn bị (Arrange)
      const input = 'Kênh 1';
      // 2. Chạy thử hàm (Act)
      final result = ChannelUtils.parseChannelIndex(input);
      // 3. Kì vọng (Assert)
      expect(result, 0); // Kì vọng hàm nhả ra chính xác số 0
    });

    // Bài test 2: Check ranh giới mảng
    test('Nên đối dịch "Kênh 4" thành rổ index 3', () {
      final result = ChannelUtils.parseChannelIndex('Kênh 4');
      expect(result, 3);
    });

    // Bài test 3: Check trường hợp ngoại lệ
    test('Nên trả về -1 khi user chọn "Tất cả"', () {
      final result = ChannelUtils.parseChannelIndex('Tất cả');
      expect(result, -1);
    });

    // Bài test 4: Check lỗi người dùng thao tác phím (Gõ dư dấu cách)
    test('Nên vẫn đọc hiểu khi chữ bị dư khoảng trắng "Kênh   2 "', () {
      final result = ChannelUtils.parseChannelIndex('Kênh   2 ');
      expect(result, 1);
    });

    // Bài test 5: Check lỗi dữ liệu tà đạo (chữ lạ)
    test('Nên trả về -1 (an toàn) nếu đầu vào là cụm từ vô nghĩa', () {
      final result = ChannelUtils.parseChannelIndex('Kênh abc');
      expect(result, -1);
    });
  });
}
