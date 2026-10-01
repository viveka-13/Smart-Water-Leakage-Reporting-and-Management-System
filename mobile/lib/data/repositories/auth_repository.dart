import '../../services/api_client.dart';
import '../../services/secure_storage_service.dart';

class AuthRepository {
  AuthRepository({
    ApiClient? apiClient,
    SecureStorageService? storage,
  })  : _apiClient = apiClient ?? ApiClient(),
        _storage = storage ?? const SecureStorageService();

  final ApiClient _apiClient;
  final SecureStorageService _storage;

  Future<Map<String, dynamic>> login({required String email, required String password}) async {
    final response = await _apiClient.post(
      '/auth/login',
      body: {'email': email.trim(), 'password': password},
    );
    return _saveSession(response);
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    final response = await _apiClient.post(
      '/auth/register',
      body: {
        'name': name.trim(),
        'email': email.trim(),
        'password': password,
        'phone': phone?.trim(),
      },
    );
    return _saveSession(response);
  }

  Future<Map<String, dynamic>> _saveSession(Map<String, dynamic> response) async {
    final data = response['data'];
    if (data is! Map) throw const FormatException('The server returned an invalid session.');
    final session = data.cast<String, dynamic>();
    final token = session['token'];
    final user = session['user'];
    if (token is! String || user is! Map) {
      throw const FormatException('The server returned an incomplete session.');
    }

    final userData = user.cast<String, dynamic>();
    await _storage.saveToken(token);
    await _storage.saveString('user_role', userData['role']?.toString() ?? 'citizen');
    await _storage.saveString('user_email', userData['email']?.toString() ?? '');
    return userData;
  }
}