import 'package:deneme/model/currency.dart';
import 'package:dio/dio.dart';

class CurrencyApi {
  late Dio dio;

  CurrencyApi() {
    BaseOptions options = BaseOptions();
    options.baseUrl = "https://api.frankfurter.app/";
    dio = new Dio(options);
  }

  Future getCurrencies() async {
    return await dio.get("currencies");
  }

  Future getCurrency(String currencyCode) async {
    return await dio.get("latest?from=$currencyCode");
  }
}
