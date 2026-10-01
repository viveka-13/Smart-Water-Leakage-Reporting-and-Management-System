import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class OfflineComplaintQueue {
  OfflineComplaintQueue({SharedPreferences? preferences}) : _preferences = preferences;

  static const _queueKey = 'offline_complaint_queue';
  SharedPreferences? _preferences;

  Future<SharedPreferences> get _store async {
    return _preferences ??= await SharedPreferences.getInstance();
  }

  Future<List<Map<String, dynamic>>> readAll() async {
    final values = (await _store).getStringList(_queueKey) ?? const [];
    return values
        .map(jsonDecode)
        .whereType<Map<String, dynamic>>()
        .toList();
  }

  Future<void> enqueue(Map<String, dynamic> payload) async {
    final queue = await readAll();
    queue.add({...payload, 'synced_from_offline': true});
    await (await _store).setStringList(
      _queueKey,
      queue.map(jsonEncode).toList(),
    );
  }

  Future<void> replaceAll(List<Map<String, dynamic>> queue) async {
    await (await _store).setStringList(
      _queueKey,
      queue.map(jsonEncode).toList(),
    );
  }

  Future<int> count() async => (await readAll()).length;
}