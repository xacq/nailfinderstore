import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../models/service.dart';
import '../models/service_category.dart';
import '../models/technician.dart';

class CatalogRemoteDataSource {
  CatalogRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<ServiceCategory>> fetchServiceCategories(String businessId) async {
    final response = await _dio.get('/businesses/$businessId/service-categories');
    final data = response.data;
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(ServiceCategory.fromJson)
          .toList();
    }
    if (data is Map<String, dynamic> && data['data'] is List) {
      return (data['data'] as List)
          .whereType<Map<String, dynamic>>()
          .map(ServiceCategory.fromJson)
          .toList();
    }
    return const [];
  }

  Future<List<Service>> fetchServices(String businessId) async {
    final response = await _dio.get('/businesses/$businessId/services');
    final data = response.data;
    if (data is List) {
      return data.whereType<Map<String, dynamic>>().map(Service.fromJson).toList();
    }
    if (data is Map<String, dynamic> && data['data'] is List) {
      return (data['data'] as List)
          .whereType<Map<String, dynamic>>()
          .map(Service.fromJson)
          .toList();
    }
    return const [];
  }

  Future<List<Technician>> fetchTechnicians(String businessId) async {
    final response = await _dio.get('/businesses/$businessId/technicians');
    final data = response.data;
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(Technician.fromJson)
          .toList();
    }
    if (data is Map<String, dynamic> && data['data'] is List) {
      return (data['data'] as List)
          .whereType<Map<String, dynamic>>()
          .map(Technician.fromJson)
          .toList();
    }
    return const [];
  }
}

final catalogRemoteDataSourceProvider = Provider<CatalogRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return CatalogRemoteDataSource(dio);
});
