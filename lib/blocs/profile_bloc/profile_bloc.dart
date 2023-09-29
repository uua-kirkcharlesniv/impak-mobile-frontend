import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:impak_mobile/models/user_data.dart';
import 'package:impak_mobile/repository/authentication_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends HydratedBloc<ProfileEvent, ProfileState> {
  final AuthenticationRepository _authenticationRepository;

  ProfileBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(ProfileEmpty()) {
    on<ProfileStore>((event, emit) {
      hydrate();

      emit(ProfileUser(event.user));
    });
  }

  @override
  ProfileState fromJson(Map<String, dynamic> json) {
    try {
      final user = ProfileUser(UserData.fromJson(json));

      // FlutterAppBadger.isAppBadgeSupported().then((value) {
      //   print('IS APP BADGE SUPPORTED:' + value.toString());
      //   if (value) {
      // final box = Hive.openBox('notifications');
      // final currentNotificationCount = user.user.notificationCount;

      // box.then((box) {
      //   final storedNotificationCount = box.get('count');
      //   if (storedNotificationCount == null) {
      //     print(
      //       '[Notifications:debug] Stored notification count is null, showing all count.',
      //     );
      //     box.put('count', currentNotificationCount);

      //     FlutterAppBadger.updateBadgeCount(currentNotificationCount);
      //   } else {
      //     try {
      //       print(
      //         '[Notifications:debug] Stored notification count exists',
      //       );

      //       final parsedStoredNotificationCount =
      //           int.parse(storedNotificationCount.toString());

      //       print(
      //         '[Notifications:debug] Current stored: $parsedStoredNotificationCount',
      //       );

      //       final updatedNotificationCount =
      //           currentNotificationCount - parsedStoredNotificationCount;

      //       print(
      //         '[Notifications:debug] Updated notification count: $updatedNotificationCount',
      //       );

      //       if (updatedNotificationCount > 0) {
      //         print(
      //           '[Notifications:debug] Setting count to: $updatedNotificationCount',
      //         );
      //         FlutterAppBadger.updateBadgeCount(updatedNotificationCount);
      //       } else {
      //         print(
      //           '[Notifications:debug] Setting count to: 0',
      //         );
      //         FlutterAppBadger.updateBadgeCount(0);
      //       }
      //     } catch (e) {
      //       FlutterAppBadger.updateBadgeCount(currentNotificationCount);
      //     }
      //   }
      // });
      //   }
      // });

      return user;
    } catch (e) {
      _authenticationRepository.logOut();
      HydratedBloc.storage.delete('ProfileBloc').then((value) {
        const FlutterSecureStorage().delete(key: 'tokenAuth').then((value) {
          throw Exception(e);
        });
      });
      throw Exception(e);
    }
  }

  @override
  Map<String, dynamic>? toJson(ProfileState state) {
    try {
      if (state is ProfileUser) {
        return state.user.toJson();
      }
      return null;
    } catch (e) {
      throw Exception(e);
    }
  }
}
