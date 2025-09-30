import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/backend_config.dart';
import '../datasources/catalog_remote_data_source.dart';
import '../models/service.dart';
import '../models/service_category.dart';
import '../models/technician.dart';

class CatalogRepository {
  CatalogRepository(this._remoteDataSource);

  final CatalogRemoteDataSource _remoteDataSource;

  Future<List<ServiceCategory>> fetchServiceCategories(String businessId) {
    return _remoteDataSource.fetchServiceCategories(businessId);
  }

  Future<List<Service>> fetchServices(String businessId) {
    return _remoteDataSource.fetchServices(businessId);
  }

  Future<List<Technician>> fetchTechnicians(String businessId) {
    return _remoteDataSource.fetchTechnicians(businessId);
  }
}

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  final dataSource = ref.watch(catalogRemoteDataSourceProvider);
  return CatalogRepository(dataSource);
});

final selectedBusinessIdProvider = StateProvider<String>((_) => defaultBusinessId);
