class Service {
  const Service({
    required this.id,
    required this.name,
    this.description,
    this.price,
    this.durationMinutes,
    this.imageUrl,
    this.categoryId,
  });

  final int id;
  final String name;
  final String? description;
  final double? price;
  final int? durationMinutes;
  final String? imageUrl;
  final int? categoryId;

  factory Service.fromJson(Map<String, dynamic> json) {
    final metadata = json['metadata'];
    final metadataMap = metadata is Map<String, dynamic> ? metadata : null;
    final rawName = (json['name'] ?? json['title']) as String?;
    final description = json['description'] as String? ??
        (metadataMap != null ? metadataMap['description'] as String? : null);
    final price = _parseDouble(json['price']) ??
        _parseDouble(metadataMap != null ? metadataMap['price'] : null);
    final duration = _parseInt(json['duration'] ?? json['durationMinutes']) ??
        _parseInt(metadataMap != null ? metadataMap['duration'] : null);
    final imageUrl = (json['imageUrl'] ??
            (metadataMap != null ? metadataMap['imageUrl'] : null))
        as String?;
    final categoryId = _parseInt(json['serviceCategoryId']) ??
        _parseInt(metadataMap != null ? metadataMap['serviceCategoryId'] : null);

    return Service(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (rawName == null || rawName.isEmpty) ? 'Servicio sin nombre' : rawName,
      description: description,
      price: price,
      durationMinutes: duration,
      imageUrl: imageUrl,
      categoryId: categoryId,
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
