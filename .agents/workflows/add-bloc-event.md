---
description: Thêm BLoC event mới vào một Bloc feature đã có sẵn
---

Hỏi user: tên feature (ví dụ: `tracking`, `playback`) và tên event mới (ví dụ: `LoadData`, `RefreshList`).

1. Đọc file `lib/features/<feature>/presentation/bloc/<feature>_event.dart` để hiểu các event hiện có.

2. Thêm class event mới vào file event, kế thừa đúng base class, thêm vào `props` nếu dùng Equatable.

3. Đọc `lib/features/<feature>/presentation/bloc/<feature>_bloc.dart` để đăng ký handler mới.

4. Thêm `on<NewEvent>(_onNewEvent)` trong constructor của Bloc.

5. Implement hàm handler `_onNewEvent` trong Bloc:
   - Luôn emit `Loading` state trước nếu là async
   - Gọi UseCase hoặc Repository
   - Emit `Success` hoặc `Error` state

6. Nếu cần thêm state mới, cập nhật `lib/features/<feature>/presentation/bloc/<feature>_state.dart` và đảm bảo thêm vào `props`.

7. Kiểm tra không có lỗi:
// turbo
   flutter analyze lib/features/<feature>/presentation/bloc
