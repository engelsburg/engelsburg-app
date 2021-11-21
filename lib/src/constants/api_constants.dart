class ApiConstants {
  static const unauthenticatedEngelsburgApiHeaders = {
    'Content-Type': 'application/json; charset=utf-8',
    'Accept': 'application/json; charset=utf-8'
  };
  static const engelsburgApiBaseUrl = 'http://10.0.2.2:8080';
  static const engelsburgApiEventsUrl = engelsburgApiBaseUrl + '/event';
  static const engelsburgApiArticlesUrl = engelsburgApiBaseUrl + '/article';
  static const engelsburgApiCafeteriaUrl = engelsburgApiBaseUrl + '/cafeteria';
  static const engelsburgApiSolarSystemUrl =
      engelsburgApiBaseUrl + '/solar_system';
  static const engelsburgApiSignUpUrl = engelsburgApiBaseUrl + '/auth/signup';
  static const engelsburgApiRefreshUrl = engelsburgApiBaseUrl + '/auth/refresh';
  static const engelsburgApiSubstituteMessageUrl =
      engelsburgApiBaseUrl + '/substitute/message';
  static const engelsburgApiSubstitutesUrl =
      engelsburgApiBaseUrl + "/substitute";
  static const engelsburgApiUserDataUrl = engelsburgApiBaseUrl + '/user/data';
  static const engelsburgApiSignInUrl = engelsburgApiBaseUrl + '/auth/login';

  static const engelsburgApiOAuthLoginUrl =
      engelsburgApiBaseUrl + "/auth/oauth";
  static const engelsburgApiOAuthGoogleLoginUrl =
      engelsburgApiOAuthLoginUrl + "/google";
  static const engelsburgApiVerifyEmailUrl =
      engelsburgApiBaseUrl + "/auth/verify";
  static const engelsburgApiResetPasswordUrl =
      engelsburgApiBaseUrl + "/auth/reset_password";
  static const engelsburgApiRequestPasswordResetUrl =
      engelsburgApiBaseUrl + "/auth/request_reset_password";
}
