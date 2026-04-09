---
description: Chạy flutter analyze toàn dự án và format code
---

1. Chạy analyze toàn bộ project:
// turbo
   flutter analyze

2. Nếu có lỗi, phân tích và sửa lần lượt. Ưu tiên `error` trước `warning`.

3. Format toàn bộ code:
// turbo
   dart format lib/

4. Chạy lại analyze lần cuối để xác nhận sạch lỗi:
// turbo
   flutter analyze
