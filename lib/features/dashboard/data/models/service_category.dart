class ServiceCategory {
  const ServiceCategory({
    required this.id,
    required this.name,
    this.description,
  });

  final int id;
  final String name;
  final String? description;

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    final id = (json['id'] as num?)?.toInt() ?? 0;
    final rawName = (json['name'] ?? json['title']) as String?;

    return ServiceCategory(
      id: id,
      name: (rawName == null || rawName.isEmpty) ? 'Categoría $id' : rawName,
      description: json['description'] as String?,
    );
  }
}
