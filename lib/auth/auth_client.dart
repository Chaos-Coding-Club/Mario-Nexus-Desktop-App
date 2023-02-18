import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:mario_nexus/auth/auth_failure.dart';
import 'package:mario_nexus/models/user.dart';
import 'package:mario_nexus/utils/secure_jwt_storage.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthClient {
  final SecureJwtStorage _secureJwtStorage;

  AuthClient(this._secureJwtStorage);

  Future<String?> getSignedInJwt() async {
    try {
      final storedCredentials = await _secureJwtStorage.getJwt();
      return storedCredentials;
    } on PlatformException {
      return null;
    }
  }

  Future<bool> isSignedIn() =>
      getSignedInJwt().then((credentials) => credentials != null);

  Future<Either<AuthFailure, User>> signIn(
      String email, String password) async {
    final endpoint = dotenv.env['API_KEY'];
    Dio dio = Dio();
    final Response response = await dio.post("$endpoint/auth/login",
        options: Options(
          method: "POST",
          headers: {
            "Accept": "application/json",
          },
          contentType: "application/json",
        ),
        data: jsonEncode({"email": email, "password": password}));
    if (response.statusCode != 200) {
      if (response.statusCode == 429) {
        return left(AuthFailure.server(
            "You are being rate limited. Try again after ${response.headers['Retry-After']} seconds."));
      } else {
        return left(const AuthFailure.server("Unable to process request"));
      }
    }
    final User user = User.fromJson(response.data["user"]);
    final Map<String, dynamic> decodedToken =
        JwtDecoder.decode(response.data["access_token"]);
    _secureJwtStorage.save(response.data["access_token"], user.id);
    return right(user);
  }

  Future<Either<AuthFailure, User>> regiser(
      String email, String password) async {
    final endpoint = dotenv.env['API_KEY'];
    Dio dio = Dio();
    final Response response = await dio.post(
      "$endpoint/auth/register",
      options: Options(
        method: "POST",
        headers: {
          "Accept": "application/json",
        },
        contentType: "application/json",
      ),
      data: jsonEncode({"email": email, "password": password}),
    );
    if (response.statusCode != 200) {
      if (response.statusCode == 429) {
        return left(AuthFailure.server(
            "You are being rate limited. Try again after ${response.headers['Retry-After']} seconds."));
      } else {
        return left(const AuthFailure.server("Unable to process request"));
      }
    }
    final User user = User.fromJson(response.data["user"]);
    final Map<String, dynamic> decodedToken =
        JwtDecoder.decode(response.data["access_token"]);
    _secureJwtStorage.save(response.data["access_token"], user.id);
    return right(user);
  }

  Future<Either<AuthFailure, Unit>> signOut() async {
    try {
      await _secureJwtStorage.clear();
      return right(unit);
    } on PlatformException {
      return left(const AuthFailure.storage());
    }
  }
}
