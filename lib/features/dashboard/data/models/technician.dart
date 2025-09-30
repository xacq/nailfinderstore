import 'service.dart';

class Technician {
  const Technician({
    required this.id,
    required this.displayName,
    this.bio,
    this.avatarUrl,
    this.rating,
    this.reviewsCount,
    this.services = const [],
  });

  final int id;
  final String displayName;
  final String? bio;
  final String? avatarUrl;
  final double? rating;
  final int? reviewsCount;
  final List<Service> services;

  factory Technician.fromJson(Map<String, dynamic> json) {
    final servicesJson = json['services'];
    final ratingValue = json['rating'] ?? json['score'];
    final reviewsValue = json['reviews'] ?? json['reviewsCount'];
    final firstName = (json['firstName'] as String?)?.trim();
    final lastName = (json['lastName'] as String?)?.trim();
    final rawName = (json['name'] as String?)?.trim();
    final combinedName = [firstName, lastName]
        .where((part) => part != null && part!.isNotEmpty)
        .join(' ')
        .trim();
    final resolvedName = (rawName?.isNotEmpty ?? false) ? rawName! : combinedName;
    final displayName = resolvedName.isEmpty ? 'Técnico sin nombre' : resolvedName;

    return Technician(
      id: (json['id'] as num?)?.toInt() ?? 0,
      displayName: displayName,
      bio: json['bio'] as String?,
      avatarUrl: json['avatarUrl'] as String? ?? json['photoUrl'] as String?,
      rating: _parseDouble(ratingValue),
      reviewsCount: _parseInt(reviewsValue),
      services: servicesJson is List
          ? servicesJson
              .whereType<Map<String, dynamic>>()
              .map(Service.fromJson)
              .toList()
          : const [],
    );
  }
}

double? _parseDouble(Object? value) {
  if (value is num) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value);
  }
  return null;
}

int? _parseInt(Object? value) {
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value);
  }
  return null;
}
