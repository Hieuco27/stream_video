---
description: Phân tích lỗi và sửa toàn bộ warning/error trong project
---

1. Chạy Flutter analyze để lấy toàn bộ lỗi:
// turbo
   flutter analyze

2. Đọc kết quả và phân loại lỗi theo mức độ: error (bắt buộc sửa), warning (nên sửa), info (tùy chọn)

3. Sửa lần lượt từng lỗi theo mức độ ưu tiên (error trước, warning sau). Với mỗi file bị lỗi, đọc file đó để hiểu context trước khi sửa.

4. Sau khi sửa xong, chạy lại analyze để xác nhận:
// turbo
   flutter analyze

5. Báo cáo tổng kết: bao nhiêu lỗi đã sửa, bao nhiêu còn lại và lý do.
