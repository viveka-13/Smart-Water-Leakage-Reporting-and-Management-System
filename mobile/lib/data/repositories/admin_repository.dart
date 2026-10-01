import '../../models/complaint.dart';
import '../../models/analytics_summary.dart';
import '../../services/api_client.dart';
import '../../services/secure_storage_service.dart';

class AdminWorker {
  const AdminWorker({required this.id, required this.name, this.email});

  final int id;
  final String name;
  final String? email;

  factory AdminWorker.fromJson(Map<String, dynamic> json) {
    return AdminWorker(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'Unnamed worker',
      email: json['email'] as String?,
    );
  }
}

class AdminRepository {
  AdminRepository({
    ApiClient? apiClient,
    SecureStorageService? storage,
  })  : _apiClient = apiClient ?? ApiClient(),
        _storage = storage ?? const SecureStorageService();

  final ApiClient _apiClient;
  final SecureStorageService _storage;

  Future<List<Complaint>> getComplaints({String? status}) async {
    final response = await _apiClient.get(
      '/admin/complaints',
      token: await _storage.readToken(),
      queryParameters: status == null || status == 'ALL' ? null : {'status': status},
    );
    final data = response['data'];
    if (data is! List) return const [];
    return data.whereType<Map<String, dynamic>>().map(Complaint.fromJson).toList();
  }

  Future<List<AdminWorker>> getWorkers() async {
    final response = await _apiClient.get(
      '/admin/workers',
      token: await _storage.readToken(),
    );
    final data = response['data'];
    if (data is! List) return const [];
    return data.whereType<Map<String, dynamic>>().map(AdminWorker.fromJson).toList();
  }

  Future<void> updateStatus(int complaintId, String status, {String? remarks}) async {
    await _apiClient.patch(
      '/admin/complaints/$complaintId/status',
      token: await _storage.readToken(),
      body: {'status': status, 'remarks': remarks},
    );
  }

  Future<void> assignWorker(int complaintId, int workerId) async {
    await _apiClient.patch(
      '/admin/complaints/$complaintId/assign',
      token: await _storage.readToken(),
      body: {'workerId': workerId},
    );
  }

  Future<AnalyticsSummary> getAnalyticsSummary() async {
    final response = await _apiClient.get(
      '/admin/analytics/summary',
      token: await _storage.readToken(),
    );
    return AnalyticsSummary.fromJson(response['data'] as Map<String, dynamic>);
  }
}
