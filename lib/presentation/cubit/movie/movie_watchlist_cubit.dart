import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/movie_detail.dart';
import '../../../domain/usecases/get_watchlist_movie_status.dart';
import '../../../domain/usecases/remove_watchlist_movie.dart';
import '../../../domain/usecases/save_watchlist_movie.dart';

part 'movie_watchlist_state.dart';

class MovieWatchlistCubit extends Cubit<MovieWatchlistState> {
  final GetWatchListMovieStatus getWatchListStatus;
  final SaveWatchlistMovie saveWatchlist;
  final RemoveWatchlistMovie removeWatchlist;

  bool _isAddedtoWatchlist = false;

  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  MovieWatchlistCubit({
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(MovieWatchlistEmpty());

  Future<void> addWatchlist(MovieDetail movie) async {
    emit(MovieWatchlistLoading());
    final result = await saveWatchlist.execute(movie);
    result.fold(
      (failure) => emit(MovieWatchlistError(failure.message)),
      (value) => emit(MovieWatchlistMessageHasData(value)),
    );
    await loadWatchlistStatus(movie.id);
  }

  void deleteWatchlist(MovieDetail movie) async {
    final result = await removeWatchlist.execute(movie);
    result.fold(
      (failure) => emit(MovieWatchlistError(failure.message)),
      (value) => emit(MovieWatchlistMessageHasData(value)),
    );
    await loadWatchlistStatus(movie.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatus.execute(id);
    emit(MovieWatchlistStatusHasData(result));
  }
}
