import 'dart:convert';

import 'package:engelsburg_app/src/constants/api_constants.dart';
import 'package:engelsburg_app/src/models/result.dart';
import 'package:http/http.dart' as http;

import 'shared_prefs.dart';

class ApiService {
  static Future<Result> request(
      {required Uri uri,
      required HttpMethod method,
      String? cacheKey,
      Map<String, String>? headers,
      Object? body //For all methods except get
      }) async {
    Result result; //To return
    try {
      if (cacheKey != null &&
          SharedPrefs.instance!.containsKey(cacheKey + '_hash')) {
        headers ??= {};
        headers['Hash'] = SharedPrefs.instance!.getString(cacheKey + '_hash')!;
      }

      http.Response res;
      switch (method) {
        //Execute request
        case HttpMethod.post:
          res = await http.post(uri,
              headers: headers, body: jsonEncode(body)); //Post
          break;
        case HttpMethod.patch:
          res = await http.patch(uri,
              headers: headers, body: jsonEncode(body)); //Patch
          break;
        case HttpMethod.delete:
          res = await http.delete(uri,
              headers: headers, body: jsonEncode(body)); //Delete
          break;
        default:
          res = await http.get(uri, headers: headers); //Get
      }

      if (!res.statusCode.toString().startsWith('2')) {
        //Check for error
        result = Result.error(ApiError.tryDecode(res));
      } else {
        //Body present or not?
        result =
            res.body.isEmpty ? Result.empty() : Result.of(jsonDecode(res.body));
      }

      if (result.errorPresent()) {
        //Check for not modified
        if (cacheKey != null) {
          String? cached = SharedPrefs.instance!.getString(cacheKey);
          if (cached != null) {
            result = Result.of(jsonDecode(cached));
          } else {
            //Something went horrible wrong!
            Result.error(ApiError.fromStatus(0));
            await SharedPrefs.instance!.remove(cacheKey + '_hash');
          }
        }
      }

      if (cacheKey != null && !result.errorPresent()) {
        //Cache if cacheKey given
        await SharedPrefs.instance!.setString(cacheKey, res.body);
        if (res.headers['Hash'] != null) {
          await SharedPrefs.instance!
              .setString(cacheKey + "_hash", res.headers['Hash']!);
        }
      }
    } catch (_) {
      //On IO error or similar, status = 0 represents fetching errors
      if (cacheKey != null) {
        String? cached = SharedPrefs.instance!.getString(cacheKey);
        result = cached != null
            ? Result.of(jsonDecode(cached))
            : Result.error(ApiError.fromStatus(0));
      } else {
        result = Result.error(ApiError.fromStatus(0));
      }
    }

    return result;
  }

  static Future<Result> getArticles() async {
    final uri = Uri.parse(ApiConstants.engelsburgApiArticlesUrl);
    return await request(
        uri: uri,
        method: HttpMethod.get,
        cacheKey: 'articles_json',
        headers: ApiConstants.unauthenticatedEngelsburgApiHeaders);
  }

  static Future<Result> getEvents() async {
    final uri = Uri.parse(ApiConstants.engelsburgApiEventsUrl);
    return await request(
        uri: uri,
        method: HttpMethod.get,
        cacheKey: 'events_json',
        headers: ApiConstants.unauthenticatedEngelsburgApiHeaders);
  }

  static Future<Result> getCafeteria() async {
    final uri = Uri.parse(ApiConstants.engelsburgApiCafeteriaUrl);
    return await request(
        uri: uri,
        method: HttpMethod.get,
        cacheKey: 'cafeteria_json',
        headers: ApiConstants.unauthenticatedEngelsburgApiHeaders);
  }

  static Future<Result> getSolarSystemData() async {
    final uri = Uri.parse(ApiConstants.engelsburgApiSolarSystemUrl);
    return await request(
        uri: uri,
        method: HttpMethod.get,
        cacheKey: 'solar_system_json',
        headers: ApiConstants.unauthenticatedEngelsburgApiHeaders);
  }
}

enum HttpMethod { get, post, patch, delete }
