import 'package:bloc/bloc.dart';
import 'package:chopper/chopper.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:impak_mobile/chopper/api_service.dart';

part 'survey_event.dart';
part 'survey_state.dart';

class SurveyBloc extends Bloc<SurveyEvent, SurveyState> {
  SurveyBloc() : super(InitialSurveyState()) {
    on<LoadSurvey>((event, emit) async {
      emit(LoadingSurveyState());

      final survey = await GetIt.instance
          .get<ChopperClient>()
          .getService<ApiService>()
          .getSurveyDetails(event.id.toString());

      var isMeasuringTheBasics = false;
      final frameworkId = survey.body['data']['framework_id'];
      if (kDebugMode) {
        isMeasuringTheBasics = frameworkId == 32 || frameworkId == 31;
      } else {
        isMeasuringTheBasics = frameworkId == 1 || frameworkId == 2;
      }

      emit(
        LoadedSurveyState(
          survey: survey.body['data'],
          isMeasuringTheBasics: isMeasuringTheBasics,
        ),
      );
    });
  }
}
