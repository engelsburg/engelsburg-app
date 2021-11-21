import 'dart:convert';

import 'package:engelsburg_app/src/constants/api_constants.dart';
import 'package:engelsburg_app/src/models/engelsburg_api/dto/auth_info_dto.dart';
import 'package:engelsburg_app/src/models/engelsburg_api/dto/reset_password_dto.dart';
import 'package:engelsburg_app/src/models/engelsburg_api/dto/sign_in_request_dto.dart';
import 'package:engelsburg_app/src/models/engelsburg_api/dto/sign_up_request_dto.dart';
import 'package:engelsburg_app/src/models/result.dart';
import 'package:engelsburg_app/src/provider/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
      refreshJWT(context, auth);
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

  static void requestRelogin(BuildContext context, AuthModel auth) {
    show(context, AppLocalizations.of(context)!.unexpectedErrorMessage);
    auth.clear();
    Navigator.pushNamed(context, "/");
  }

  static void refreshJWT(BuildContext context, AuthModel auth) async {
    final refreshTokenUri = Uri.parse(
      ApiConstants.engelsburgApiRefreshUrl +
          "?refreshToken=" +
          auth.refreshToken!,
    );
    (await request(context, uri: refreshTokenUri, method: HttpMethod.get))
        .handle<AuthInfoDTO>(
      context,
      parse: (json) => AuthInfoDTO.fromJson(json),
      onError: (error) {
        requestRelogin(context, auth);
      },
      onSuccess: (dto) {
        if (dto != null && dto.validate) {
          auth.set(dto);
        }
      },
    );
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
    final uri = Uri.parse(
        ApiConstants.engelsburgApiArticlesUrl + Query.paging(paging).get());
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

  static Future<Result> signUp(
    BuildContext context, {
    required SignUpRequestDTO dto,
  }) async {
    final uri = Uri.parse(ApiConstants.engelsburgApiSignUpUrl);
    return await request(
      context,
      uri: uri,
      method: HttpMethod.post,
      body: dto,
      headers: ApiConstants.unauthenticatedEngelsburgApiHeaders,
    );
  }

  static Future<Result> signIn(
    BuildContext context, {
    required SignInRequestDTO dto,
  }) async {
    final uri = Uri.parse(ApiConstants.engelsburgApiSignInUrl);
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
    return await request(
      context,
      uri: uri,
      method: HttpMethod.get,
      cacheKey: "substitutes",
      headers: authenticatedEngelsburgApiHeaders(context),
    );
  }

  static Future<Result> substitutesByClass(
    BuildContext context, {
    required String className,
    int? date,
  }) async {
    final uri = Uri.parse(ApiConstants.engelsburgApiSubstitutesUrl +
        "/className" +
        Query.substituteByClass(className, date: date).get());
    return await request(
      context,
      uri: uri,
      method: HttpMethod.get,
      cacheKey: "substitutes_class_" + className,
      headers: authenticatedEngelsburgApiHeaders(context),
    );
  }

  static Future<Result> substitutesByTeacher(
    BuildContext context, {
    required String teacher,
    int? lesson,
    String? className,
    int? date,
  }) async {
    final uri = Uri.parse(
      ApiConstants.engelsburgApiSubstitutesUrl +
          "/teacher" +
          Query.substituteByTeacher(
            teacher,
            date: date,
            className: className,
            lesson: lesson,
          ).get(),
    );
    return await request(
      context,
      uri: uri,
      method: HttpMethod.get,
      cacheKey: "substitutes_teacher_" + teacher,
      headers: authenticatedEngelsburgApiHeaders(context),
    );
  }

  static Future<Result> substitutesBySubstituteTeacher(BuildContext context,
      {required String substituteTeacher, int? date}) async {
    final uri = Uri.parse(ApiConstants.engelsburgApiSubstitutesUrl +
        "/substituteTeacher" +
        Query.substituteBySubstituteTeacher(substituteTeacher, date: date)
            .get());
    return await request(
      context,
      uri: uri,
      method: HttpMethod.get,
      cacheKey: "substitutes_substitute_teacher_" + substituteTeacher,
      headers: authenticatedEngelsburgApiHeaders(context),
    );
  }

  static Future<Result> accountData(BuildContext context) async {
    final uri = Uri.parse(ApiConstants.engelsburgApiUserDataUrl);
    return await request(
      context,
      uri: uri,
      method: HttpMethod.get,
      headers: authenticatedEngelsburgApiHeaders(context),
    );
  }

  static Future<Result> deleteAccount(BuildContext context) async {
    final uri = Uri.parse(ApiConstants.engelsburgApiUserDataUrl);
    return await request(
      context,
      uri: uri,
      method: HttpMethod.delete,
      headers: authenticatedEngelsburgApiHeaders(context),
    );
  }

  static Future<Result> verifyEmail(BuildContext context, String token) async {
    final uri =
        Uri.parse(ApiConstants.engelsburgApiVerifyEmailUrl + "/" + token);
    return await request(
      context,
      uri: uri,
      method: HttpMethod.patch,
      headers: authenticatedEngelsburgApiHeaders(context),
    );
  }

  static Future<Result> requestPasswordReset(
      BuildContext context, String email) async {
    final uri = Uri.parse(
      ApiConstants.engelsburgApiRequestPasswordResetUrl +
          Query.email(email).get(),
    );
    return await request(
      context,
      uri: uri,
      method: HttpMethod.post,
      headers: ApiConstants.unauthenticatedEngelsburgApiHeaders,
    );
  }

  static Future<Result> resetPassword(
      BuildContext context, ResetPasswordDTO dto) async {
    final uri = Uri.parse(ApiConstants.engelsburgApiResetPasswordUrl);
    return await request(
      context,
      uri: uri,
      body: dto,
      method: HttpMethod.patch,
      headers: ApiConstants.unauthenticatedEngelsburgApiHeaders,
    );
  }
}

class Query {
  Query(this._query);

  Query.all(Iterable<Query> queries) {
    _query.addAll(queries.map((e) => e._query).reduce((val, e) {
      val.addAll(e);
      return val;
    }));
  }

  Query.date(num date) {
    _query = {
      "date": date,
    };
  }

  Query.email(String email) {
    _query = {
      "email": email,
    };
  }

  Query.paging(Paging paging) {
    _query = {
      "page": paging.page,
      "size": paging.size,
    };
  }

  Query.substituteByClass(String className, {int? date}) {
    _query = {
      "className": className,
      if (date != null) "date": date,
    };
  }

  Query.substituteByTeacher(String teacher,
      {int? lesson, String? className, int? date}) {
    _query = {
      "teacher": teacher,
      if (lesson != null) "lesson": lesson,
      if (className != null) "className": className,
      if (date != null) "date": date,
    };
  }

  Query.substituteBySubstituteTeacher(String substituteTeacher, {int? date}) {
    _query = {
      "substituteTeacher": substituteTeacher,
      if (date != null) "date": date,
    };
  }

  late final Map<String, dynamic> _query;

  static String parse(Map<String, dynamic> query) {
    StringBuffer buffer = StringBuffer();
    bool started = false;

    query.forEach((key, value) {
      if (!started) {
        started = true;
        buffer.write("?");
      } else {
        buffer.write("&");
      }
      buffer.write(key);
      buffer.write("=");
      buffer.write(value);
    });

    return buffer.toString();
  }

  String get() {
    return parse(_query);
  }

  Query add(Query query) {
    _query.addAll(query._query);

    return this;
  }
}

enum HttpMethod { get, post, patch, delete }
