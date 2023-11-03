part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationStatusChanged extends AuthenticationEvent {
  const AuthenticationStatusChanged(
    this.status, {
    this.user,
    this.token,
  });

  final AuthenticationStatus status;
  final UserData? user;
  final String? token;

  @override
  List<Object> get props => [status];
}

class AuthenticationLogoutRequested extends AuthenticationEvent {}

class ProfileUpdated extends AuthenticationEvent {
  final UserData userData;

  const ProfileUpdated(this.userData);
}
