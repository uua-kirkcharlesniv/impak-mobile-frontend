part of 'surveys_bloc.dart';

abstract class SurveysEvent extends Equatable {
  const SurveysEvent();

  @override
  List<Object> get props => [];
}

class LoadSurveys extends SurveysEvent {}
