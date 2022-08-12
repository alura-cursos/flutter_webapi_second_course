import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'http_interceptors.dart';

class AuthService {
  //TODO: Modularizar essa URL para todos os services.
  static const String url = "http://192.168.1.112:3000/";

  //TODO: Criar recursos para o próprio service

  http.Client client = InterceptedClient.build(
    interceptors: [LoggingInterceptor()],
  );

  Future<String> login(String email, String password) async {
    http.Response response = await client.post(
      Uri.parse("${url}login"),
      body: {"email": email, "password": password},
    );

    if (response.statusCode != 200) {
      verifyException(json.decode(response.body));
    }

    return saveInfosFromResponse(response.body);
  }

  Future<String> register(String email, String password) async {
    http.Response response = await client.post(
      Uri.parse("${url}register"),
      body: {"email": email, "password": password},
    );

    if (response.statusCode != 201) {
      verifyException(json.decode(response.body));
    }

    return saveInfosFromResponse(response.body);
  }

  Future<String> saveInfosFromResponse(String body) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Map<String, dynamic> map = json.decode(body);

    sharedPreferences.setString("accessToken", map["accessToken"]);
    sharedPreferences.setString("id", map["user"]["id"].toString());
    sharedPreferences.setString("email", map["user"]["email"]);

    return map["accessToken"];
  }

  verifyException(String error) {
    switch (error) {
      case "Email already exists":
        throw UserAlreadyExistsException();
      case "Cannot find user":
        throw UserNotFoundException();
      case "Email format is invalid":
        throw NotValidEmailException();
      case "Incorrect password":
        throw PasswordIncorrectException();
    }
    throw HttpException(error);
  }
}

class UserNotFoundException implements Exception {}

class UserAlreadyExistsException implements Exception {}

class NotValidEmailException implements Exception {}

class PasswordIncorrectException implements Exception {}
