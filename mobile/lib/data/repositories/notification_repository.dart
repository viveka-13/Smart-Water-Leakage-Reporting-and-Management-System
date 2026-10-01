import '../../models/notification.dart';
import '../../services/api_client.dart';
import '../../services/secure_storage_service.dart';

class NotificationRepository {
  NotificationRepository({
    ApiClient? apiClient,
    SecureStorageService? storage,
  })  : _apiClient = apiClient ?? ApiClient(),
        _storage = storage ?? const SecureStorageService();

  final ApiClient _apiClient;
  final SecureStorageService _storage;

  Future<List<AppNotification>> getNotifications() async {
    final response = await _apiClient.get(
      '/notifications',
      token: await _storage.readToken(),
    );
    final data = response['data'];
    if (data is! List) return const [];
    return data.whereType<Map<String, dynamic>>().map(AppNotification.fromJson).toList();
  }

  Future<void> markAsRead(int id) async {
    await _apiClient.patch(
      '/notifications/$id/read',
      token: await _storage.readToken(),
    );
  }
}
