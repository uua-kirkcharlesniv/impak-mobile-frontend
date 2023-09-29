part of 'survey_bloc.dart';

abstract class SurveyEvent extends Equatable {
  const SurveyEvent();

  @override
  List<Object> get props => [];
}

class LoadSurvey extends SurveyEvent {
  const LoadSurvey({
    required this.id,
  });

  final int id;

  @override
  List<Object> get props => [
        id,
      ];
}
