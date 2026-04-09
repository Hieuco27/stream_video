---
description: Kết nối một feature với API thật, thay thế mock data bằng Dio HTTP calls
---

Hỏi user: tên feature cần tích hợp API và endpoint URL.

1. Đọc file DataSource hiện tại của feature để hiểu mock data đang trả về gì: `lib/features/<feature>/data/datasources/<feature>_remote_data_source.dart`

2. Đọc Entity trong domain để hiểu cấu trúc dữ liệu cần: `lib/features/<feature>/domain/entities/`

3. Tạo hoặc cập nhật API Model (raw response từ server): `lib/features/<feature>/data/models/<feature>_model.dart`
   - Thêm factory `fromJson(Map<String, dynamic> json)` 

4. Cập nhật DataSource để gọi API thật qua Dio thay vì mock:
   - Inject `Dio` hoặc dùng `ApiClient` đã có trong `lib/services/` hoặc `lib/core/`
   - Gọi `dio.get(endpoint)` / `dio.post()` 
   - Parse response sang API Model, sau đó map sang Domain Entity

5. Cập nhật Repository implementation để map API Model → Domain Entity đúng chỗ

6. Kiểm tra Service Locator (`lib/core/service_locator.dart`) có đủ dependency chưa (Dio được inject chưa)

7. Test compile:
// turbo
   flutter analyze lib/features/<feature>
