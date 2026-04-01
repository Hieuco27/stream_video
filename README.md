# Stream Video & Vehicle Tracking App

Đây là ứng dụng Flutter tích hợp hai nghiệp vụ cốt lõi: **Truyền phát Video (Streaming)** và **Giám sát phương tiện trên bản đồ theo thời gian thực (Real-time GPS Tracking)**. Dự án được xây dựng với mục tiêu vận hành mượt mà, dễ bảo trì và mở rộng trong tương lai thông qua kiến trúc chuyên nghiệp.

---

## 🏗 Kiến trúc dự án (Architecture)

Dự án áp dụng mô hình **Clean Architecture** kết hợp với **BLoC Pattern** để quản lý trạng thái, nhằm tách bạch hoàn toàn UI khỏi Logic nghiệp vụ.

Cấu trúc thư mục được chia theo Features (tính năng), ví dụ `lib/features/map/`:
- **`presentation/`**: Chứa toàn bộ UI (`pages/`, `widgets/`) và State Management (`bloc/`). Các widget lớn được tái cấu trúc nhỏ lại (như `TrackingMap`, `RouteHistoryLayer`, `TrackingAppBar`) để tuân thủ nguyên tắc Single Responsibility.
- **`domain/`**: Chứa các UseCases (như `get_route_usecase.dart`, `get_route_history_usecase.dart`) và Business Entities (như `map_type.dart`, `route_history_point.dart`). Domain hoàn toàn không phụ thuộc vào framework.
- **`data/`**: Chứa Repository Implementations, Models (parse từ JSON), và Data Sources (như `vehicle_remote_data_source.dart`) để gọi API hoặc Database.
- **`core/`**: Chứa xử lý dùng chung cho toàn dự án:
  - **Error Handling**: Áp dụng **Result Pattern** (`Result<T>`) và mô hình `Failure` (`dio_failure_mapper.dart`) để bắt mọi Exception và quy đổi thành lỗi thân thiện cho người dùng thay vì tràn ngập `try-catch` lộn xộn.
  - **Dependency Injection**: Quản lý qua Service Locator (`service_locator.dart`).
  - **Colors & Theming**: Quản lý màu sắc tập trung (`app_colors.dart`).

---

## 🛠 Công nghệ & Thư viện sử dụng (Tech Stack)

### 1. Quản lý trạng thái & Routing (State & Navigation)
- **`flutter_bloc`** & **`equatable`**: Dùng để quản lý vòng đời State của ứng dụng, đặc biệt phục vụ cho các logic phức tạp như cập nhật vị trí bản đồ liên tục.
- **`go_router`**: Quản lý luồng điều hướng màn hình linh hoạt.

### 2. Bản đồ & Định vị (Map & Location)
*Đây là một trong những Module lớn nhất của dự án.*
- **`flutter_map`**: Render bản đồ dựa trên OpenStreetMap (OSM) với độ tuỳ biến cao (TileLayer, MarkerLayer, PolylineLayer).
- **`latlong2`**: Xử lý toạ độ địa lý chuẩn xác.
- **`flutter_compass`** & **`geolocator`**: Lấy vị trí GPS hiện tại của thiết bị và góc xoay là bàn (hướng người dùng đang đi).
- **Các dịch vụ Bản đồ tích hợp (Services)**:
  - **Geocoding Service**: Chuyển đổi từ Toạ độ (Lat, Lng) ra Địa chỉ văn bản thực tế (Nominatim OSM).
  - **Directions Service**: Tính toán đường đi ngắn nhất (OSRM).
  - **Mô phỏng (Mocking)**: Hệ thống `mock_route_history` giả lập lộ trình di chuyển phương tiện để review và test UI.

### 3. Video Streaming
- **`media_kit`** & **`media_kit_video`**: Engine phát video hiệu suất cao, xử lý luồng stream (HLS, MP4, v.v.) ổn định hơn so với gói `video_player` tiêu chuẩn.

### 4. Bố cục UI (UI & Styling)
- **`flutter_screenutil`**: Tự động scale font chữ, chiều cao, chiều rộng để giao diện Responsive hoàn hảo trên nhiều kích thước màn hình thiết bị khác nhau.

### 5. Kết nối mạng & API (Networking)
- **`dio`**: HTTP client mạnh mẽ hỗ trợ Interceptors xử lý Token và Logging.
- **`retrofit`**: Generator hỗ trợ ánh xạ API Endpoints gọn gàng thành các hàm Dart.
- **`signalr_core`**: Giao tiếp WebSocket thời gian thực (Real-time), ứng dụng để stream dữ liệu vị trí tài xế/xe cộ cập nhật liên tục xuống app.
- **`shared_preferences`**: Lưu trữ Local Storage (cấu hình, token).

---

## 🚀 Tính năng nổi bật của Map Tracking

Dự án vừa trải qua đợt Refactor (Tái cấu trúc) làm sạch mã nguồn ở phần Tracking Bản đồ:
1. **Theo dõi xe cộ theo thời gian thực:** Xe di chuyển và liên tục tự động cập nhật marker và đường Polyline phía sau lưng.
2. **Xem lại lộ trình di chuyển lịch sử (Route History):**
   - Vẽ lại con đường xe đã đi (`RouteHistoryLayer`).
   - Có các chốt đánh dấu vận tốc (V-GPS), trạng thái Động cơ (Bật/Tắt).
   - Tự động xoay phương tiện (`atan2`) theo hướng di chuyển gốc.
3. **Mô-đun hoá giao diện:** `tracking_page.dart` được viết cực kỳ ngắn gọn. Mọi lớp xử lý hiển thị tách biệt rõ ràng -> Developer sau này có thể dễ dàng thay đổi nút bấm, thay đổi popup hay hiển thị layout khác mà không lo làm hỏng logic map nền.

---

## 🔧 Cách cấu hình và chạy (Setup & Run)
1. **Cài đặt thư viện:** Chạy `flutter pub get`
2. **Gen code cho Retrofit:** Chạy lệnh `dart run build_runner build --delete-conflicting-outputs`
3. **Chạy ứng dụng:**
   - Android / iOS: `flutter run`
   *(Lưu ý: Dự án đã được patch `build.gradle.kts` ở mức root Android để fix tương thích namespace đối với package cũ như `flutter_compass`, sử dụng an toàn với chuẩn AGP 8+).*
