import 'package:connectivity_plus/connectivity_plus.dart';

import '../data/local/offline_complaint_queue.dart';
import '../core/errors/app_exception.dart';
import 'api_client.dart';
import 'secure_storage_service.dart';

class SubmissionResult {
  const SubmissionResult({required this.queuedOffline, this.syncedCount = 0});

  final bool queuedOffline;
  final int syncedCount;
}

class ComplaintSubmissionService {
  ComplaintSubmissionService({
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

  Future<SubmissionResult> submit(Map<String, dynamic> payload) async {
    final connectivity = await _connectivity.checkConnectivity();
    if (connectivity.contains(ConnectivityResult.none)) {
      await _queue.enqueue(payload);
      return const SubmissionResult(queuedOffline: true);
    }

    try {
      await _apiClient.post(
        '/complaints',
        body: payload,
        token: await _storage.readToken(),
      );
      return const SubmissionResult(queuedOffline: false);
    } on NetworkException {
      await _queue.enqueue(payload);
      return const SubmissionResult(queuedOffline: true);
    }
  }
}
