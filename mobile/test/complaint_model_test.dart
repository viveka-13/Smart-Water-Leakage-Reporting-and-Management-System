import 'package:flutter_test/flutter_test.dart';

import 'package:aquaguard_mobile/models/complaint.dart';

void main() {
  test('parses MySQL decimal coordinates serialized as strings', () {
    final complaint = Complaint.fromJson({
      'id': 3,
      'user_id': 1,
      'title': 'Live demo submission check',
      'category': 'PIPE_LEAKAGE',
      'description': 'Testing the citizen report submission against MySQL.',
      'priority': 'LOW',
      'status': 'REPORTED',
      'latitude': '19.07600000',
      'longitude': '72.87770000',
      'address': 'AquaGuard demo testing location',
    });

    expect(complaint.id, 3);
    expect(complaint.latitude, 19.076);
    expect(complaint.longitude, 72.8777);
  });
}