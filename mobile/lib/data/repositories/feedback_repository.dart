import '../../services/api_client.dart';
import '../../services/secure_storage_service.dart';

class FeedbackRepository {
  FeedbackRepository({
    ApiClient? apiClient,
    SecureStorageService? storage,
  })  : _apiClient = apiClient ?? ApiClient(),
        _storage = storage ?? const SecureStorageService();

  final ApiClient _apiClient;
  final SecureStorageService _storage;

  Future<void> submitFeedback({
    required int complaintId,
    required int rating,
    String? comment,
  }) async {
    await _apiClient.post(
      '/feedback/complaints/$complaintId',
      token: await _storage.readToken(),
      body: {
        'rating': rating,
        'comment': comment,
      },
    );
  }
}
