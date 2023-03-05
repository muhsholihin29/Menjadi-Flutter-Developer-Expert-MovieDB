import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/movie/get_popular_movies.dart';

part 'popular_movies_state.dart';

class PopularMoviesCubit extends Cubit<PopularMoviesState> {
  final GetPopularMovies getPopularMovies;

  PopularMoviesCubit(this.getPopularMovies) : super(PopularMoviesEmpty());

  Future<void> fetchPopularMovies() async {
    emit(PopularMoviesLoading());
    final result = await getPopularMovies.execute();

    result.fold(
          (failure) => emit(PopularMoviesError(failure.message)),
          (value) => emit(PopularMoviesHasData(value)),
    );
  }
}