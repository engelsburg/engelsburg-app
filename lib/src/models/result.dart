import 'dart:convert';

import 'package:engelsburg_app/src/constants/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Result {
  Result._of(this.result);
  Result._error(this.error);
  Result._empty();

  Map<String, dynamic>? result;
  ApiError? error;

  bool errorPresent() {
    return error != null;
  }

  bool resultPresent() {
    return result != null;
  }

  factory Result.of(Map<String, dynamic> result) => Result._of(result);
  factory Result.error(ApiError apiError) => Result._error(apiError);
  factory Result.empty() => Result._empty();
  static final expectEmpty = Result.empty();

  Widget handle<T>(T Function(Map<String, dynamic>) parse,
      Widget? Function(ApiError)? onError, Widget Function(T) onSuccess) {
    Widget? ret;
    if (errorPresent()) {
      //If error occurred
      if (onError != null) ret = onError(error!); //Error which could be thrown
      return ret ?? handleCommonError(); //If error wasn't handled
    } else {
      if (resultPresent() && T is! Result) {
        //If result present and valid parse function specified
        return onSuccess(parse(
            result!)); //Return Widget function onSuccess with parsed result
      } else if (T is Result) {
        //Otherwise if empty result is expected
        return onSuccess(expectEmpty as T); //Return onSuccess without parse
      } else {
        //If nothing handled, try common errors
        return handleCommonError();
      }
    }
  }

  Widget handleCommonError() {
    if (errorPresent()) {
      //Handle errors
      if (error!.status == 0) {
        //Custom status to handle fetching errors
        //TODO: no network connection, error fetching
      } else if (error!.status == 400) {
        if (error!.extra == 'token') {
          if (error!.messageKey == 'EXPIRED') {
            //TODO: get new JWT
          } else if (error!.messageKey == 'INVALID' ||
              error!.messageKey == 'FAILED') {
            //TODO: try to login again
          }
        }
      } else if (error!.status == 401) {
        //TODO: need to be logged in
      } else if (error!.status == 403) {
        //TODO: don't permitted
      }
    }

    return _handleUnexpectedError();
  }

  Widget _handleUnexpectedError() {
    return ApiError.errorBox(AppConstants.unexpectedError);
  }
}

class ApiError {
  int status;
  String messageKey;
  String extra;

  ApiError({required this.status, this.messageKey = '', this.extra = ''});

  factory ApiError.tryDecode(Response response) {
    try {
      if (response.body.isNotEmpty) {
        Map<String, dynamic> json = jsonDecode(response.body);
        if (json.containsKey("status")) {
          return ApiError.fromJson(json);
        }
      }
    } catch (_) {}

    return ApiError.fromStatus(response.statusCode);
  }

  factory ApiError.fromJson(Map<String, dynamic> json) => ApiError(
      status: json['status'],
      messageKey: json['messageKey'],
      extra: json['extra']);

  factory ApiError.fromStatus(int status) => ApiError(status: status);

  static Widget errorBox(String text) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(64, 255, 125, 125),
            border: Border.all(color: const Color.fromARGB(125, 255, 0, 0)),
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(AppConstants.error.toUpperCase() + ':',
                  textScaleFactor: 1.3),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(text),
              )
            ],
            mainAxisSize: MainAxisSize.min,
          ),
        ),
      ),
    );
  }

  bool isNotFound() {
    return status == 404 && messageKey == 'NOT_FOUND';
  }

  bool isAlreadyExisting() {
    return status == 409 && messageKey == 'ALREADY_EXISTS';
  }
}
