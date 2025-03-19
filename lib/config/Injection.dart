// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/io.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(initializerName: r'$initGetIt')
Future<void> configureDependencies() async => getIt.$initGetIt();

@module
abstract class ModuleRegister {
  @preResolve
  Future<SharedPreferences> sharedPreferences() async =>
      SharedPreferences.getInstance();

  @LazySingleton()
  Dio getDio(SharedPreferences sharedPreferences) {
    Dio dio = Dio();
    dio.httpClientAdapter = IOHttpClientAdapter(createHttpClient: () {
      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    });

    dio.interceptors.add(InterceptorsWrapper(onRequest: (
      RequestOptions options,
      RequestInterceptorHandler handler,
    ) {
      options.headers = {
        ...options.headers,
        HttpHeaders.contentTypeHeader: 'application/json',
      };
      handler.next(options);
    }));

    dio.interceptors.add(InterceptorsWrapper(onRequest: (
      RequestOptions options,
      RequestInterceptorHandler handler,
    ) {
      try {
        print('API request: ${options.method} ${options.uri}');
        print('API header request: ${jsonEncode(options.headers)}');
        print('API body request: ${jsonEncode(options.data)}');
      } catch (exception) {
        print('API request exception error parse: $exception');
      }
      handler.next(options);
    }, onResponse: (
      Response e,
      ResponseInterceptorHandler handler,
    ) {
      try {
        print('API response: ${e.requestOptions.method} ${e.requestOptions.uri}');
        print('API body response: ${jsonEncode(e.data)}');
      } catch (exception) {
        print('API response exception error parse: $exception');
      }
      handler.next(e);
    }, onError: (
      DioException e,
      ErrorInterceptorHandler handler,
    ) {
      try {
        print('API error: ${jsonEncode(e)} | ${e.requestOptions.method} ${e.requestOptions.uri}');
        print('API error header: ${jsonEncode(e.requestOptions.headers)}');
        print('API error body request: ${jsonEncode(e.requestOptions.data)}');
        print('API error body response: ${e.response?.data}');
        print('API error status : ${e.response?.statusCode} | ${e.response?.statusMessage}');
      } catch (exception) {
        print('API error exception error parse: $exception');
      }
      handler.next(e);
    }));

    return dio;
  }
}
