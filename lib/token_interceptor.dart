import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenInterceptor implements RequestInterceptor, ResponseInterceptor {
  @override
  FutureOr<Request> onRequest(Request request) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'tokenAuth');
    final mHeader = Map<String, String>.from(request.headers);

    if (token != null && token.isNotEmpty) {
      mHeader.putIfAbsent('Authorization', () => 'Bearer $token');
    }

    final mRequest = Request(
      request.method,
      request.url,
      request.baseUri,
      headers: mHeader,
      body: request.body,
      multipart: request.multipart,
      parameters: request.parameters,
      parts: request.parts,
    );

    return mRequest;
  }

  @override
  FutureOr<Response> onResponse(Response<dynamic> response) async {
    if (response.statusCode == 401) {
      await const FlutterSecureStorage().delete(key: 'tokenAuth');
    }

    return response;
  }
}
