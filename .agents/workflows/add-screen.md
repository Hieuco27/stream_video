---
description: Thêm màn hình mới vào một feature đã có sẵn
---

Hỏi user: tên feature đã có (ví dụ: `map`, `review`, `auth`) và tên màn hình mới (ví dụ: `detail`, `settings`).

1. Tạo file page mới: `lib/features/<feature>/presentation/pages/<screen>_page.dart`
   - Dùng `StatelessWidget` nếu không có local state phức tạp
   - Dùng `StatefulWidget` nếu cần `initState`, `dispose`, hoặc `AnimationController`
   - Dùng `BlocBuilder/BlocConsumer` thay vì `setState` cho logic phức tạp

2. Tạo thư mục widget riêng nếu màn hình có nhiều component: `lib/features/<feature>/presentation/pages/widget/`

3. Thêm màn hình vào router nếu cần navigate tới (`lib/core/router/app_router.dart` hoặc tương tự)

4. Kiểm tra import và không có lỗi compile:
// turbo
   flutter analyze lib/features/<feature>/presentation
