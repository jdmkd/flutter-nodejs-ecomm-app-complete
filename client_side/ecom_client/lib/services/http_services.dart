import 'dart:convert';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_connect.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../utility/constants.dart';

class HttpService {
  final String baseUrl = AppConfig.baseUrl;

  Future<Response> getItems({required String endpointUrl}) async {
    try {
      return await GetConnect().get('$baseUrl/$endpointUrl');
    } catch (e) {
      return Response(
          body: json.encode({'error': e.toString()}), statusCode: 500);
    }
  }

  Future<Response> addItem(
      {required String endpointUrl, required dynamic itemData}) async {
    try {
      final response =
          await GetConnect().post('$baseUrl/$endpointUrl', itemData);
      log(
        "response.body ==> $response.body",
      );
      return response;
    } catch (e) {
      log('Error ==>: $e');
      return Response(
          body: json.encode({'message': e.toString()}), statusCode: 500);
    }
  }

  Future<Response> updateItem(
      {required String endpointUrl,
      required String itemId,
      required dynamic itemData,
      bool withAuth = false}) async {
    try {
      final headers = <String, String>{
        'Content-Type': 'application/json',
      };

      if (withAuth) {
        final box = GetStorage();
        final token = box.read('auth_token');
        if (token != null) {
          headers['Authorization'] = 'Bearer $token';
        }
      }

      return await GetConnect().put(
        '$baseUrl/$endpointUrl/$itemId',
        itemData,
        headers: headers,
      );
    } catch (e) {
      return Response(
          body: json.encode({'message': e.toString()}), statusCode: 500);
    }
  }

  Future<Response> deleteItem(
      {required String endpointUrl, required String itemId}) async {
    try {
      return await GetConnect().delete('$baseUrl/$endpointUrl/$itemId');
    } catch (e) {
      return Response(
          body: json.encode({'message': e.toString()}), statusCode: 500);
    }
  }
}
