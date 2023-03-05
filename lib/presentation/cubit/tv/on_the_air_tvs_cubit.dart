import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/tv.dart';
import '../../../domain/usecases/tv/get_on_the_air_tvs.dart';

part 'on_the_air_tvs_state.dart';

class OnTheAirTvsCubit extends Cubit<OnTheAirTvsState> {
  final GetOnTheAirTvs getOnTheAirTvs;

  OnTheAirTvsCubit(this.getOnTheAirTvs) : super(OnTheAirTvsEmpty());

  Future<void> fetchOnTheAirTvs() async {
    emit(OnTheAirTvsLoading());
    final result = await getOnTheAirTvs.execute();

    result.fold(
          (failure) => emit(OnTheAirTvsError(failure.message)),
          (value) => emit(OnTheAirTvsHasData(value)),
    );
  }
}