import 'package:base/utils/constant.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'Client.g.dart';

@lazySingleton
@RestApi(baseUrl: Constants.BASE_URL)
abstract class Client {
  @factoryMethod
  factory Client(Dio dio) = _Client;
}
