import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'http_interceptors.dart';

class AuthService {
  //TODO: Modularizar essa URL para todos os services.
  static const String url = "http://192.168.1.112:3000/";

  http.Client client = InterceptedClient.build(
    interceptors: [LoggingInterceptor()],
  );

  Future<String> login(String email, String password) async {
    http.Response response = await client.post(
      Uri.parse("${url}login"),
      body: {"email": email, "password": password},
    );

    if (response.statusCode == 400 &&
        json.decode(response.body) == "Cannot find user") {
      throw UserNotFoundException();
    }

    if (response.statusCode != 200) {
      throw const HttpException("");
    }

    String token = json.decode(response.body)["accessToken"];
    print(token);
    saveToken(token);
    return token;
  }

  saveToken(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("accessToken", token);
  }
}

class UserNotFoundException implements Exception {}
