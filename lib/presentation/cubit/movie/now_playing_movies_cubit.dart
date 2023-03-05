import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/movie/get_now_playing_movies.dart';

part 'now_playing_movies_state.dart';

class NowPlayingMoviesCubit extends Cubit<NowPlayingMoviesState> {
  final GetNowPlayingMovies getNowPlayingMovies;

  NowPlayingMoviesCubit(this.getNowPlayingMovies) : super(NowPlayingMoviesEmpty());

  Future<void> fetchNowPlayingMovies() async {
    emit(NowPlayingMoviesLoading());
    final result = await getNowPlayingMovies.execute();

    result.fold(
          (failure) => emit(NowPlayingMoviesError(failure.message)),
          (value) => emit(NowPlayingMoviesHasData(value)),
    );
  }
}