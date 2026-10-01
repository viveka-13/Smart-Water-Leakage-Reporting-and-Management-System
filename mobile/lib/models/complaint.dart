class Complaint {
  const Complaint({
    this.id,
    this.userId,
    this.category,
    this.title,
    this.description,
    this.priority,
    this.status,
    this.latitude,
    this.longitude,
    this.address,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final int? userId;
  final String? category;
  final String? title;
  final String? description;
  final String? priority;
  final String? status;
  final double? latitude;
  final double? longitude;
  final String? address;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: _toInt(json['id']),
      userId: _toInt(json['user_id']),
      category: json['category'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      priority: json['priority'] as String?,
      status: json['status'] as String?,
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      address: json['address'] as String?,
      imageUrl: json['image_url'] as String?,
      createdAt: json['created_at'] == null ? null : DateTime.tryParse(json['created_at']),
      updatedAt: json['updated_at'] == null ? null : DateTime.tryParse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'category': category,
      'title': title,
      'description': description,
      'priority': priority,
      'status': status,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'image_url': imageUrl,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
