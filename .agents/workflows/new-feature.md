---
description: Tạo một tính năng mới hoàn chỉnh theo Clean Architecture (Domain + Data + Presentation/BLoC)
---

Hỏi user tên feature muốn tạo (ví dụ: `notification`, `report`, `alert`), sau đó thực hiện theo các bước sau:

1. Tạo cấu trúc thư mục cho feature mới:
   - `lib/features/<feature>/domain/entities/`
   - `lib/features/<feature>/domain/repositories/`
   - `lib/features/<feature>/domain/usecases/`
   - `lib/features/<feature>/data/datasources/`
   - `lib/features/<feature>/data/models/`
   - `lib/features/<feature>/data/repositories/`
   - `lib/features/<feature>/presentation/bloc/`
   - `lib/features/<feature>/presentation/pages/`
   - `lib/features/<feature>/presentation/pages/widget/`

2. Tạo Entity trong domain layer: `lib/features/<feature>/domain/entities/<feature>_entity.dart`

3. Tạo Repository interface trong domain: `lib/features/<feature>/domain/repositories/<feature>_repository.dart`

4. Tạo UseCase(s) trong domain: `lib/features/<feature>/domain/usecases/get_<feature>_usecase.dart`

5. Tạo DataSource trong data layer: `lib/features/<feature>/data/datasources/<feature>_remote_data_source.dart`

6. Tạo Repository implementation: `lib/features/<feature>/data/repositories/<feature>_repository_impl.dart`

7. Tạo BLoC (Event + State + Bloc): 
   - `lib/features/<feature>/presentation/bloc/<feature>_event.dart`
   - `lib/features/<feature>/presentation/bloc/<feature>_state.dart`
   - `lib/features/<feature>/presentation/bloc/<feature>_bloc.dart`

8. Tạo Page chính: `lib/features/<feature>/presentation/pages/<feature>_page.dart`

9. Đăng ký vào Service Locator (`lib/core/service_locator.dart`): thêm DataSource, Repository, UseCase, và getter cho BLoC

10. Kiểm tra không có lỗi compile:
// turbo
    flutter analyze lib/features/<feature>
