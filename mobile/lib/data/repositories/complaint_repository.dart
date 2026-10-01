import '../../models/complaint.dart';
import '../../services/api_client.dart';
import '../../services/secure_storage_service.dart';

class ComplaintRepository {
  ComplaintRepository({
    ApiClient? apiClient,
    SecureStorageService? storage,
  })  : _apiClient = apiClient ?? ApiClient(),
        _storage = storage ?? const SecureStorageService();

  final ApiClient _apiClient;
  final SecureStorageService _storage;

  Future<List<Complaint>> getMyComplaints({String? status}) async {
    final token = await _storage.readToken();
    final response = await _apiClient.get(
      '/complaints/my',
      token: token,
    );
    final data = response['data'];

    if (data is! List) {
      return const [];
    }

    final complaints = data
        .whereType<Map<String, dynamic>>()
        .map(Complaint.fromJson)
        .toList();

    if (status == null || status == 'ALL') {
      return complaints;
    }

    return complaints.where((complaint) => complaint.status == status).toList();
  }

  Future<Complaint> getMyComplaintById(int id) async {
    final token = await _storage.readToken();
    final response = await _apiClient.get(
      '/complaints/$id',
      token: token,
    );
    return Complaint.fromJson(response['data'] as Map<String, dynamic>);
  }
}
