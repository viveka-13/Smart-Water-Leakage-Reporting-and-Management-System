class AnalyticsBucket {
  const AnalyticsBucket({required this.label, required this.count});

  final String label;
  final int count;
}

class AnalyticsSummary {
  const AnalyticsSummary({
    required this.totalComplaints,
    required this.openComplaints,
    required this.resolvedComplaints,
    required this.averageResolutionHours,
    required this.averageRating,
    required this.feedbackCount,
    required this.byStatus,
    required this.byPriority,
    required this.byCategory,
  });

  final int totalComplaints;
  final int openComplaints;
  final int resolvedComplaints;
  final double averageResolutionHours;
  final double averageRating;
  final int feedbackCount;
  final List<AnalyticsBucket> byStatus;
  final List<AnalyticsBucket> byPriority;
  final List<AnalyticsBucket> byCategory;

  factory AnalyticsSummary.fromJson(Map<String, dynamic> json) {
    final summary = (json['summary'] as Map?)?.cast<String, dynamic>() ?? {};
    return AnalyticsSummary(
      totalComplaints: _toInt(summary['total_complaints']),
      openComplaints: _toInt(summary['open_complaints']),
      resolvedComplaints: _toInt(summary['resolved_complaints']),
      averageResolutionHours: _toDouble(summary['average_resolution_hours']),
      averageRating: _toDouble(summary['average_rating']),
      feedbackCount: _toInt(summary['feedback_count']),
      byStatus: _buckets(json['by_status'], 'status'),
      byPriority: _buckets(json['by_priority'], 'priority'),
      byCategory: _buckets(json['by_category'], 'category'),
    );
  }

  static List<AnalyticsBucket> _buckets(dynamic value, String key) {
    if (value is! List) return const [];
    return value.whereType<Map>().map((item) {
      return AnalyticsBucket(
        label: item[key]?.toString() ?? 'UNKNOWN',
        count: _toInt(item['count']),
      );
    }).toList();
  }

  static int _toInt(dynamic value) => int.tryParse(value?.toString() ?? '') ?? 0;
  static double _toDouble(dynamic value) => double.tryParse(value?.toString() ?? '') ?? 0;
}
