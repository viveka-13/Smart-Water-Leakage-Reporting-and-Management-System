import 'package:connectivity_plus/connectivity_plus.dart';

import '../data/local/offline_complaint_queue.dart';
import 'api_client.dart';
import 'secure_storage_service.dart';

class OfflineSyncService {
  OfflineSyncService({
    ApiClient? apiClient,
    SecureStorageService? storage,
    OfflineComplaintQueue? queue,
    Connectivity? connectivity,
  })  : _apiClient = apiClient ?? ApiClient(),
        _storage = storage ?? const SecureStorageService(),
        _queue = queue ?? OfflineComplaintQueue(),
        _connectivity = connectivity ?? Connectivity();

  final ApiClient _apiClient;
  final SecureStorageService _storage;
  final OfflineComplaintQueue _queue;
  final Connectivity _connectivity;

  Future<int> syncPendingComplaints() async {
    final connectivity = await _connectivity.checkConnectivity();
    if (connectivity.contains(ConnectivityResult.none)) return 0;

    final pending = await _queue.readAll();
    if (pending.isEmpty) return 0;

    final remaining = <Map<String, dynamic>>[];
    var syncedCount = 0;
    final token = await _storage.readToken();

    for (final payload in pending) {
      try {
        await _apiClient.post('/complaints', body: payload, token: token);
        syncedCount++;
      } catch (_) {
        remaining.add(payload);
      }
    }

    await _queue.replaceAll(remaining);
    return syncedCount;
  }
}