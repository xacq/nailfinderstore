import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'backend_config.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: backendBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: const {
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Content-Type'] = 'application/json';
        handler.next(options);
      },
      onError: (error, handler) {
        // Transform errors to provide clearer messages upstream.
        final response = error.response;
        if (response != null) {
          error = DioException(
            requestOptions: error.requestOptions,
            response: response,
            type: error.type,
            error: response.data is Map
                ? response.data['message'] ?? response.statusMessage
                : error.error,
          );
        }
        handler.next(error);
      },
    ),
  );

  return dio;
});
