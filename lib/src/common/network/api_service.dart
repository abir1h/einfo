import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/app.dart';
import '../constants/common_imports.dart';

class Server {
  static final Server _s = Server._();
  late http.Client _client;
  static Server get instance => _s;
  Server._() {
    _client = http.Client();
  }

  final StreamController<String> _sessionExpireStreamController =
      StreamController.broadcast();
  Stream<String> get onUnauthorizedRequest =>
      _sessionExpireStreamController.stream;

  static String get host => ApiCredential
      .baseUrl; //TODO must check is HOST url active for production build

  Future<ServerResponse> postRequest(
      {required String url,
      required dynamic postData,
      String? userToken}) async {
    try {
      var body = json.encode(postData);
      var response = await _client.post(
        Uri.parse("$host/api/$url"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${userToken ?? App.currentSession.token}"
        },
        body: utf8.encode(body),
      );
      debugPrint("REQUEST => ${response.request.toString()}");
      debugPrint("REQUEST DATA => $body");
      debugPrint("RESPONSE DATA => ${response.body.toString()}");

      var jsonData = jsonDecode(response.body);
      if (response.statusCode != 401) {
        return ServerResponse.fromJson(jsonData);
      } else {
        if (!_sessionExpireStreamController.isClosed) {
          _sessionExpireStreamController.sink.add(jsonData["message"]);
        }
        return ServerResponse(
            status: false, data: jsonData, message: jsonData["message"]);
      }
    } on SocketException catch (e) {
      return ServerResponse(
          status: false,
          data: e,
          message: "Request failed! Check internet connection.");
    } on Exception catch (e) {
      return ServerResponse(
          status: false,
          data: e,
          message: "Request failed! Unknown error occurred.");
    }
  }

  Future<ServerResponse> getRequest({required String url}) async {
    try {
      var response = await _client.get(Uri.parse("$host/api/$url"), headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer ${App.currentSession.token}"
      });
      debugPrint(
          "REQUEST => ${response.request.toString()}\nRESPONSE DATA => ${response.body.toString()}\n${App.currentSession.token}");

      var jsonData = jsonDecode(response.body);
      if (response.statusCode != 401) {
        return ServerResponse.fromJson(jsonData);
      } else {
        if (!_sessionExpireStreamController.isClosed) {
          _sessionExpireStreamController.sink.add(jsonData["message"]);
        }
        return ServerResponse(
            status: false, data: jsonData, message: jsonData["message"]);
      }
    } on SocketException catch (e) {
      return ServerResponse(
          status: false,
          data: e,
          message: "Request failed! Check internet connection.");
    } on Exception catch (e) {
      return ServerResponse(
          status: false,
          data: e,
          message: "Request failed! Unknown error occurred.");
    }
  }

  Future<ServerResponse> multipartPutRequest({
    required String url,
    required Map<String, String> fields, // Form data fields
    List<http.MultipartFile>? files, // Files to include
  }) async {
    try {
      var uri = Uri.parse("$host/api/$url");
      var request = http.MultipartRequest("PUT", uri);

      // Add fields to the request
      request.fields.addAll(fields);

      // Add authorization header
      request.headers.addAll({
        "Accept": "application/json",
        "Authorization": "Bearer ${App.currentSession.token}"

        // "Authorization":
        //     "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3Rlc3QtdjMtYXBpLmJhY2JvbnR1dG9ycy5jb20vYXBpL2xvZ2luIiwiaWF0IjoxNzQxNTgyMTk1LCJleHAiOjE3NDQxNzQxOTUsIm5iZiI6MTc0MTU4MjE5NSwianRpIjoidkRHclB4ZVNWdjc2RnlSaiIsInN1YiI6IjQiLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.taEhW-AKaBOX53hX9mI5-gTEb9cj2fzUNo6oZDGNV8M"
      });

      // Add files if provided
      if (files != null) {
        request.files.addAll(files);
      }

      debugPrint("REQUEST URL => $uri");
      debugPrint("REQUEST FIELDS => ${request.fields}");
      debugPrint("REQUEST HEADERS => ${request.headers}");
      debugPrint(
          "REQUEST FILES => ${files?.map((file) => file.filename).join(", ")}");

      // Send the request
      var response = await request.send();

      // Read and decode the response
      var responseBody = await response.stream.bytesToString();
      debugPrint("RESPONSE DATA => $responseBody");

      var jsonData = jsonDecode(responseBody);

      if (response.statusCode != 401) {
        return ServerResponse.fromJson(jsonData);
      } else {
        if (!_sessionExpireStreamController.isClosed) {
          _sessionExpireStreamController.sink.add(jsonData["message"]);
        }
        return ServerResponse(
            status: false, data: jsonData, message: jsonData["message"]);
      }
    } on SocketException catch (e) {
      return ServerResponse(
          status: false,
          data: e,
          message: "Request failed! Check internet connection.");
    } on Exception catch (e) {
      return ServerResponse(
          status: false,
          data: e,
          message: "Request failed! Unknown error occurred.");
    }
  }

  Future<ServerResponse> deleteRequest({required String url}) async {
    try {
      var response = await _client.delete(
        Uri.parse("$host/api/$url"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${App.currentSession.token}"
          //"Authorization": "Bearer ${App.currentSession.tokens.accessToken}"
        },
      );
      debugPrint("REQUEST => ${response.request.toString()}");
      debugPrint("RESPONSE DATA => ${response.body.toString()}");

      String decodedBody = utf8.decode(response.bodyBytes);
      var jsonData = jsonDecode(decodedBody);
      if (response.statusCode != 401) {
        return ServerResponse.fromJson(jsonData);
      } else {
        if (!_sessionExpireStreamController.isClosed) {
          _sessionExpireStreamController.sink.add(jsonData["message"]);
        }
        return ServerResponse(
            status: false, data: jsonData, message: jsonData["message"]);
      }
    } on SocketException catch (e) {
      return ServerResponse(
          status: false,
          data: e,
          message: "Request failed! Check internet connection.");
    } on Exception catch (e) {
      return ServerResponse(
          status: false,
          data: e,
          message: "Request failed! Unknown error occurred.");
    }
  }

  Future<ServerResponse> postRequestWithFile({
    required String url,
    required String fileField,
    required File file,
    required Map<String, String> bodyData,
  }) async {
    try {
      var request = http.MultipartRequest("POST", Uri.parse("$host/api/$url"));
      request.headers.addAll({
        "Accept": "application/json",
        "Authorization": "Bearer ${App.currentSession.token}"
      });

      bodyData.forEach((key, value) {
        request.fields[key] = value;
      });

      var attachedFile =
          await http.MultipartFile.fromPath(fileField, file.path);
      request.files.add(attachedFile);

      var response = await request.send();

      var value = await response.stream.bytesToString();
      var jsonData = jsonDecode(value);
      if (response.statusCode != 401) {
        return ServerResponse.fromJson(jsonData);
      } else {
        if (!_sessionExpireStreamController.isClosed) {
          _sessionExpireStreamController.sink.add(jsonData["message"]);
        }
        return ServerResponse(
            status: false, data: jsonData, message: jsonData["message"]);
      }
    } on SocketException catch (e) {
      return ServerResponse(
          status: false,
          data: e,
          message: "Request failed! Check internet connection.");
    } on Exception catch (e) {
      return ServerResponse(
          status: false,
          data: e,
          message: "Request failed! Unknown error occurred.");
    }
  }

  void uploadFile(
      {required String url,
      required File file,
      String? field = 'image',
      required void Function(ServerResponse response) onComplete}) async {
    try {
      var request = http.MultipartRequest("POST", Uri.parse("$host/api/$url"));
      request.headers.addAll({
        "Accept": "application/json",
        "Authorization": "Bearer ${App.currentSession.token}"
      });
      var attachedFile = await http.MultipartFile.fromPath('$field', file.path);
      request.files.add(attachedFile);
      var response = await request.send();

      if (response.statusCode == 200) {
        response.stream.transform(utf8.decoder).listen((value) {
          var jsonData = jsonDecode(value);
          onComplete(ServerResponse.fromJson(jsonData));
        });
      } else if (response.statusCode != 401) {
        if (!_sessionExpireStreamController.isClosed) {
          _sessionExpireStreamController.sink.add("Session expired!");
        }
        onComplete(ServerResponse(
            status: false,
            data: "",
            message: "Upload failed! Unauthorized user."));
      } else {
        onComplete(ServerResponse(
            status: false,
            data: "",
            message: "Upload failed! Unknown error occurred."));
      }
    } on SocketException catch (e) {
      onComplete(ServerResponse(
          status: false,
          data: e,
          message: "Request failed! Check internet connection."));
    } on Exception catch (e) {
      onComplete(ServerResponse(
          status: false,
          data: e,
          message: "Request failed! Unknown error occurred."));
    }
  }
  void postRequestWithNamedFiles({
    required String url,
    required dynamic postData,
    required Map<String, File> namedFiles, // fieldName -> File
    required void Function(ServerResponse response) onComplete,
  }) async {
    try {
      var request = http.MultipartRequest("POST", Uri.parse("$host/api/$url"));
      request.headers.addAll({
        "Accept": "application/json",
        "Authorization": "Bearer ${App.currentSession.token}"
      });

      // Add form fields
      request.fields.addAll(postData);

      // Add each file with its specific field name
      for (final entry in namedFiles.entries) {
        request.files.add(await http.MultipartFile.fromPath(
          entry.key, // this is the field name like "profile_picture"
          entry.value.path,
        ));
      }

      final response = await http.Response.fromStream(await request.send());
      debugPrint("REQUEST => ${response.request.toString()}");
      debugPrint("REQUEST DATA => $postData");
      debugPrint("RESPONSE DATA => ${response.body.toString()}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonData = json.decode(response.body);
        onComplete(ServerResponse.fromJson(jsonData));
      } else if (response.statusCode == 413) {
        onComplete(ServerResponse(
            status: false, data: "", message: "Files are too large"));
      } else if (response.statusCode == 401) {
        if (!_sessionExpireStreamController.isClosed) {
          _sessionExpireStreamController.sink.add("Session expired!");
        }
        onComplete(ServerResponse(
            status: false,
            data: "",
            message: "Upload failed! Unauthorized user."));
      } else {
        onComplete(ServerResponse(
            status: false,
            data: "",
            message: jsonDecode(response.body)["message"] ??
                "Request failed! Unknown error occurred."));
      }
    } on SocketException catch (e) {
      onComplete(ServerResponse(
          status: false,
          data: e,
          message: "Request failed! Check internet connection."));
    } on Exception catch (e) {
      onComplete(ServerResponse(
          status: false,
          data: e,
          message: "Request failed! Unknown error occurred."));
    }
  }

  void dispose() {
    _client.close();
    _sessionExpireStreamController.close();
  }
}

class ServerResponse {
  final dynamic data;
  final String message;
  final bool status;

  ServerResponse({this.data, required this.message, required this.status});

  factory ServerResponse.fromJson(Map<String, dynamic> json) => ServerResponse(
        status: json['status'] ?? false,
        message: json['message'] ?? "",
        data: json['data'],
      );
}
