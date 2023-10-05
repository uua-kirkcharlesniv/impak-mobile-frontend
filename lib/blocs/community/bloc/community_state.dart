part of 'community_bloc.dart';

abstract class CommunityState extends Equatable {
  const CommunityState();

  @override
  List<Object?> get props => [];
}

class InitialCommunityState extends CommunityState {}

class LoadingCommunityState extends CommunityState {}

class FailedCommunityState extends CommunityState {}

class LoadedCommunityState extends CommunityState {
  final List<dynamic> communities;

  const LoadedCommunityState({
    required this.communities,
  });

  @override
  List<Object?> get props => [
        communities,
      ];
}
