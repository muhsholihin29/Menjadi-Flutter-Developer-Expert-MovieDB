import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/movie.dart';
import '../../../domain/entities/movie_detail.dart';
import '../../../domain/usecases/movie/get_movie_detail.dart';
import '../../../domain/usecases/movie/get_movie_recommendations.dart';

part 'movie_detail_state.dart';

class MovieDetailCubit extends Cubit<MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;

  bool _isAddedtoWatchlist = false;

  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  MovieDetailCubit({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
  }) : super(MovieDetailEmpty());

  Future<void> fetchMovieDetail(int id) async {
    emit(MovieDetailLoading());
    final result = await getMovieDetail.execute(id);
    final recommendationResult = await getMovieRecommendations.execute(id);
    result.fold(
      (failure) => emit(MovieDetailError(failure.message)),
      (value1) => {
        recommendationResult.fold(
          (failure) => emit(MovieDetailError(failure.message)),
          (value2) => emit(DetailHasData(value1, value2)),
        )
      },
    );
  }
}
