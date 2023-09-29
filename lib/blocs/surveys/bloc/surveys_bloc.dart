import 'package:bloc/bloc.dart';
import 'package:chopper/chopper.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:impak_mobile/chopper/api_service.dart';
import 'package:impak_mobile/navigation_service.dart';

part 'surveys_event.dart';
part 'surveys_state.dart';

class SurveysBloc extends Bloc<SurveysEvent, SurveysState> {
  SurveysBloc() : super(InitialSurveysState()) {
    on<LoadSurveys>((event, emit) async {
      emit(LoadingSurveysState());

      final completed = await GetIt.instance
          .get<ChopperClient>()
          .getService<ApiService>()
          .completedSurveys();

      final ongoing = await GetIt.instance
          .get<ChopperClient>()
          .getService<ApiService>()
          .availableSurveys();

      await Future.delayed(
        const Duration(seconds: 5),
      );

      emit(
        LoadedSurveysState(
          ongoing: ongoing.body['data'],
          completed: ongoing.body['data'],
        ),
      );
    });
  }
}
