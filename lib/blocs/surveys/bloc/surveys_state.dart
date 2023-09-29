part of 'surveys_bloc.dart';

abstract class SurveysState extends Equatable {
  const SurveysState();

  @override
  List<Object?> get props => [];
}

class InitialSurveysState extends SurveysState {}

class LoadingSurveysState extends SurveysState {}

class FailedSurveysState extends SurveysState {}

class LoadedSurveysState extends SurveysState {
  final List<dynamic> ongoing;
  final List<dynamic> completed;

  const LoadedSurveysState({
    required this.ongoing,
    required this.completed,
  });

  @override
  List<Object?> get props => [
        ongoing,
        completed,
      ];
}
