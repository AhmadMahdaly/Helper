import 'package:dio/dio.dart';
import 'package:.../core/services/auth_maneger/auth_service.dart';
import 'package:.../core/services/cache_helper/cache_helper.dart';
import 'package:.../core/services/cache_helper/cache_values.dart';
import 'package:.../core/services/connectivity_service.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioInterceptors {
  DioInterceptors(this.dio, this._connectivityService);
  final ConnectivityService _connectivityService;
  final Dio dio;
  InterceptorsWrapper languageInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        options.headers['Accept-Language'] =
            await CacheHelper.getLanguage() ?? 'en';
        return handler.next(options);
      },
    );
  }

  static bool _hasShown401Dialog = false;
  InterceptorsWrapper authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await CacheHelper.getSecuredString(
          key: CacheKeys.userToken,
        );
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        final shouldRetry = _shouldRetry(error);
        if (shouldRetry) {
          const maxRetries = 3;
          const retryDelay = Duration(seconds: 2);
          var retryCount =
              (error.requestOptions.extra['retryCount'] as int?) ?? 0;

          if (retryCount < maxRetries) {
            retryCount++;
            await Future.delayed(retryDelay);

            final newOptions = Options(
              method: error.requestOptions.method,
              headers: error.requestOptions.headers,
              extra: {...error.requestOptions.extra, 'retryCount': retryCount},
            );

            try {
              final response = await dio.request<dynamic>(
                error.requestOptions.path,
                data: error.requestOptions.data,
                queryParameters: error.requestOptions.queryParameters,
                options: newOptions,
              );
              return handler.resolve(response);
            } catch (e) {
              return handler.reject(e as DioException);
            }
          }
        }

        if (error.response?.statusCode == 401 && !_hasShown401Dialog) {
          _hasShown401Dialog = true;
          await AuthManager.logout();
        }

        return handler.next(error);
      },
    );
  }

  InterceptorsWrapper connectivityInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        if (!_connectivityService.hasInternet) {
          return handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.connectionError,
              error: 'No internet connection',
            ),
            true,
          );
        }
        return handler.next(options);
      },
    );
  }

  PrettyDioLogger debugeDioLogger() {
    return PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: true,
      error: true,
      compact: true,
      maxWidth: 90,
    );
  }
}

bool _shouldRetry(DioException error) {
  return error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.receiveTimeout ||
      error.response?.statusCode == 500;
}
