import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie/config/application.dart';
import 'package:movie/config/routes/routes_const.dart';
import 'package:movie/const/api_path.dart';
import 'package:movie/const/app_constants.dart' as constants;
import 'package:movie/main.dart';

class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) {
        /// Explicitly returning true to avoid handshake exception
        return true;
      });
  }
}

class RestAPIService {
  static RestAPIService? _instance;
  static late String _apiBaseUrl;

  RestAPIService._internal();

  static RestAPIService? getInstance() {
    _instance ??= RestAPIService._internal();

    _apiBaseUrl = "https://imdb8.p.rapidapi.com/";

    if (kDebugMode) {
      print(_apiBaseUrl);
    }

    return _instance;
  }

  /// Set the PNM API Base URL
  /// Called when setting syncing mobile app with other server
  set appAPIBaseUrlData(String data) {
    _apiBaseUrl = data;
  }

  String get appAPIBaseUrl => _apiBaseUrl;

  Future<dynamic> requestCall(
      {required String? apiEndPoint,
      required constants.RestAPIRequestMethods method,
      dynamic requestParmas,
      Map<String, dynamic>? addParams,
      bool isFileRequest = false,
      bool givenAPIUrl = false,
      bool addAutherization = false}) async {
    String? _apiEndPoint = apiEndPoint;

    Map<String, String> _httpHeaders = {
      HttpHeaders.contentTypeHeader: "application/json"
    };

    /// Check if [addParams] is not null and [_apiEndPoint] is having [:] then modify the apiEndpoint for [GET] request
    if (addParams != null) {
      _apiEndPoint = _modifyAPIEndPoint(_apiEndPoint, addParams);
    }

    /// make the complete URL of API
    Uri? _apiUrl;

    if (!givenAPIUrl) {
      /// Make complete API URL
      _apiUrl = Uri.parse('$_apiBaseUrl$_apiEndPoint');
    } else {
      _apiUrl = Uri.parse('$_apiEndPoint');
    }

    /// json encode the request params
    dynamic _requestParmas = json.encode(requestParmas);

    /// check the device OS for appending in request header

    dynamic responseJson;

    switch (method) {
      case constants.RestAPIRequestMethods.get:
        try {
          final response = await http.get(_apiUrl, headers: _httpHeaders);
          responseJson =
              _returnResponse(response, isFileRequest: isFileRequest);
        } on SocketException {
          responseJson = {
            "error":
                'No internet connection found, Please check your internet and try again!'
          };
        } on FormatException {
          responseJson = {
            "error":
                'Unable to process your request due to some failure, Please try again later!'
          };
        } on http.ClientException {
          responseJson = {
            "error":
                'Oh No! Unable to process your request. Possible cases may be server is not reachable or if server runs on VPN then VPN should be connected on mobile device!'
          };
        } catch (exe) {
          if (kDebugMode) {
            print(exe.toString());
          }
        }
        break;
      case constants.RestAPIRequestMethods.post:
        try {
          final response = await http.post(_apiUrl,
              body: _requestParmas, headers: _httpHeaders);
          responseJson = _returnResponse(response);
        } on SocketException {
          responseJson = {
            "error":
                'No internet connection found, Please check your internet and try again!'
          };
        } on FormatException {
          responseJson = {
            "error":
                'Unable to process your request due to some failure, Please try again later!'
          };
        } on http.ClientException {
          responseJson = {
            "error":
                'Oh No! Unable to process your request. Possible cases may be server is not reachable or if server runs on VPN then VPN should be connected on mobile device!'
          };
        } catch (exe) {
          if (kDebugMode) {
            print(exe.toString());
          }
        }

        break;
      case constants.RestAPIRequestMethods.put:
        try {
          final response = await http.put(_apiUrl,
              body: _requestParmas, headers: _httpHeaders);
          responseJson = _returnResponse(response);
        } on SocketException {
          responseJson = {
            "error":
                'No internet connection found, Please check your internet and try again!'
          };
        } on FormatException {
          responseJson = {
            "error":
                'Unable to process your request due to some failure, Please try again later!'
          };
        } on http.ClientException {
          responseJson = {
            "error":
                'Oh No! Unable to process your request. Possible cases may be server is not reachable or if server runs on VPN then VPN should be connected on mobile device!'
          };
        } catch (exe) {
          if (kDebugMode) {
            print(exe.toString());
          }
        }
        break;
      case constants.RestAPIRequestMethods.delete:
        try {
          /// normal delete request without body
          if (requestParmas == null) {
            final response = await http.delete(_apiUrl, headers: _httpHeaders);
            responseJson = _returnResponse(response);
          } else {
            /// delete request with body
            final request = http.Request("DELETE", _apiUrl);
            request.headers.addAll(_httpHeaders);
            request.body = json.encode(requestParmas);
            final streamedResponse = await request.send();
            final response = await http.Response.fromStream(streamedResponse);
            responseJson = _returnResponse(response);
          }
        } on SocketException {
          responseJson = {
            "error":
                'Unable to process your request due to some failure, Please try again later!'
          };
        } on FormatException {
          responseJson = {
            "error":
                'Unable to process your request due to some failure, Please try again later!'
          };
        } on http.ClientException {
          responseJson = {
            "error":
                'Unable to process your request due to some failure, Please try again later!'
          };
        } catch (exe) {
          if (kDebugMode) {
            print(exe.toString());
          }
        }
        break;
      case constants.RestAPIRequestMethods.patch:
        try {
          final response = await http.patch(_apiUrl,
              body: _requestParmas, headers: _httpHeaders);
          responseJson = _returnResponse(response);
        } on SocketException {
          responseJson = {
            "error":
                'Unable to process your request due to some failure, Please try again later!'
          };
        } on FormatException {
          responseJson = {
            "error":
                'Unable to process your request due to some failure, Please try again later!'
          };
        } on http.ClientException {
          responseJson = {
            "error":
                'Unable to process your request due to some failure, Please try again later!'
          };
        } catch (exe) {
          if (kDebugMode) {
            print(exe.toString());
          }
        }
        break;
      default:
        break;
    }
    return responseJson;
  }

  /// This function returns the apiEndPoints by modifying the Endpoint i.e by replacing the [:tmp] with actual content required for [GET] request
  static String? _modifyAPIEndPoint(
      String? apiEndPoint, Map<String, dynamic> addParams) {
    String? _modifiedAPIEndPoint = '$apiEndPoint?';
    String _requestParams = '';
    addParams.forEach((key, value) {
      _requestParams += "$key=${value.toString()}&";
    });
    _requestParams = _requestParams.substring(0, _requestParams.length - 1);
    return _modifiedAPIEndPoint + _requestParams;
  }

  //  This function is used k the file (Currently : image) to the server in the form of multipart/form-data
  Future<dynamic> multiPartRequestCall(
      {required String apiEndPoint,
      required String method,
      required String filesPath,
      constants.MediaType mediaType = constants.MediaType.Image,
      bool givenAPIUrl = false,
      Map<String, dynamic>? addParams}) async {
    String mediaExt = filesPath.split('.').last;

    var videoURLThumbnail;

    Dio dio = Dio();

    /// Create a signed url for thumbnail
    if (mediaExt.toLowerCase().contains("mp4") ||
        mediaExt.toLowerCase().contains("mov")) {
      // String videoLocalThumbnail =
      //     await Application.nativeAPIService!.genThumbnailFile(filesPath);
      // String thumbnailExt = videoLocalThumbnail.split('.').last;
      // videoURLThumbnail = await createSignedURL(
      //     videoLocalThumbnail, thumbnailExt, constants.MediaType.Image);

      // File thumbnailFile = File(videoLocalThumbnail);

      // try {
      // var response = await dio.put(
      //   videoURLThumbnail["url"],
      //   data: thumbnailFile.openRead(),
      //   options: Options(
      //     requestEncoder: (_, __) => thumbnailFile.readAsBytesSync(),
      //     headers: {
      //       HttpHeaders.contentTypeHeader: "image/$thumbnailExt",
      //       HttpHeaders.authorizationHeader: AppUser.authToken,
      //     },
      //   ),
      // );

      //   if (kDebugMode) {
      //     print(response);
      //   }
      // } catch (exe) {
      //   if (kDebugMode) {
      //     print({"error": exe.toString()});
      //     return {"error": exe.toString()};
      //   }
      // }
      // }
    }
  }

  static dynamic _returnResponse(http.Response response,
      {bool isFileRequest = false}) {
    if (response.reasonPhrase == "Conflict") {
      Navigator.pushNamedAndRemoveUntil(
          MovieApp.globalContext, AppRoutes.login, (route) => true);
      return;
    }
    switch (response.statusCode) {
      case 200:
      case 304:
      case 201:
        var returnJson = jsonDecode(response.body);
        return returnJson;
      case 204:
        Map<String, bool> _returnMap = {'success': true};
        return _returnMap;
      case 400:
        if (response.body.isNotEmpty) {
          var returnJson = jsonDecode(response.body);
          if (returnJson.containsKey("message")) {
            return {
              'error': returnJson["message"],
              'score': returnJson["score"] ?? null,
              "error_detail": returnJson["errors"]
            };
          }
        }
        return {'error': response.reasonPhrase};
      case 401:
      // return RestAPIUnAuthenticationModel.fromJson(_responseBody['error']);
      case 403:
        if (response.body.isNotEmpty) {
          var returnJson = jsonDecode(response.body);
          if (returnJson.containsKey("message")) {
            return {'error': returnJson["message"]};
          }
        }
        return {'error': response.reasonPhrase};
      case 404:
        if (response.body.isNotEmpty) {
          var returnJson = jsonDecode(response.body);
          if (returnJson.containsKey("message")) {
            return {'error': returnJson["message"]};
          }
        }
        return {'error': response.reasonPhrase};
      default:
        return {'error': response.reasonPhrase};
    }
  }

  Map<String, dynamic> getResponseBody(
      http.Response response, bool isFileRequest) {
    Map<String, dynamic> _responseBody = {};
    if (response.body.isNotEmpty && !isFileRequest) {
      /// decode the response
      var _jsonResponse = json.decode(response.body);

      /// Check if _responseBody is not Map and do not contains key ['data'] and ['error] then add that _responseBody with key 'data'
      /// Required for GIS API Call
      if (_jsonResponse is! Map ||
          (_jsonResponse['data'] == null && _jsonResponse['error'] == null)) {
        _responseBody = {'data': _jsonResponse};
      } else {
        _responseBody = _jsonResponse as Map<String, dynamic>;
      }
    } else if (response.body.isNotEmpty && isFileRequest) {
      String _base64String = base64.encode(response.bodyBytes);
      Uint8List _bytes = base64.decode(_base64String);
      _responseBody['file'] = _bytes;
    } else {
      _responseBody = {
        'error': {'code': 1111, 'message': 'Unexpected error'}
      };
    }
    return _responseBody;
  }
}
