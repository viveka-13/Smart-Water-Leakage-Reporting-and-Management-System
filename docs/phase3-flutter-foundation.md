# AquaGuard: Phase 3 Flutter Foundation

## Phase title

## Phase 3: Flutter foundation

### 1. What we are building

This phase creates the startup foundation of the Flutter mobile application. Instead of writing the business screens yet, we build the main structure that every future module will use:

- a clean theme
- application routes
- common reusable widgets
- API communication layer
- secure storage service
- base model classes
- loading and error states

This setup makes the app easier to extend and keeps the code clean and presentation-friendly.

### 2. Architecture concept

In Flutter, every screen should remain focused on UI and user actions, while data operations are kept in repositories and services. This phase introduces the initial structure that supports that architecture.

The important architectural idea is separation of concerns:

- UI theme handles appearance
- route configuration handles navigation
- API client handles HTTP requests
- secure storage handles tokens securely
- models define app data structure
- common widgets provide reusable feedback

### 3. Files and folders

The relevant files created in this phase are:

```text
aquaguard/mobile/
├── pubspec.yaml
├── lib/
│   ├── main.dart
│   ├── core/
│   │   ├── errors/
│   │   │   └── app_exception.dart
│   │   ├── routes/
│   │   │   └── app_router.dart
│   │   ├── theme/
│   │   │   └── app_theme.dart
│   │   └── widgets/
│   │       └── common_widgets.dart
│   ├── models/
│   │   ├── base_model.dart
│   │   └── user.dart
│   └── services/
│       ├── api_client.dart
│       └── secure_storage_service.dart
```

### 4. Complete code

The code is implemented in the files above and is ready for future phases.

### 5. Commands

```powershell
cd "C:\Users\Renta\Downloads\clg lab projects\Flutter Lab\aquaguard\mobile"
flutter pub get
flutter run
```

### 6. How to run

1. Open the `mobile` folder in VS Code.
2. Ensure the Flutter SDK is installed.
3. Run `flutter pub get`.
4. Start an Android emulator or connect a device.
5. Run `flutter run`.

### 7. Expected output

The app should launch with:

- a blue-and-teal AquaGuard theme
- an initial splash route
- a working application startup and route structure
- a clean base for future login and complaint screens

### 8. Common errors

- Flutter SDK not installed: install Flutter and run `flutter doctor`
- No Android device found: start an emulator or connect a device
- Package resolution issues: run `flutter pub get`
- Secure storage permission issues: verify Android configuration

### 9. Test checklist

- [ ] `flutter pub get` succeeds
- [ ] app starts without errors
- [ ] theme loads correctly
- [ ] route navigation works
- [ ] loading indicator shows when needed
- [ ] secure storage service is callable
- [ ] API client returns safe errors

### 10. Academic explanation

This phase is important because it prepares the mobile foundation for all future features. A strong app foundation includes a clear theme, navigation, reusable widgets, and a controlled way to talk to the backend. In project presentations, this phase shows that the developer understands software structure and separation of concerns, not just screen building.

### 11. Stop

This is the end of Phase 3. Please confirm before starting Phase 4.
