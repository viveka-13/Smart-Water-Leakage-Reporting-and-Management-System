import 'package:flutter_test/flutter_test.dart';

import 'package:aquaguard_mobile/models/notification.dart';

void main() {
  test('parses MySQL integer notification read state', () {
    final notification = AppNotification.fromJson({
      'id': 1,
      'complaint_id': 3,
      'title': 'Work in progress',
      'message': 'A field worker has started work on your report.',
      'notification_type': 'STATUS_UPDATE',
      'is_read': 0,
      'created_at': '2026-10-01T10:00:00.000Z',
    });

    expect(notification.isRead, isFalse);
    expect(notification.complaintId, 3);
  });
}