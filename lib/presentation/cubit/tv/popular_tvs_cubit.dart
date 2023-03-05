import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/tv.dart';
import '../../../domain/usecases/tv/get_popular_tvs.dart';

part 'popular_tvs_state.dart';

class PopularTvsCubit extends Cubit<PopularTvsState> {
  final GetPopularTvs getPopularTvs;

  PopularTvsCubit(this.getPopularTvs) : super(PopularTvsEmpty());

  Future<void> fetchPopularTvs() async {
    emit(PopularTvsLoading());
    final result = await getPopularTvs.execute();

    result.fold(
          (failure) => emit(PopularTvsError(failure.message)),
          (value) => emit(PopularTvsHasData(value)),
    );
  }
}