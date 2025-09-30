import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/service.dart';
import '../data/models/service_category.dart';
import '../data/models/technician.dart';
import '../data/repositories/catalog_repository.dart';

final serviceCategoriesProvider = FutureProvider.autoDispose<List<ServiceCategory>>((ref) async {
  final repository = ref.watch(catalogRepositoryProvider);
  final businessId = ref.watch(selectedBusinessIdProvider);
  return repository.fetchServiceCategories(businessId);
});

final servicesProvider = FutureProvider.autoDispose<List<Service>>((ref) async {
  final repository = ref.watch(catalogRepositoryProvider);
  final businessId = ref.watch(selectedBusinessIdProvider);
  return repository.fetchServices(businessId);
});

final techniciansProvider = FutureProvider.autoDispose<List<Technician>>((ref) async {
  final repository = ref.watch(catalogRepositoryProvider);
  final businessId = ref.watch(selectedBusinessIdProvider);
  return repository.fetchTechnicians(businessId);
});
