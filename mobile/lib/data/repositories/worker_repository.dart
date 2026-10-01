import '../../models/complaint.dart';
import '../../services/api_client.dart';
import '../../services/secure_storage_service.dart';

class WorkerRepository {
  WorkerRepository({
    ApiClient? apiClient,
    SecureStorageService? storage,
  })  : _apiClient = apiClient ?? ApiClient(),
        _storage = storage ?? const SecureStorageService();

  final ApiClient _apiClient;
  final SecureStorageService _storage;

  Future<List<Complaint>> getAssignedComplaints() async {
    final response = await _apiClient.get(
      '/worker/complaints',
      token: await _storage.readToken(),
    );
    final data = response['data'];
    if (data is! List) return const [];
    return data.whereType<Map<String, dynamic>>().map(Complaint.fromJson).toList();
  }

  Future<void> updateStatus(int complaintId, String status, {String? remarks}) async {
    await _apiClient.patch(
      '/worker/complaints/$complaintId/status',
      token: await _storage.readToken(),
      body: {'status': status, 'remarks': remarks},
    );
  }
}
