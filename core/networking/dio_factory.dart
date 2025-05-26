import 'package:dio/dio.dart';
import 'package:hr_app/core/cache_helper/cache_helper.dart';
import 'package:hr_app/core/cache_helper/cache_values.dart';
import 'package:hr_app/core/networking/end_points.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  static Dio dio = Dio();

  static Future<void> init() {
    BaseOptions baseOptions = BaseOptions(
      baseUrl: EndPoints.baseUrl,
      receiveDataWhenStatusError: true,
      validateStatus: (status) => true,
    );

    dio = Dio(baseOptions);
    addDioInterceptor();
    return Future.value();
  }

  Future<Response?> get({required String endPoint, data}) async {
    dio.options.headers = {
      "Accept": "application/json",
      "lang": CacheHelper.getCurrentLanguage().toString(),
      "Authorization": "Bearer ${CacheHelper.getData(key: 'token')}",
    };
    return await dio.get(endPoint, queryParameters: data);
  }

  Future<Response?> post({required String endPoint, data}) async {
    dio.options.headers = {
      "Accept": "application/json",
      "lang": CacheHelper.getCurrentLanguage().toString(),
      "Authorization":
          "Bearer ${await CacheHelper.getSecuredString(key: CacheKeys.userToken)}",
    };
    return await dio.post(endPoint, data: data);
  }

  static void addDioInterceptor() {
    dio.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        responseBody: true,
      ),
    );
  }
}
