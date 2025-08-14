import 'package:dio/dio.dart';
import 'package:.../core/networking/dio_interceptors.dart';
import 'package:.../core/networking/end_points.dart';
import 'package:.../core/services/connectivity_service.dart';

class DioFactory {
  DioFactory(this._connectivityService);
  final ConnectivityService _connectivityService;
  Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: EndPoints.baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        headers: {'Accept': 'application/json'},
      ),
    );

    final dioInterceptors = DioInterceptors(dio, _connectivityService);

    dio.interceptors.addAll([
      // dioInterceptors.connectivityInterceptor(),
      dioInterceptors.authInterceptor(),
      dioInterceptors.languageInterceptor(),
      dioInterceptors.debugeDioLogger(),
    ]);

    return dio;
  }
}
