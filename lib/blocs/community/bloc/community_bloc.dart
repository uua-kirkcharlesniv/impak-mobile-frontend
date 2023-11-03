import 'package:bloc/bloc.dart';
import 'package:chopper/chopper.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:impak_mobile/chopper/api_service.dart';

part 'community_event.dart';
part 'community_state.dart';

class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  CommunityBloc({
    required this.isGroup,
  }) : super(InitialCommunityState()) {
    on<LoadCommunity>((event, emit) async {
      emit(LoadingCommunityState());
      final communities = await GetIt.instance
          .get<ChopperClient>()
          .getService<ApiService>()
          .getCommunity({
        'type': isGroup ? 'groups' : 'departments',
      });

      await Future.delayed(const Duration(seconds: 2));

      emit(LoadedCommunityState(communities: communities.body['data']));
    });
  }

  final bool isGroup;
}
