import 'package:flutter_test/flutter_test.dart';

import 'package:aquaguard_mobile/models/analytics_summary.dart';

void main() {
  test('parses analytics metrics and breakdown buckets', () {
    final summary = AnalyticsSummary.fromJson({
      'summary': {
        'total_complaints': 8,
        'open_complaints': 5,
        'resolved_complaints': 3,
        'average_resolution_hours': 18.5,
        'average_rating': 4.5,
        'feedback_count': 2,
      },
      'by_status': [
        {'status': 'RESOLVED', 'count': 3},
      ],
      'by_priority': [
        {'priority': 'HIGH', 'count': 4},
      ],
      'by_category': [
        {'category': 'PIPE_LEAKAGE', 'count': 5},
      ],
    });

    expect(summary.totalComplaints, 8);
    expect(summary.averageResolutionHours, 18.5);
    expect(summary.byStatus.single.label, 'RESOLVED');
    expect(summary.byPriority.single.count, 4);
    expect(summary.byCategory.single.label, 'PIPE_LEAKAGE');
  });

  test('uses safe defaults for incomplete analytics payloads', () {
    final summary = AnalyticsSummary.fromJson({});

    expect(summary.totalComplaints, 0);
    expect(summary.averageRating, 0);
    expect(summary.byStatus, isEmpty);
  });
}
