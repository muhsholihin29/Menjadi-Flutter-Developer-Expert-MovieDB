import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/tv.dart';
import '../../../domain/usecases/tv/get_top_rated_tvs.dart';

part 'top_rated_tvs_state.dart';

class TopRatedTvsCubit extends Cubit<TopRatedTvsState> {
  final GetTopRatedTvs getTopRatedTvs;

  TopRatedTvsCubit(this.getTopRatedTvs) : super(TopRatedTvsEmpty());

  Future<void> fetchTopRatedTvs() async {
    emit(TopRatedTvsLoading());
    final result = await getTopRatedTvs.execute();

    result.fold(
          (failure) => emit(TopRatedTvsError(failure.message)),
          (value) => emit(TopRatedTvsHasData(value)),
    );
  }
}