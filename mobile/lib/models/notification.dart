class AppNotification {
  const AppNotification({
    this.id,
    this.complaintId,
    this.title,
    this.message,
    this.notificationType,
    this.isRead,
    this.createdAt,
  });

  final int? id;
  final int? complaintId;
  final String? title;
  final String? message;
  final String? notificationType;
  final bool? isRead;
  final DateTime? createdAt;

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as int?,
      complaintId: json['complaint_id'] as int?,
      title: json['title'] as String?,
      message: json['message'] as String?,
      notificationType: json['notification_type'] as String?,
      isRead: _toBool(json['is_read']),
      createdAt: json['created_at'] == null ? null : DateTime.tryParse(json['created_at']),
    );
  }

  static bool? _toBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is num) return value != 0;
    final normalized = value.toString().toLowerCase();
    return normalized == 'true' || normalized == '1';
  }
}
