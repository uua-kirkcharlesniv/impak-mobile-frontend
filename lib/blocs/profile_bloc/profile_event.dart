part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileStore extends ProfileEvent {
  const ProfileStore(this.user);

  final UserData user;

  @override
  List<Object> get props => [user];
}
