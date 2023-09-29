// ignore_for_file: avoid_dynamic_calls

import 'dart:async';
import 'dart:convert';

import 'package:chopper/chopper.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:impak_mobile/chopper/api_service.dart';
import 'package:impak_mobile/models/user_data.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated, isLogin }

class AuthenticationRepository {
  AuthenticationRepository([this.user]);

  UserData? user;
  String? token;
  String? firebaseToken;
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> thirdPartyLogIn({
    required UserData newUser,
    required String passedToken,
  }) async {
    token = passedToken;
    user = newUser;
    // firebaseToken = await FirebaseMessaging.instance.getToken();

    // await FirebaseMessaging.instance.subscribeToTopic('all');

    _controller.add(AuthenticationStatus.authenticated);
  }

  Future<void> logIn({
    required String email,
    required String password,
  }) async {
    String? token;
    // try {
    //   final messaging = FirebaseMessaging.instance;
    //   token = await messaging.getToken();
    //   await messaging.subscribeToTopic('all');
    // } catch (e) {
    //   // no-op
    // }

    final resp = await GetIt.instance
        .get<ChopperClient>()
        .getService<ApiService>()
        .login(<String, dynamic>{
      'email': email,
      'password': password,
      'notification_token': token,
    });
    print(resp.error);
    print(resp.headers);
    print(resp.base.request?.url);

    if (!resp.isSuccessful) {
      throw Exception('The username or password you entered is incorrect.');
    }
    final parsed = UserData.fromJson(
      resp.body['user'] as Map<String, dynamic>,
    );

    // if (parsed.isMerchant && !parsed.isMerchantProfileCreated) {
    //   throw Exception(
    //     'You need to finish creating your merchant profile first.',
    //   );
    // }

    user = parsed;
    await const FlutterSecureStorage()
        .write(
      key: 'tokenAuth',
      value: resp.body['access_token'] as String,
    )
        .then((value) {
      const FlutterSecureStorage().read(key: 'tokenAuth').then((value) {
        _controller.add(AuthenticationStatus.authenticated);
      });
    });
  }

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    // final messaging = FirebaseMessaging.instance;
    // final token = await messaging.getToken();
    // await messaging.subscribeToTopic('all');

    // final resp = await GetIt.instance
    //     .get<ChopperClient>()
    //     .getService<ApiService>()
    //     .register(
    //   <String, dynamic>{
    //     'first_name': firstName,
    //     'last_name': lastName,
    //     'email': email,
    //     'password': password,
    //     'is_merchant': false,
    //     // 'token': token,
    //   },
    // );

    // if (!resp.isSuccessful) {
    //   final response =
    //       jsonDecode(resp.error.toString()) as Map<String, dynamic>;

    //   if (response['errors'] != null) {
    //     final data = response['errors'] as Map<String, dynamic>;
    //     final errors = <String>[];
    //     data.forEach((key, dynamic value) {
    //       for (final item in List<dynamic>.from(value as List)) {
    //         errors.add(item as String);
    //       }
    //     });
    //     if (errors.isNotEmpty) {
    //       throw Exception(errors.join(' '));
    //     }
    //   }
    // }

    // final box = await Hive.openBox<dynamic>('login');
    // await box.put('email', email);
    // user = UserData.fromJson(resp.body['user'] as Map<String, dynamic>);
    // await const FlutterSecureStorage()
    //     .write(
    //   key: 'tokenAuth',
    //   value: resp.body['access_token'] as String,
    // )
    //     .then((value) {
    //   const FlutterSecureStorage().read(key: 'tokenAuth').then((value) {
    //     _controller.add(AuthenticationStatus.authenticated);
    //   });
    // });
  }

  void logOut() {
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
