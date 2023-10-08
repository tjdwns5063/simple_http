// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// SimpleHttpGenerator
// **************************************************************************

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'example.dart';

final class TempServiceImpl extends TempService {
  @override
  Future<dynamic> getAll() async {
    String endPoint = '/api/v1/hello';
    Map<String, dynamic> queryParam = {};
    Map<String, String> headerParam = {};
    Uri uri = Uri.http('example.org', endPoint, queryParam);
    http.Response response = await http.get(uri, headers: headerParam);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      return Future.error('${response.statusCode}: ${response.body}');
    }

    return response.body;
  }

  @override
  Future<dynamic> delete(
    dynamic name,
    dynamic token,
    dynamic dto,
  ) async {
    String endPoint = '/api/v1/hello/$name';
    Map<String, dynamic> queryParam = {};
    String body = jsonEncode(dto.toJson());
    Map<String, String> headerParam = {'Authorization': token};
    Uri uri = Uri.http('example.org', endPoint, queryParam);
    http.Response response =
        await http.delete(uri, headers: headerParam, body: body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      return Future.error('${response.statusCode}: ${response.body}');
    }

    return response.body;
  }

  @override
  Future<dynamic> post(
    dynamic token,
    dynamic dto,
  ) async {
    String endPoint = '/api/v1/dto';
    Map<String, dynamic> queryParam = {};
    String body = jsonEncode(dto.toJson());
    Map<String, String> headerParam = {'Authorization': token};
    Uri uri = Uri.http('example.org', endPoint, queryParam);
    http.Response response =
        await http.post(uri, headers: headerParam, body: body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      return Future.error('${response.statusCode}: ${response.body}');
    }

    return response.body;
  }

  @override
  Future<dynamic> put(
    dynamic token, {
    dynamic dto,
    dynamic id,
  }) async {
    String endPoint = '/api/v1/dto/$id';
    Map<String, dynamic> queryParam = {};
    String body = jsonEncode(dto.toJson());
    Map<String, String> headerParam = {'Authorization': token};
    Uri uri = Uri.http('example.org', endPoint, queryParam);
    http.Response response =
        await http.put(uri, headers: headerParam, body: body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      return Future.error('${response.statusCode}: ${response.body}');
    }

    return response.body;
  }

  @override
  Future<dynamic> patch(
    int a,
    int b, [
    int c = 1,
    int d = 2,
  ]) async {
    String endPoint = '/api/v1/dto/{id}';
    Map<String, dynamic> queryParam = {};
    String body = '{}';
    Map<String, String> headerParam = {};
    Uri uri = Uri.http('example.org', endPoint, queryParam);
    http.Response response =
        await http.patch(uri, headers: headerParam, body: body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      return Future.error('${response.statusCode}: ${response.body}');
    }

    return response.body;
  }
}
