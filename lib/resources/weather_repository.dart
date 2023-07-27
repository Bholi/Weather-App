import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:weather_for_you/model/weather_model.dart';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';

class WeatherRepository {
  Future<Either<String, Current>> fetchData({required String placeName}) async {
    try {
      final url =
          'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$placeName';
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        final current = Current.fromJson(data['current']);
        return Right(current);
      } else {
        return const Left("Failed to fetch weather data");
      }
    } on DioException catch (e) {
      return  Left(e.response?.data ?? "Unable to fetch data");
    } catch (e) {
      return Left(e.toString());
    }
  }

}
