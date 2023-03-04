import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/tv.dart';
import '../../../domain/entities/tv_detail.dart';
import '../../../domain/usecases/tv/get_tv_detail.dart';
import '../../../domain/usecases/tv/get_tv_recommendations.dart';

part 'tv_detail_state.dart';

class TvDetailCubit extends Cubit<TvDetailState> {
  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;

  bool _isAddedtoWatchlist = false;

  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  TvDetailCubit({
    required this.getTvDetail,
    required this.getTvRecommendations,
  }) : super(TvDetailEmpty());

  Future<void> fetchTvDetail(int id) async {
    emit(TvDetailLoading());
    final result = await getTvDetail.execute(id);
    final recommendationResult = await getTvRecommendations.execute(id);
    result.fold(
      (failure) => emit(TvDetailError(failure.message)),
      (value1) => {
        recommendationResult.fold(
          (failure) => emit(TvDetailError(failure.message)),
          (value2) => emit(DetailHasData(value1, value2)),
        )
      },
    );
  }
}
