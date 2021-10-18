import 'dart:convert';

import 'package:engelsburg_app/src/constants/api_constants.dart';
import 'package:engelsburg_app/src/models/engelsburg_api/auth_info_dto.dart';
import 'package:engelsburg_app/src/models/engelsburg_api/sign_up_request_dto.dart';
import 'package:engelsburg_app/src/models/engelsburg_api/substitutes.dart';
import 'package:engelsburg_app/src/models/result.dart';
import 'package:engelsburg_app/src/provider/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'db_service.dart';
import 'shared_prefs.dart';

class ApiService {
  static Future<Result> request(BuildContext context,
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

    //If access token is expired
    AuthModel auth = context.read<AuthModel>();
    if (result.errorPresent() &&
        result.error!.isExpiredAccessToken &&
        auth.isLoggedIn) {
      final refreshTokenUri = Uri.parse(
        ApiConstants.engelsburgApiRefreshUrl +
            "?refreshToken=" +
            auth.refreshToken!,
      );
      (await request(context, uri: refreshTokenUri, method: HttpMethod.get))
          .handle<AuthInfoDTO>(
        context,
        parse: (json) => AuthInfoDTO.fromJson(json),
        onSuccess: (dto) {
          if (dto!.validate) {
            auth.setTokenPair(
              accessToken: dto.token!,
              refreshToken: dto.refreshToken!,
            );
          }
        },
      );
      if (headers != null && auth.isLoggedIn) {
        headers.update('Authorization', (value) => auth.accessToken!);
      }
      return request(
        context,
        uri: uri,
        method: method,
        cacheKey: cacheKey,
        body: body,
        headers: headers,
      );
    }

    return result;
  }

  static void show(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  static Map<String, String> authenticatedEngelsburgApiHeaders(
      BuildContext context) {
    AuthModel auth = context.read<AuthModel>();
    if (!auth.isLoggedIn) {
      return ApiConstants.unauthenticatedEngelsburgApiHeaders;
    }

    return {
      "Authorization": auth.accessToken!,
      ...ApiConstants.unauthenticatedEngelsburgApiHeaders
    };
  }

  static Future<Result> getArticles(BuildContext context, Paging paging) async {
    final uri =
        Uri.parse(ApiConstants.engelsburgApiArticlesUrl + _addPaging(paging));
    return await request(
      context,
      uri: uri,
      method: HttpMethod.get,
      cacheKey: 'articles_json',
      headers: ApiConstants.unauthenticatedEngelsburgApiHeaders,
    );
  }

  static Future<Result> getEvents(BuildContext context) async {
    final uri = Uri.parse(ApiConstants.engelsburgApiEventsUrl);
    return await request(
      context,
      uri: uri,
      method: HttpMethod.get,
      cacheKey: 'events_json',
      headers: ApiConstants.unauthenticatedEngelsburgApiHeaders,
    );
  }

  static Future<Result> getCafeteria(BuildContext context) async {
    final uri = Uri.parse(ApiConstants.engelsburgApiCafeteriaUrl);
    return await request(
      context,
      uri: uri,
      method: HttpMethod.get,
      cacheKey: 'cafeteria_json',
      headers: ApiConstants.unauthenticatedEngelsburgApiHeaders,
    );
  }

  static Future<Result> getSolarSystemData(BuildContext context) async {
    final uri = Uri.parse(ApiConstants.engelsburgApiSolarSystemUrl);
    return await request(
      context,
      uri: uri,
      method: HttpMethod.get,
      cacheKey: 'solar_system_json',
      headers: ApiConstants.unauthenticatedEngelsburgApiHeaders,
    );
  }

  static Future<Result> signUp(BuildContext context,
      {required SignUpRequestDTO dto}) async {
    final uri = Uri.parse(ApiConstants.engelsburgApiSignUpUrl);
    return await request(
      context,
      uri: uri,
      method: HttpMethod.post,
      body: dto,
      headers: ApiConstants.unauthenticatedEngelsburgApiHeaders,
    );
  }

  static Future<Result> substituteMessages(BuildContext context) async {
    final uri = Uri.parse(ApiConstants.engelsburgApiSubstituteMessageUrl);
    return await request(
      context,
      uri: uri,
      method: HttpMethod.get,
      cacheKey: "substitute_messages",
      headers: authenticatedEngelsburgApiHeaders(context),
    );
  }

  static Future<Result> substitutes(BuildContext context) async {
    final uri = Uri.parse(ApiConstants.engelsburgApiSubstitutesUrl);
    return Result.of(fakeSubstitutes().toJson());

    return await request(
      context,
      uri: uri,
      method: HttpMethod.get,
      cacheKey: "substitutes",
      headers: authenticatedEngelsburgApiHeaders(context),
    );
  }

  static Future<Result> substitutesByClass(BuildContext context,
      {required String className}) async {
    final uri =
        Uri.parse(ApiConstants.engelsburgApiSubstitutesUrl + "/className");
    return Result.of(fakeSubstitutes().toJson());

    return await request(
      context,
      uri: uri,
      method: HttpMethod.get,
      cacheKey: "substitutes_class_" + className,
      headers: authenticatedEngelsburgApiHeaders(context),
    );
  }

  static Future<Result> substitutesByTeacher(BuildContext context,
      {required String teacher}) async {
    final uri =
        Uri.parse(ApiConstants.engelsburgApiSubstitutesUrl + "/teacher");
    return Result.of(fakeSubstitutes().toJson());

    return await request(
      context,
      uri: uri,
      method: HttpMethod.get,
      cacheKey: "substitutes_teacher_" + teacher,
      headers: authenticatedEngelsburgApiHeaders(context),
    );
  }

  static Future<Result> substitutesBySubstituteTeacher(BuildContext context,
      {required String substituteTeacher}) async {
    final uri = Uri.parse(
        ApiConstants.engelsburgApiSubstitutesUrl + "/substituteTeacher");

    return Result.of(fakeSubstitutes().toJson());

    return await request(
      context,
      uri: uri,
      method: HttpMethod.get,
      cacheKey: "substitutes_substitute_teacher_" + substituteTeacher,
      headers: authenticatedEngelsburgApiHeaders(context),
    );
  }

  static Substitutes fakeSubstitutes() {
    return Substitutes(substitutes: [
      Substitute(
        date: "2020-09-19",
        className: "5c",
        lesson: "6",
        subject: "M",
        substituteTeacher: "EIC",
        teacher: "KRÄ",
        type: "Vertretung",
        room: "H001",
      )
    ]);
  }

  static String _addPaging(Paging paging) {
    return "?page=${paging.page}&size=${paging.size}";
  }
}

enum HttpMethod { get, post, patch, delete }
