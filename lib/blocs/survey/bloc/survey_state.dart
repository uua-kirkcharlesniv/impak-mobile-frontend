part of 'survey_bloc.dart';

abstract class SurveyState extends Equatable {
  const SurveyState();

  @override
  List<Object?> get props => [];
}

class InitialSurveyState extends SurveyState {}

class LoadingSurveyState extends SurveyState {}

class FailedSurveyState extends SurveyState {}

class LoadedSurveyState extends SurveyState {
  final Map<String, dynamic> survey;
  final bool isMeasuringTheBasics;

  const LoadedSurveyState({
    required this.survey,
    required this.isMeasuringTheBasics,
  });

  @override
  List<Object?> get props => [
        survey,
        isMeasuringTheBasics,
      ];
}
