part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileEmpty extends ProfileState {}

class ProfileError extends ProfileState {}

class ProfileUser extends ProfileState {
  const ProfileUser(this.user);

  final UserData user;

  @override
  List<Object> get props => [user];
}
